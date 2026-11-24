import QtQuick
import "../../"
import "../../services" as Services

Item {
    id: root
    implicitHeight: Theme.barHeight

    readonly property string title: (Services.Mpris.title || "").toString()
    readonly property string artist: (Services.Mpris.artist || "").toString()
    readonly property string trackText: title && artist ? (title + " - " + artist) : (title || artist || "")

    readonly property bool hasIcon: Services.Mpris.icon !== ""
    readonly property bool hasText: trackText !== ""
    readonly property real minTextWidth: 20

    readonly property real iconWidth: hasIcon ? Math.ceil(iconText.implicitWidth) : 0
    readonly property real fullTextWidth: hasText ? Math.ceil(trackLabel.implicitWidth) : 0
    readonly property real spacingWidth: (hasIcon && hasText) ? row.spacing : 0
    readonly property real availableTextWidth: Math.max(0, Math.floor(width) - iconWidth - spacingWidth)

    implicitWidth: iconWidth + spacingWidth + fullTextWidth

    Row {
        id: row
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: iconText
            visible: root.hasIcon && Math.floor(root.width) >= root.iconWidth
            text: Services.Mpris.icon
            color: Theme.text
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -2
        }
        Text {
            id: trackLabel
            visible: root.hasText && root.availableTextWidth >= Math.min(root.fullTextWidth, root.minTextWidth)
            width: Math.min(root.fullTextWidth, root.availableTextWidth)
            text: root.trackText
            elide: Text.ElideRight
            color: Theme.text
            font { pixelSize: 14; family: Theme.font; bold: true }
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.horizontalCenter: row.horizontalCenter
        width: row.width
        y: -7
        height: parent.height + 16
        enabled: row.width > 0
        hoverEnabled: enabled
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onClicked: event => {
            if (event.button === Qt.LeftButton) Services.Mpris.playPause();
            else if (event.button === Qt.MiddleButton) Services.Mpris.previous();
            else if (event.button === Qt.RightButton) Services.Mpris.next();
        }
        onWheel: Services.Mpris.wheelVolume(wheel.angleDelta.y > 0)
    }
}
