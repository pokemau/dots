import QtQuick
import QtQuick.Layouts
import Quickshell

ShellRoot {
    PanelWindow {
        implicitHeight: 25
        color: Theme.barBg

        anchors {
            top: true
            left: true
            right: true
        }

        RowLayout {
            anchors.fill: parent
            // anchors.leftMargin: 14
            anchors.rightMargin: 14
            spacing: 8

            Workspaces {
            }

            Separator {
            }

            Item {
                Layout.fillWidth: true
            }

            Cpu {
            }

            Separator {
            }

            Clock {
            }

        }

    }

}
