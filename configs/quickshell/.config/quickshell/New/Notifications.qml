import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitWidth: 35
    implicitHeight: 25

    property bool popupOpen: false
    required property var pw

    Rectangle {
        id: triggerPill
        anchors.fill: parent
        color: '#ffefef'

        MouseArea {
            id: triggerMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.popupOpen = !root.popupOpen;
            }
        }
    }

    PopupWindow {
        visible: root.popupOpen || popupContainer.height > 0
        anchor.window: root.pw
        anchor.item: triggerPill

        anchor.rect.x: triggerPill.width - 500
        anchor.rect.y: triggerPill.height + 5

        implicitWidth: 500
        implicitHeight: item_t.height

        color: "transparent"

        Rectangle {
            id: popupContainer
            width: parent.width

            height: root.popupOpen ? item_t.height : 0

            clip: true
            color: "red"
            radius: 8

            Behavior on height {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }

            Item {
                id: item_t
                width: 500
                height: innerCol.height

                Column {
                    id: innerCol
                    spacing: 10
                    padding: 10

                    Row {
                        id: innerRow
                        spacing: 10

                        // wifi
                        Rectangle {
                            width: 50
                            height: 50
                            color: "blue"
                        }

                        Rectangle {
                            width: 50
                            height: 50
                            color: "blue"
                        }

                        Rectangle {
                            width: 50
                            height: 50
                            color: "blue"
                        }

                        Rectangle {
                            width: 50
                            height: 50
                            color: "blue"
                        }
                    }

                    Rectangle {
                        width: 50
                        height: 50
                        color: "orange"
                    }
                    Rectangle {
                        width: 50
                        height: 50
                        color: "orange"
                    }
                    Rectangle {
                        width: 50
                        height: 50
                        color: "orange"
                    }
                    Rectangle {
                        width: 50
                        height: 50
                        color: "orange"
                    }
                }
            }
        }
    }
}
