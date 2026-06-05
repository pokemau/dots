import Quickshell
import QtQuick

Loader {
    readonly property string compositor: {
        if (Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")) return "hyprland";
        if (Quickshell.env("NIRI_SOCKET")) return "niri";
        return "";
    }

    sourceComponent: compositor === "niri" ? niriCmp : (compositor === "hyprland" ? hyprCmp : null)

    Component { id: hyprCmp; HyprWorkspaceBar {} }
    Component { id: niriCmp; NiriWorkspaceBar {} }
}
