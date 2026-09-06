import QtQuick
import Quickshell.Wayland
import Quickshell.Io

Item {
    id: root

    WlSessionLock {
        id: lock

        surface: LockSurface {
            lockContext: LockContext
        }
    }

    IpcHandler {
        target: "lock"
        function activate(): void { lock.locked = true }
        function forceUnlock(): void { lock.locked = false }
    }

    Connections {
        target: LockContext
        function onUnlocked() {
            lock.locked = false
        }
    }
}
