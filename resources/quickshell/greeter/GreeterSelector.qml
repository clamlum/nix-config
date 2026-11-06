import QtQuick
import "../"

Row {
    id: root
    property var ctx
    spacing: 8
    opacity: ctx.active ? 0.4 : 1.0

    Behavior on opacity { NumberAnimation { duration: 150 } }

    component Pick: Text {
        id: pick
        property alias hovered: mouse.containsMouse
        signal clicked()
        color: hovered ? Theme.textSecondary : Theme.text
        font { family: Theme.font; pixelSize: 20; bold: true }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: pick.clicked()
        }
    }

    Pick {
        text: root.ctx.session.name
        onClicked: root.ctx.cycleSession(1)
    }

    Text {
        text: "-"
        color: Theme.text
        font { family: Theme.font; pixelSize: 20; bold: true }
    }

    Pick {
        text: root.ctx.username
        onClicked: root.ctx.cycleUser(1)
    }

    Shortcut { sequence: "F1"; onActivated: root.ctx.poweroff() }
    Shortcut { sequence: "F2"; onActivated: root.ctx.reboot() }

    Shortcut { sequence: "F3"; onActivated: root.ctx.cycleSession(1) }
    Shortcut { sequence: "Shift+F3"; onActivated: root.ctx.cycleSession(-1) }
    Shortcut { sequence: "F4"; onActivated: root.ctx.cycleUser(1) }
    Shortcut { sequence: "Shift+F4"; onActivated: root.ctx.cycleUser(-1) }
}
