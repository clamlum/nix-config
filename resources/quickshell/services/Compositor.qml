pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string name: Quickshell.env("NIRI_SOCKET") ? "niri"
        : Quickshell.env("MANGO_INSTANCE_SIGNATURE") ? "mango"
        : "unknown"

    readonly property var backend: name === "niri" ? Niri
        : name === "mango" ? Mango
        : null

    readonly property var workspaces: backend ? backend.workspaces : []
    readonly property var windows: backend ? backend.windows : []
    readonly property var focusedWindow: backend ? backend.focusedWindow : null
    readonly property int focusedWindowId: backend ? backend.focusedWindowId : -1

    function focusWorkspace(idx) {
        if (backend)
            backend.focusWorkspace(idx)
    }
}
