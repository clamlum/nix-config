import QtQuick
import "../../"
import "../../services" as Services

Item {
    id: root

    implicitWidth: row.width
    implicitHeight: Theme.barHeight

    property int maxTitleChars: 40

    property var currentWindow: Services.Compositor.focusedWindow
    property string windowClass: currentWindow?.app_id || ""
    property string windowTitle: currentWindow?.title || ""

    property var classOverrides: ({
            "code": {
                name: "Visual Studio Code",
                icon: ""
            },
            "helium": {
                name: "Helium",
                icon: ""
            },
            "spotify": {
                name: "Spotify",
                icon: ""
            },
            "vesktop": {
                name: "Vesktop",
                icon: ""
            },
            "discord": {
                name: "Discord",
                icon: ""
            },
            "com.mitchellh.ghostty": {
                name: "Ghostty",
                icon: ""
            },
            "org.wezfurlong.wezterm": {
                name: "WezTerm",
                icon: ""
            },
            "org.gnome.nautilus": {
                name: "Nautilus",
                icon: ""
            },
            "kopuz": {
                name: "Kopuz",
                icon: ""
            },
            "dev.zed.Zed": {
                name: "Zed",
                icon: ""
            },
            "steam": {
                name: "Steam",
                icon: ""
            },
            "org.prismlauncher.PrismLauncher": {
                name: "Prism Launcher",
                icon: "󰍳"
            }
        })

    function _override() {
        const key = windowClass.toLowerCase();
        return classOverrides[key] || classOverrides[windowClass] || null;
    }

    function _clip(s) {
        const str = (s || "").toString();
        return maxTitleChars > 0 && str.length > maxTitleChars ? str.slice(0, maxTitleChars - 1) + "…" : str;
    }

    property var activeOverride: _override()
    property string displayIcon: activeOverride ? activeOverride.icon : ""
    property string displayName: activeOverride ? activeOverride.name : windowClass

    Row {
        id: row
        spacing: 6

        Text {
            visible: root.displayIcon !== ""
            text: root.displayIcon
            color: Theme.text
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenterOffset: -4
        }

        Text {
            text: root.displayName
            color: Theme.text
            font.pixelSize: Theme.fontSize
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenterOffset: -2.5
        }
    }
}
