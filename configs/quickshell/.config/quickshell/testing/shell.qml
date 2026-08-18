//@ pragma Env QS_NO_RELOAD_POPUP=1
import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Shapes

// TODO:
// - OSD
// - Notifications, Notif Center

ShellRoot {
    PanelWindow {
        id: panel

        color: Theme.barBg
        implicitHeight: Theme.barHeight

        anchors {
            top: true
            left: true
            right: true
        }

        Workspaces {}

        Row {
            spacing: 5
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }

            ControlCenter {}
        }

        // LEFT
        // - workspaces
        // - window title
        //
        //
        // MIDDLE
        // - apps in current workspace
        //
        //
        // RIGHT
        // - system tray
        // - cpu usage
        // - mem usage
        // - time/date
        // - battery percentage
        // - control center
    }
}
