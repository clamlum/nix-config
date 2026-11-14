import QtQuick
import Quickshell.Wayland

WlSessionLockSurface {
    id: root
    property var lockContext

    LockContent {
        anchors.fill: parent
        lockContext: root.lockContext
    }
}
