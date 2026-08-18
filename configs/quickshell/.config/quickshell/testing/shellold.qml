import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Shapes

ShellRoot {
    PanelWindow {
        id: panel

        color: "transparent"
        exclusiveZone: Theme.barHeight
        implicitHeight: (notch.isHovered || notch.height > notch.collapsedHeight + 1) ? testContent.implicitHeight + 2 : notch.collapsedHeight + 2

        anchors {
            top: true
            left: true
            right: true
        }

        Notch {
            id: notch

            content: testContent

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            Test {
                id: testContent

                anchors.centerIn: parent
                opacity: notch.isHovered ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    SequentialAnimation {
                        // PauseAnimation {
                        //     duration: root.isHovered ? 150 : 0
                        // }

                        NumberAnimation {
                            duration: 150
                        }
                    }
                }
            }
        }
    }
}
