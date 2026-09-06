pragma Singleton
import QtQuick
import Quickshell.Services.Pam

QtObject {
    id: root

    signal unlocked()
    signal authFailed()

    property alias message: pam.message
    property alias active: pam.active
    property alias responseRequired: pam.responseRequired
    property bool unlocking: false
    property string pendingPassword: ""

    property PamContext pamContext: PamContext {
        id: pam
        config: "login"

        onResponseRequiredChanged: {
            if (responseRequired) {
                pam.respond(root.pendingPassword)
            }
        }

        onCompleted: (result) => {
            root.unlocking = false
            if (result === PamResult.Success) {
                root.unlocked()
            } else {
                root.authFailed()   // new signal
            }
        }
    }

    function tryUnlock(password) {
        if (unlocking) return
        unlocking = true
        pendingPassword = password
        pam.start()
    }
}
