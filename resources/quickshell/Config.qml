pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string barPosition: "bottom"

    property string wallpaperPath: Quickshell.env("WALLPAPER_PATH") ?? ""

    property list<string> autohideOutputs: ["DP-1", "eDP-1"]

    function toggle() {
        root.barPosition = root.barPosition === "top" ? "bottom" : "top"
    }

    IpcHandler {
        target: "bar"
        function toggle(): void { root.toggle() }
        function get(): string { return root.barPosition }
    }
}
