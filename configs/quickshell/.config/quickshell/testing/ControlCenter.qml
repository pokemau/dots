import QtQuick
import Quickshell
import QtQuick.Shapes

Rectangle {
    id: root
    implicitWidth: 25
    implicitHeight: 25

    property bool isOpen: false

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
            root.isOpen = !root.isOpen;
        }
    }

    // TODO: change from text to icon
    Text {
        anchors.centerIn: parent
        text: "C"
    }

    PopupWindow {
        id: controlPanelPopup
        visible: controlCenter.opacity > 0
        implicitWidth: 400
        implicitHeight: 600
        color: "transparent"

        anchor {
            item: root
            edges: Edges.Top | Edges.Right
            gravity: Edges.Bottom | Edges.Left
            // rect.x: 50
            // rect.y: 50
            margins.top: Theme.barHeight + 5
            margins.right: 5
        }

        Rectangle {
            id: controlCenter
            // anchors.centerIn: parent
            anchors.fill: parent
            // implicitWidth: 80
            // implicitHeight: 80
            color: "red"
            radius: 10
            opacity: root.isOpen ? 1.0 : 0.0

            transform: Translate {
                x: root.isOpen ? 0 : 10
                y: root.isOpen ? 0 : -10

                Behavior on y {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on x {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
