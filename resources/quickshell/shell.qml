//@ pragma UseQApplication
import Quickshell
import "bar"
import "lock"

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Bar {
            required property var modelData
            screen: modelData
            autohide: modelData.name === "DP-1"
        }
    }
    Lock {}
}
