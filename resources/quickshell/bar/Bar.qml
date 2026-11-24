import Quickshell
import QtQuick
import QtQuick.Layouts
import "modules"
import "../"
import "../services" as Services

PanelWindow {
    id: root

    property bool bottom: Config.barPosition === "bottom"

    property bool fullAutohide: false
    property bool smartAutohide: false

    readonly property var activeWorkspace:
        Services.Compositor.workspaces.find(w => w.output === root.screen.name && w.is_active) ?? null

    readonly property bool hasWindow: activeWorkspace
        ? Services.Compositor.windows.some(w => w.workspace_id === activeWorkspace.id)
        : false

    property bool autohide: fullAutohide || (smartAutohide && hasWindow)
    property bool revealed: !autohide

    onAutohideChanged: {
        showTimer.stop()
        hideTimer.stop()
        revealed = !autohide
    }

    property bool pointerActive: edgeHover.hovered || contentHover.hovered

    onPointerActiveChanged: {
        if (pointerActive) {
            hideTimer.stop()
            if (autohide && !revealed) {
                showTimer.restart()
            }
        } else {
            showTimer.stop()
            if (autohide) {
                hideTimer.restart()
            }
        }
    }

    anchors.top: !bottom
    anchors.bottom: bottom
    anchors.left: true
    anchors.right: true

    implicitHeight: Theme.barHeight
    color: "transparent"

    exclusiveZone: autohide ? (revealed ? Theme.barHeight : 0) : Theme.barHeight
    mask: (autohide && !revealed) ? hoverMaskRegion : null

    Region {
        id: hoverMaskRegion
        item: hoverZone
    }

    Item {
        id: hoverZone
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        y: root.bottom ? parent.height - height : 0
        visible: root.autohide

        HoverHandler {
            id: edgeHover
            enabled: root.autohide
        }
    }

    Rectangle {
        id: barBackground
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        color: Theme.background

        y: root.revealed ? 0 : (root.bottom ? height : -height)
        Behavior on y {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }
    }

    Item {
        id: barSlider
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height

        y: root.revealed ? 0 : (root.bottom ? height : -height)
        Behavior on y {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }

        HoverHandler {
            id: contentHover
            enabled: root.autohide
        }

        Item {
            id: barContent
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.topMargin: 8
            anchors.bottomMargin: 8

            y: root.revealed ? 0 : (root.bottom ? height : -height)

            Behavior on y {
                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
            }

            // LEFT SECTION
            RowLayout {
                id: leftSection
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                spacing: 8

                Workspaces {
                    Layout.alignment: Qt.AlignVCenter
                    outputName: root.screen.name
                }

                Windows {
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            // CENTER SECTION
            Item {
                id: centerSection

                readonly property real sidePadding: 16
                readonly property real leftBound: leftSection.x + leftSection.width + sidePadding
                readonly property real rightBound: rightSection.x - sidePadding
                readonly property real availableWidth: Math.max(0, Math.floor(rightBound - leftBound))
                readonly property real desiredWidth: Math.min(mprisModule.implicitWidth, availableWidth)

                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1

                x: Math.max(leftBound, Math.min((barContent.width - desiredWidth) / 2, rightBound - desiredWidth))
                width: desiredWidth
                height: parent.height

                BarMedia {
                    id: mprisModule
                    anchors.fill: parent
                }
            }

            // RIGHT SECTION
            RowLayout {
                id: rightSection

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                SystemTray {
                    isBottom: root.bottom
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 20
                    color: Theme.muted
                }

                Item {}
                Volume {
                    id: volumeModule
                    Layout.preferredWidth: implicitWidth
                    Layout.alignment: Qt.AlignVCenter
                }
                Item {}

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 20
                    color: Theme.muted
                }

                Microphone {
                    id: microphoneModule
                    Layout.preferredWidth: implicitWidth
                    Layout.alignment: Qt.AlignVCenter
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 20
                    color: Theme.muted
                }

                Bluetooth {
                    id: bluetoothModule
                    Layout.preferredWidth: implicitWidth
                    Layout.alignment: Qt.AlignVCenter
                }

                Network {
                    id: network
                    Layout.preferredWidth: implicitWidth
                    Layout.alignment: Qt.AlignVCenter
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 20
                    color: Theme.muted
                }

                BarBattery {
                    id: batteryModule
                    Layout.preferredWidth: implicitWidth
                    Layout.alignment: Qt.AlignVCenter
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 20
                    color: Theme.muted
                    visible: batteryModule.available
                }

                TimeDisplay {
                    id: timeDisplay
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignVCenter
                }

                Item {}
            }
        }
    }

    Timer {
        id: showTimer
        interval: 350
        onTriggered: if (root.autohide && root.pointerActive) root.revealed = true
    }

    Timer {
        id: hideTimer
        interval: 350
        onTriggered: if (root.autohide && !root.pointerActive) root.revealed = false
    }
}
