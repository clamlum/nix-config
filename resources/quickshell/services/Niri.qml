pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var workspaces: []
    property var windows: []
    property int focusedWindowId: -1
    property var focusedWindow: null
    property bool focusedWindowRefreshPending: false

    function parseJsonLine(line, apply) {
        try {
            apply(JSON.parse(line.trim()))
        } catch (e) {
        }
    }

    function syncFocusedWindowFromList(list) {
        const focused = Array.isArray(list) ? list.find(w => w?.is_focused) : null
        root.focusedWindow = focused || null
        root.focusedWindowId = focused ? focused.id : -1
    }

    function applyFocusedWindowId(id) {
        const nextId = id ?? -1
        root.focusedWindowId = nextId
        root.focusedWindow = root.windows.find(w => w.id === nextId) || null
        root.windows = root.windows.map(w => {
            const shouldBeFocused = w.id === nextId
            return w.is_focused === shouldBeFocused ? w : Object.assign({}, w, { is_focused: shouldBeFocused })
        })
    }

    function requestFocusedWindowRefresh() {
        if (focusedWindowProc.running) {
            root.focusedWindowRefreshPending = true
            return
        }

        root.focusedWindowRefreshPending = false
        focusedWindowProc.running = true
    }

    function upsertWindow(win) {
        const next = root.windows.slice()
        const i = next.findIndex(w => w.id === win.id)

        if (win.is_focused) {
            for (let j = 0; j < next.length; j++) {
                if (next[j].id !== win.id && next[j].is_focused)
                    next[j] = Object.assign({}, next[j], { is_focused: false })
            }
            root.focusedWindowId = win.id
            root.focusedWindow = win
        } else if (win.id === root.focusedWindowId) {
            root.focusedWindow = win
        }

        if (i >= 0)
            next[i] = win
        else
            next.push(win)

        root.windows = next
    }

    Process {
        id: workspacesProc
        command: ["sh", "-c", "niri msg -j workspaces 2>/dev/null | jq -c ."]
        running: true
        stdout: SplitParser {
            onRead: line => root.parseJsonLine(line, data => {
                if (Array.isArray(data))
                    root.workspaces = data
            })
        }
    }

    Process {
        id: windowsProc
        command: ["sh", "-c", "niri msg -j windows 2>/dev/null | jq -c ."]
        running: true
        stdout: SplitParser {
            onRead: line => root.parseJsonLine(line, data => {
                if (Array.isArray(data)) {
                    root.windows = data
                    root.syncFocusedWindowFromList(data)
                }
            })
        }
    }

    Process {
        id: focusedWindowProc
        command: ["sh", "-c", "niri msg -j focused-window 2>/dev/null | jq -c ."]
        running: true
        stdout: SplitParser {
            onRead: line => root.parseJsonLine(line, data => {
                const win = data?.id !== undefined ? data : null
                root.focusedWindow = win
                root.focusedWindowId = win ? win.id : -1
                if (win)
                    root.upsertWindow(Object.assign({}, win, { is_focused: true }))
                else
                    root.applyFocusedWindowId(null)
            })
        }
        onRunningChanged: {
            if (!running && root.focusedWindowRefreshPending) {
                root.focusedWindowRefreshPending = false
                running = true
            }
        }
    }

    Process {
        id: eventStream
        command: ["niri", "msg", "-j", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                let evt
                try {
                    evt = JSON.parse(line)
                } catch (e) {
                    return
                }

                if (evt.WorkspacesChanged) {
                    root.workspaces = evt.WorkspacesChanged.workspaces
                } else if (evt.WorkspaceActivated) {
                    const { id, focused } = evt.WorkspaceActivated
                    const target = root.workspaces.find(w => w.id === id)
                    const output = target ? target.output : null

                    root.workspaces = root.workspaces.map(w => {
                        const sameOutput = w.output === output
                        const next = Object.assign({}, w)

                        if (sameOutput)
                            next.is_active = (w.id === id)

                        if (w.id === id)
                            next.is_focused = focused
                        else if (focused)
                            next.is_focused = false

                        return next
                    })
                } else if (evt.WorkspaceActiveWindowChanged) {
                    const { workspace_id, active_window_id } = evt.WorkspaceActiveWindowChanged
                    root.workspaces = root.workspaces.map(w =>
                        w.id === workspace_id ? Object.assign({}, w, { active_window_id }) : w)
                    root.requestFocusedWindowRefresh()
                } else if (evt.WindowsChanged) {
                    root.windows = evt.WindowsChanged.windows
                    root.syncFocusedWindowFromList(evt.WindowsChanged.windows)
                } else if (evt.WindowOpenedOrChanged) {
                    const win = evt.WindowOpenedOrChanged.window
                    root.upsertWindow(win)
                    if (win.is_focused || win.id === root.focusedWindowId)
                        root.requestFocusedWindowRefresh()
                } else if (evt.WindowClosed) {
                    root.windows = root.windows.filter(w => w.id !== evt.WindowClosed.id)
                    if (root.focusedWindowId === evt.WindowClosed.id)
                        root.requestFocusedWindowRefresh()
                } else if (evt.WindowFocusChanged) {
                    root.applyFocusedWindowId(evt.WindowFocusChanged.id)
                    root.requestFocusedWindowRefresh()
                }
            }
        }
        onRunningChanged: {
            if (!running)
                restartTimer.start()
        }
    }

    Timer {
        id: restartTimer
        interval: 1000
        onTriggered: eventStream.running = true
    }

    Process {
        id: focusProc
    }

    function focusWorkspace(idx) {
        focusProc.command = ["niri", "msg", "action", "focus-workspace", String(idx)]
        focusProc.running = true
    }
}
