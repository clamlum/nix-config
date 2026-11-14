pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Greetd

QtObject {
    id: root

    signal authFailed()

    property var users: []
    property var sessions: []
    property int userIndex: 0
    property int sessionIndex: 0

    readonly property string username: users.length ? users[userIndex] : ""
    readonly property var session: sessions.length
        ? sessions[sessionIndex]
        : ({ name: "shell", command: ["bash"] })

    property bool active: Greetd.state !== GreetdState.Inactive
    property bool responseRequired: false
    property string pendingPassword: ""

    property FileView dataFile: FileView {
        path: Quickshell.env("GREETER_DATA") ?? ""
        blockLoading: true
        printErrors: false
    }

    property FileView stateFile: FileView {
        path: Quickshell.env("GREETER_STATE") ?? ""
        blockLoading: true
        printErrors: false
    }

    Component.onCompleted: {
        try {
            const d = JSON.parse(root.dataFile.text())
            root.users = d.users ?? []
            root.sessions = d.sessions ?? []
        } catch (e) {}

        try {
            const s = JSON.parse(root.stateFile.text())
            const u = root.users.indexOf(s.user)
            if (u >= 0) root.userIndex = u
            const i = root.sessions.findIndex(x => x.name === s.session)
            if (i >= 0) root.sessionIndex = i
        } catch (e) {}
    }

    function cycleUser(delta) {
        if (active || users.length < 2) return
        userIndex = (userIndex + delta + users.length) % users.length
    }

    function cycleSession(delta) {
        if (active || sessions.length < 2) return
        sessionIndex = (sessionIndex + delta + sessions.length) % sessions.length
    }

    function save() {
        if (!stateFile.path) return
        stateFile.setText(JSON.stringify({ user: username, session: session.name }))
    }

    function tryUnlock(password) {
        if (active) return
        pendingPassword = password
        save()
        Greetd.createSession(username)
    }

    property Connections conn: Connections {
        target: Greetd

        function onAuthMessage(message, error, responseRequired, echoResponse) {
            root.responseRequired = responseRequired
            if (responseRequired) {
                Greetd.respond(root.pendingPassword)
                root.responseRequired = false
            }
        }

        function onAuthFailure(message) {
            root.pendingPassword = ""
            root.authFailed()
            Greetd.cancelSession()
        }

        function onReadyToLaunch() {
            Greetd.launch(root.session.command, [], true)
        }
    }

    property Process powerProc: Process {}

    function poweroff() {
        powerProc.command = ["/run/current-system/sw/bin/systemctl", "poweroff"]
        powerProc.running = true
    }

    function reboot() {
        powerProc.command = ["/run/current-system/sw/bin/systemctl", "reboot"]
        powerProc.running = true
    }
}
