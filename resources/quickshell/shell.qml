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
            fullAutohide: Config.autohideOutputs.includes(modelData.name)
            smartAutohide: Config.smartAutohideOutputs.includes(modelData.name)
        }
    }
    Lock {}
}
