import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: bar

    implicitHeight: 25
    color: Theme.barBg

    anchors {
        left: true
        top: true
        right: true
    }

    // bar bottom border
    Rectangle {
        implicitHeight: 1
        color: Theme.barBorder

        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        WorkspaceBar {
            Layout.fillHeight: true
        }
        // Workspaces {}

        Separator {}

        // window title
        Text {
            text: SystemMonitor.activeWindow
            color: Theme.colFg
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily
            font.bold: true
            Layout.fillWidth: true
            Layout.leftMargin: 8
            elide: Text.ElideRight
            maximumLineCount: 1
        }

        BarSystemTray {}

        Separator {}

        // cpu
        Text {
            text: "CPU: " + SystemMonitor.cpuUsage + "%"
            color: Theme.colMuted
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily
            font.bold: true
            Layout.rightMargin: 8
        }

        Separator {
            Layout.leftMargin: 0
        }

        // mem usage
        Text {
            text: "Mem: " + SystemMonitor.memUsage + "%"
            color: Theme.colMuted
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily
            font.bold: true
            Layout.rightMargin: 8
        }

        Separator {
            Layout.leftMargin: 0
        }

        Clock {
            Layout.rightMargin: 5
        }

        Separator {
            Layout.rightMargin: 10
            visible: batteryWidget.hasBattery
        }

        Battery {
            id: batteryWidget

            panelWindow: bar
            visible: batteryWidget.hasBattery
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: 25
            Layout.rightMargin: 0
        }

        // Separator {
        //     Layout.leftMargin: 5
        //     Layout.rightMargin: 0
        // }
    }
}
