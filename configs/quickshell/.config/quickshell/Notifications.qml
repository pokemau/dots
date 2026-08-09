pragma ComponentBehavior: Bound
// Item {
//     id: root
//     property bool popupOpen: false
//     required property var pw
//     implicitWidth: 35
//     implicitHeight: 25
//     Rectangle {
//         id: triggerPill
//         anchors.fill: parent
//         color: '#ffefef'
//         MouseArea {
//             id: triggerMouse
//             anchors.fill: parent
//             cursorShape: Qt.PointingHandCursor
//             onClicked: {
//                 root.popupOpen = !root.popupOpen;
//             }
//         }
//     }
//     PopupWindow {
//         visible: root.popupOpen || popupContainer.height > 0
//         anchor.window: root.pw
//         anchor.item: triggerPill
//         anchor.rect.x: triggerPill.width - 500
//         anchor.rect.y: triggerPill.height + 5
//         implicitWidth: 500
//         implicitHeight: item_t.height
//         color: "transparent"
//         Rectangle {
//             id: popupContainer
//             width: parent.width
//             height: root.popupOpen ? item_t.height : 0
//             clip: true
//             color: "red"
//             radius: 8
//             Item {
//                 id: item_t
//                 width: 500
//                 height: innerCol.height
//                 Column {
//                     id: innerCol
//                     spacing: 10
//                     padding: 10
//                     Row {
//                         id: innerRow
//                         spacing: 10
//                         // wifi
//                         Rectangle {
//                             width: 50
//                             height: 50
//                             color: "blue"
//                         }
//                         Rectangle {
//                             width: 50
//                             height: 50
//                             color: "blue"
//                         }
//                         Rectangle {
//                             width: 50
//                             height: 50
//                             color: "blue"
//                         }
//                         Rectangle {
//                             width: 50
//                             height: 50
//                             color: "blue"
//                         }
//                     }
//                     Rectangle {
//                         width: 50
//                         height: 50
//                         color: "orange"
//                     }
//                     Rectangle {
//                         width: 50
//                         height: 50
//                         color: "orange"
//                     }
//                     Rectangle {
//                         width: 50
//                         height: 50
//                         color: "orange"
//                     }
//                     Rectangle {
//                         width: 50
//                         height: 50
//                         color: "orange"
//                     }
//                 }
//             }
//             Behavior on height {
//                 NumberAnimation {
//                     duration: 150
//                     easing.type: Easing.InOutQuad
//                 }
//             }
//         }
//     }
// }

import QtQml.Models
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Wayland

Scope {
    id: root

    property bool centerOpen: false
    property var history: ListModel {
        id: history
    }

    NotificationServer {
        id: notifServer

        actionsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: n => {
            history.insert(0, {
                summary: n.summary || "",
                body: n.body || "",
                appName: n.appName || "",
                urgency: n.urgency || 0,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            });
            return n.tracked = true;
        }
    }

    PanelWindow {
        visible: root.centerOpen && column.implicitHeight > 1
        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            right: true
        }

        margins {
            top: 12
            right: 12
        }

        ColumnLayout {
            id: column

            width: parent.width
            spacing: 10

            Repeater {
                model: notifServer.trackedNotifications
                delegate: Rectangle {
                    id: delegateRoot
                    width: column.width
                    implicitHeight: delegateContent.implicitHeight + 20
                    radius: 8
                    color: "#2b2b2b"
                    border.width: 1
                    border.color: "#444444"

                    required property var appName
                    required property var time
                    required property var summary
                    required property var body
                    required property int index

                    RowLayout {
                        id: delegateContent

                        // FIX 1: Prevent binding loop by anchoring to sides/center instead of fill: parent
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 10
                        spacing: 10

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            // App Name & Timestamp Header
                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    Layout.fillWidth: true
                                    text: delegateRoot.appName !== "" ? delegateRoot.appName : "Unknown"
                                    color: "orange"
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: delegateRoot.time
                                    color: "gray"
                                    font.pixelSize: 12
                                }
                            }

                            // Summary (Title)
                            Text {
                                Layout.fillWidth: true
                                text: delegateRoot.summary
                                // FIX 2: Change from black to white
                                color: "white"
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            // Body (Content)
                            Text {
                                Layout.fillWidth: true
                                text: delegateRoot.body
                                visible: text !== ""
                                // FIX 3: Change from black to light gray
                                color: "#cccccc"
                                wrapMode: Text.WordWrap
                                maximumLineCount: 3
                                elide: Text.ElideRight
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: history.remove(delegateRoot.index)
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "notifications"
        function toggle(): void {
            root.centerOpen = !root.centerOpen;
        }
        function show(): void {
            root.centerOpen = true;
        }
        function hide(): void {
            root.centerOpen = false;
        }
    }
}
