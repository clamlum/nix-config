pragma ComponentBehavior: Bound
import QtQuick
import "../../"
import "../../services" as Services

Item {
    id: root
    height: 32
    width: row.width

    implicitWidth: row.width
    implicitHeight: 32

    property string outputName: ""
    property var workspaceData: Services.Compositor.workspaces

    Row {
        id: row
        height: parent.height
        spacing: 0

        Repeater {
            model: root.workspaceData.filter(w => w.output === root.outputName).filter(w => w.is_focused || w.active_window_id !== null).sort((a, b) => a.idx - b.idx)

            Item {
                id: item

                required property var modelData
                width: 20
                height: row.height

                Rectangle {
                    id: visual
                    width: parent.width
                    height: 24
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: item.modelData.idx
                    color: (item.modelData.is_focused && item.modelData.active_window_id === null) ? Theme.inactive : Theme.secondary
                    font.pixelSize: 16
                    font.bold: true
                    anchors.horizontalCenter: visual.horizontalCenter
                    anchors.verticalCenter: visual.verticalCenter
                    anchors.verticalCenterOffset: -2 - (3 * 0.5)  // textYOffset - underlineHeight * 0.5
                }

                Rectangle {
                    width: visual.width
                    height: 3
                    color: item.modelData.is_focused ? Theme.primary : "transparent"
                    anchors.horizontalCenter: visual.horizontalCenter
                    anchors.bottom: visual.bottom
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Services.Compositor.focusWorkspace(item.modelData.idx)
                }
            }
        }
    }
}
