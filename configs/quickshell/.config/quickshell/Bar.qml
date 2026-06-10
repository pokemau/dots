import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: toplevel
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: 0
                bottom: 0
                left: 0
                right: 0
            }

            implicitHeight: 25
            color: "transparent"


            Rectangle {
                anchors.fill: parent
                color: Theme.barBg

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: Theme.barBorder
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    WorkspaceBar {
                        Layout.fillHeight: true
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 16
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: 8
                        Layout.rightMargin: 8
                        color: Theme.colMuted
                    }

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

                    Repeater {
                        model: SystemTray.items

                        Image {
                            required property SystemTrayItem modelData

                            source: modelData.icon
                            sourceSize.width: 16
                            sourceSize.height: 16
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 2
                            Layout.rightMargin: 2

                            TapHandler {
                                onTapped: modelData.activate()
                            }

                            TapHandler {
                                acceptedButtons: Qt.RightButton
                                onTapped: modelData.display(toplevel, parent.x, parent.y)
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 16
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: 8
                        Layout.rightMargin: 8
                        color: Theme.colMuted
                    }

                    Text {
                        text: "CPU: " + SystemMonitor.cpuUsage + "%"
                        color: Theme.colMuted
                        font.pixelSize: Theme.fontSize
                        font.family: Theme.fontFamily
                        font.bold: true
                        Layout.rightMargin: 8
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 16
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: 8
                        color: Theme.colMuted
                    }

                    Text {
                        text: "Mem: " + SystemMonitor.memUsage + "%"
                        color: Theme.colMuted
                        font.pixelSize: Theme.fontSize
                        font.family: Theme.fontFamily
                        font.bold: true
                        Layout.rightMargin: 8
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 16
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: 8
                        color: Theme.colMuted
                    }

                    ClockWidget {
                        Layout.rightMargin: 8
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 16
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: 0
                        color: Theme.colMuted
                        visible: batteryWidget.hasBattery
                    }

                    BatteryWidget {
                        id: batteryWidget
                        panelWindow: toplevel
                        visible: hasBattery
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredHeight: 25
                        Layout.rightMargin: 0
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 16
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: 0
                        color: Theme.colMuted
                    }

                    ControlManagerWidget {
                        panelWindow: toplevel
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredHeight: 25
                        Layout.rightMargin: 0
                    }
                }
            }
        }
    }
}
