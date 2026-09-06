pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

RowLayout {
    id: systemTray
    property bool isBottom: false

    spacing: 5

    Repeater {
        model: ScriptModel {
            values: [...SystemTray.items.values].filter(item => item.id !== "spotify-client")
        }

        MouseArea {
            id: delegate

            required property SystemTrayItem modelData
            property alias item: delegate.modelData

            Layout.fillHeight: true
            implicitWidth: icon.implicitWidth + 5

            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: event => {
                if (event.button === Qt.LeftButton) {
                    item.activate();
                } else if (event.button === Qt.MiddleButton) {
                    item.secondaryActivate();
                } else if (event.button === Qt.RightButton) {
                    menuAnchor.open();
                }
            }

            onWheel: event => {
                event.accepted = true;
                const points = event.angleDelta.y / 120;
                item.scroll(points, false);
            }

            IconImage {
                id: icon
                anchors.centerIn: parent
                source: delegate.item.icon
                implicitSize: 16
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: delegate.item.menu

                anchor.window: delegate.QsWindow.window

                anchor.onAnchoring: {
                    const window = delegate.QsWindow.window;
                    const widgetRect = window.contentItem.mapFromItem(delegate, 0, delegate.height, delegate.width, delegate.height);

                    if (systemTray.isBottom === true) {
                        menuAnchor.anchor.rect = Qt.rect(widgetRect.x, -delegate.height, delegate.width, widgetRect.height);
                    } else {
                        menuAnchor.anchor.rect = Qt.rect(widgetRect.x, delegate.height, delegate.width, widgetRect.height);
                    }
                }
            }
        }
    }
}
