import QtQuick
import "../../"
import "../../services" as Services

Item {
    id: root
    implicitHeight: Theme.barHeight

    property int maxTitleLength: 60
    property int maxArtistLength: 60

    function _clip(s, max) {
        const str = (s || "").toString();
        return max > 0 && str.length > max ? str.slice(0, max - 1) + "…" : str;
    }

    readonly property string title: _clip(Services.Mpris.title, maxTitleLength)
    readonly property string artist: _clip(Services.Mpris.artist, maxArtistLength)

    readonly property string trackText: title && artist ? (title + " - " + artist) : (title || artist || "")

    Row {
        id: row
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            visible: Services.Mpris.icon !== ""
            text: Services.Mpris.icon
            color: Theme.text
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -2
        }
        Text {
            text: trackText
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
        hoverEnabled: true
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
