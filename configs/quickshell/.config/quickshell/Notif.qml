import QtQuick
import Quickshell
import Quickshell.Services.Notifications

PanelWindow {
    id: notificationWindow

    // Position the window at the top right of the screen
    anchors {
        top: true
        right: true
    }

    // Add some padding from the screen edges
    margins {
        top: 16
        right: 16
    }

    color: "transparent"
    width: 350
    // Dynamically adjust height to content, capped at a reasonable maximum to avoid overflowing the screen
    height: Math.min(notificationList.contentHeight, 1000)

    ListView {
        id: notificationList
        anchors.fill: parent
        spacing: 12
        clip: true

        // Bind to Quickshell's internal DBus notification model
        model: NotificationServer.notifications

        // Enable smooth transitions when notifications are added or removed
        add: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }
        remove: Transition {
            NumberAnimation {
                property: "opacity"
                to: 0
                duration: 200
            }
        }

        delegate: Rectangle {
            id: notifCard
            width: ListView.view.width
            implicitHeight: contentColumn.implicitHeight + 24

            // Dark theme styling - adjust colors as needed
            color: "#1e1e2e"
            radius: 8

            // Access the underlying Notification object.
            // In Quickshell models, this is typically exposed as 'model.notification' or 'modelData'
            property var notif: model.notification || modelData

            // In the DBus specification, urgency 2 translates to Critical.
            property bool isCritical: notif.urgency === 2

            border.color: isCritical ? "#f38ba8" : "#313244"
            border.width: isCritical ? 2 : 1

            Column {
                id: contentColumn
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 12
                }
                spacing: 6

                Text {
                    text: notifCard.notif.summary
                    color: "#cdd6f4"
                    font.bold: true
                    font.pixelSize: 14
                    width: parent.width
                    wrapMode: Text.Wrap
                }

                Text {
                    text: notifCard.notif.body
                    color: "#bac2de"
                    font.pixelSize: 13
                    width: parent.width
                    wrapMode: Text.Wrap
                    visible: text !== ""
                }
            }

            // Click to dismiss behavior
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    notifCard.notif.close();
                }
            }

            // Auto-dismissal logic
            Timer {
                id: dismissTimer
                interval: 3000
                // Timer only runs if the notification is NOT critical
                running: !notifCard.isCritical

                onTriggered: {
                    notifCard.notif.close();
                }

                Component.onCompleted: {
                    if (running) {
                        start();
                    }
                }
            }
        }
    }
}
