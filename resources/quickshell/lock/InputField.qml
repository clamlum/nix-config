import QtQuick
import "../"

Item {
    id: root
    property var lockContext
    property bool failed: false
    property bool cleared: false
    property string failText: "Authentication failed"
    property string fontFamily: Theme.font

    property real fieldWidth: 280
    property real fieldHeight: 48
    width: fieldWidth
    height: fieldHeight

    property color innerColor: "#cc1f2134"
    property color outerColor: "#ee6c8aff"
    property color checkColor: "#ee595959"
    property color failColor: "#eeff0000"
    property color clearColor: "#ffffffff"
    property color fontColor: "#c8c8c8"
    property real dotsSpacing: 0.3

    readonly property int dotDiameter: Math.max(1, Math.round(box.height * 0.25))
    readonly property int dotSpacingPx: Math.max(0, Math.round(box.height * dotsSpacing))
    readonly property int dotStep: dotDiameter + dotSpacingPx
    property real dotsMargin: 8

    property color currentBorderColor:
        root.failed ? root.failColor
        : root.cleared ? root.clearColor
        : (root.lockContext.active ? root.checkColor : root.outerColor)

    Behavior on currentBorderColor {
        ColorAnimation { duration: 150 }
    }

    Connections {
        target: root.lockContext
        function onAuthFailed() {
            root.failed = true
            hidden.text = ""
            failResetTimer.start()
        }
    }

    Timer {
        id: failResetTimer
        interval: 1500
        onTriggered: root.failed = false
    }

    Timer {
        id: clearResetTimer
        interval: 400
        onTriggered: root.cleared = false
    }

    function flashClear() {
        root.cleared = true
        clearResetTimer.restart()
    }


    Rectangle {
        id: box
        anchors.fill: parent
        radius: 0
        color: root.innerColor
        border.width: 1
        border.color: root.currentBorderColor
        clip: true

        Row {
            id: dotsRow
            anchors.verticalCenter: parent.verticalCenter
            property real targetX: implicitWidth < root.fieldWidth
                ? (root.fieldWidth - implicitWidth) / 2
                : root.fieldWidth - implicitWidth - root.dotsMargin
            property real animatedX: targetX
            x: Math.round(animatedX)
            spacing: root.dotSpacingPx
            visible: hidden.text.length > 0 && !root.failed

            onTargetXChanged: animatedX = targetX
            Component.onCompleted: animatedX = targetX

            Behavior on animatedX {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }

            Repeater {
                model: hidden.text.length

                Rectangle {
                    id: dot
                    width: root.dotDiameter
                    height: width
                    radius: width / 2
                    antialiasing: true

                    property bool shown: false
                    color: shown
                        ? root.fontColor
                        : Qt.rgba(root.fontColor.r, root.fontColor.g, root.fontColor.b, 0)

                    Component.onCompleted: shown = true
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: root.failed ? root.failText : "Enter Password"
            color: root.fontColor
            font.pixelSize: box.height * 0.35
            font.family: root.fontFamily
            visible: hidden.text.length === 0 || root.failed
            opacity: (hidden.text.length === 0 && !hidden.activeFocus) ? 0.6 : 1.0
        }

        TextInput {
            id: hidden
            anchors.fill: parent
            color: "transparent"
            selectionColor: "transparent"
            selectedTextColor: "transparent"
            cursorDelegate: Item {}
            echoMode: TextInput.Password
            focus: true

            enabled: !root.lockContext.active || root.lockContext.responseRequired

            Keys.onPressed: (event) => {
                if (event.matches(StandardKey.SelectAll)) {
                    hidden.text = ""
                    root.flashClear()
                    event.accepted = true
                } else if (event.key === Qt.Key_Backspace && hidden.text.length === 0) {
                    root.flashClear()
                    event.accepted = true
                }
            }

            Keys.onEscapePressed: {
                hidden.text = ""
                root.flashClear()
                event.accepted = true
            }

            onTextChanged: {
                if (root.failed && text.length > 0) {
                    failResetTimer.stop()
                    root.failed = false
                }
            }

            onAccepted: {
                root.failed = false
                root.lockContext.tryUnlock(text)
            }

            onEnabledChanged: if (enabled) forceActiveFocus()
            onActiveFocusChanged: if (!activeFocus && enabled) forceActiveFocus()
            Component.onCompleted: forceActiveFocus()
        }
    }
}
