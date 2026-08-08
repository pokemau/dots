import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: topLevel
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

        Workspaces {}

        Separator {}

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

        Clock {}

        Separator {
            Layout.rightMargin: 0
        }

        Batt {
            id: batteryWidget
            panelWindow: topLevel
            visible: batteryWidget.hasBattery
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: 25
            Layout.rightMargin: 0
        }

        Separator {
            Layout.leftMargin: 0
            Layout.rightMargin: 0
        }

        Notifications {
            pw: topLevel
        }
        // ControlCenter {}
    }
}
