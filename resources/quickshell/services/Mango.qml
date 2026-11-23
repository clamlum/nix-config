pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property bool enabled: !!Quickshell.env("MANGO_INSTANCE_SIGNATURE")

    property var workspaces: []
    property var windows: []
    property int focusedWindowId: -1
    property var focusedWindow: null
    property string focusedOutput: ""

    property bool hideEmptyWorkspaces: true

    property bool refreshPending: false
    property string lastSnapshot: ""

    function scheduleRefresh() {
        if (!root.enabled)
            return
        debounce.restart()
    }

    function refreshNow() {
        if (stateProc.running) {
            root.refreshPending = true
            return
        }

        root.refreshPending = false
        const names = Quickshell.screens.map(s => s.name)
        stateProc.command = ["sh", "-c",
            'mmsg get all-clients; for m in "$@"; do mmsg get tags "$m"; done',
            "sh"].concat(names)
        stateProc.running = true
    }

    function applyState(text) {
        let clients = null
        const tagInfo = {}

        for (const line of text.split("\n")) {
            const s = line.trim()
            if (!s)
                continue
            let obj
            try {
                obj = JSON.parse(s)
            } catch (e) {
                continue
            }
            if (Array.isArray(obj.clients))
                clients = obj.clients
            else if (obj.monitor && Array.isArray(obj.tags))
                tagInfo[obj.monitor] = obj
        }

        if (clients === null)
            return

        const outputs = Quickshell.screens.map(s => s.name)

        const focusedClient = clients.find(c => c.is_focused)
        if (focusedClient)
            root.focusedOutput = focusedClient.monitor
        else if (root.focusedOutput === "" && outputs.length > 0)
            root.focusedOutput = outputs[0]

        const wsId = (out, idx) => (outputs.indexOf(out) + 1) * 100 + idx

        const wins = clients.map(c => {
            const info = tagInfo[c.monitor]
            const activeTags = info ? (info.active_tags || []) : []
            const tags = c.tags || []
            const tag = tags.find(t => activeTags.includes(t)) ?? tags[0]
            return Object.assign({}, c, {
                app_id: c.appid,
                output: c.monitor,
                workspace_id: tag !== undefined ? wsId(c.monitor, tag) : null
            })
        })

        const wsList = []
        for (const out of outputs) {
            const info = tagInfo[out]
            if (!info)
                continue

            const activeTags = info.active_tags || []
            let lastOccupied = 0
            for (const t of info.tags) {
                if (t.client_count > 0 && t.index > lastOccupied)
                    lastOccupied = t.index
            }

            for (const t of info.tags) {
                const isActive = t.is_active || activeTags.includes(t.index)
                if (root.hideEmptyWorkspaces
                        && t.client_count === 0
                        && !isActive
                        && t.index !== lastOccupied + 1)
                    continue

                const id = wsId(out, t.index)
                const inWs = wins.filter(w => w.workspace_id === id)
                const activeWin = inWs.find(w => w.is_focused) || inWs[0]

                wsList.push({
                    id: id,
                    idx: t.index,
                    name: null,
                    output: out,
                    is_active: isActive,
                    is_focused: isActive && out === root.focusedOutput,
                    is_urgent: t.is_urgent,
                    active_window_id: activeWin ? activeWin.id : null,
                    client_count: t.client_count,
                    layout: t.layout
                })
            }
        }

        const snapshot = JSON.stringify([wsList, wins, root.focusedOutput])
        if (snapshot === root.lastSnapshot)
            return
        root.lastSnapshot = snapshot

        root.workspaces = wsList
        root.windows = wins

        const focused = wins.find(w => w.is_focused) || null
        root.focusedWindow = focused
        root.focusedWindowId = focused ? focused.id : -1
    }

    function focusWorkspace(idx) {
        if (!root.enabled)
            return
        actionProc.command = ["mmsg", "dispatch", "view," + String(idx)]
        actionProc.running = true
    }

    function focusWindow(id) {
        if (!root.enabled)
            return
        actionProc.command = ["mmsg", "dispatch", "focusid", "client," + String(id)]
        actionProc.running = true
    }

    Process {
        id: stateProc
        stdout: StdioCollector {
            onStreamFinished: root.applyState(text)
        }
        onRunningChanged: {
            if (!running && root.refreshPending)
                root.refreshNow()
        }
    }

    Process {
        id: actionProc
    }

    Timer {
        id: debounce
        interval: 40
        onTriggered: root.refreshNow()
    }

    Process {
        id: clientsWatch
        command: ["mmsg", "watch", "all-clients"]
        running: root.enabled
        stdout: SplitParser {
            onRead: line => root.scheduleRefresh()
        }
        onRunningChanged: {
            if (!running && root.enabled)
                restartTimer.start()
        }
    }

    Process {
        id: tagsWatch
        command: ["mmsg", "watch", "all-tags"]
        running: root.enabled
        stdout: SplitParser {
            onRead: line => root.scheduleRefresh()
        }
        onRunningChanged: {
            if (!running && root.enabled)
                restartTimer.start()
        }
    }

    Process {
        id: monitorsWatch
        command: ["mmsg", "watch", "all-monitors"]
        running: root.enabled
        stdout: SplitParser {
            onRead: line => root.scheduleRefresh()
        }
        onRunningChanged: {
            if (!running && root.enabled)
                restartTimer.start()
        }
    }

    Timer {
        id: restartTimer
        interval: 1000
        onTriggered: {
            if (!root.enabled)
                return
            for (const p of [clientsWatch, tagsWatch, monitorsWatch]) {
                if (!p.running)
                    p.running = true
            }
        }
    }

    Connections {
        target: Quickshell
        function onScreensChanged() {
            root.scheduleRefresh()
        }
    }

    Component.onCompleted: scheduleRefresh()
}
