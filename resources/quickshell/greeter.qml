import Quickshell
import "lock"
import "greeter"

ShellRoot {
    FloatingWindow {
        visible: true
        color: "black"

        LockContent {
            anchors.fill: parent
            lockContext: GreeterContext
        }

        GreeterSelector {
            ctx: GreeterContext
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24
        }
    }
}
