import Quickshell.Services.SystemTray
import QtQuick
import Quickshell
import QtQuick.Layouts

Repeater {
    model: SystemTray.items

    Image {
        id: trayIcon
        required property SystemTrayItem modelData

        // // debug print system tray item
        // Component.onCompleted: console.log("TRAY:", JSON.stringify({
        //     id: modelData.id,
        //     title: modelData.title,
        //     tooltip: modelData.tooltipTitle,
        //     category: modelData.category,
        //     status: modelData.status,
        //     icon: modelData.icon
        // }))

        source: modelData.icon
        sourceSize.width: 16
        sourceSize.height: 16
        Layout.preferredWidth: 16
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 2
        Layout.rightMargin: 2

        // hide discord
        visible: !(["discord", "com.discordapp.Discord"].some(title => modelData.tooltipTitle.toLowerCase() === title.toLowerCase()))

        QsMenuAnchor {
            id: menuAnchor
            menu: modelData.menu
            anchor.item: trayIcon
        }

        TapHandler {
            onTapped: modelData.activate()
        }

        TapHandler {
            acceptedButtons: Qt.RightButton
            onTapped: {
                if (modelData.hasMenu) {
                    menuAnchor.open();
                } else {
                    modelData.display(toplevel, trayIcon.x, trayIcon.y);
                }
            }
        }
    }
}
