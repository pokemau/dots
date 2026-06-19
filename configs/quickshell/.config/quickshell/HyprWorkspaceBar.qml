import Quickshell.Hyprland
import QtQuick

Row {
    spacing: 0

    Repeater {
        model: 10

        Rectangle {
            id: ws
            width: 20
            height: parent.height
            color: "transparent"

            property var workspace: Hyprland.workspaces.values.find(w => w.id === index + 1) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool isUrgent: workspace?.urgent ?? false
            property bool hasWindows: workspace !== null
            property bool isHovered: false

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 4
                anchors.bottomMargin: 4
                anchors.leftMargin: 2
                anchors.rightMargin: 2
                color: ws.isUrgent ? Theme.colRed : (ws.isActive ? Theme.colBgAccent : Theme.colBgHover)
                opacity: ws.isActive || ws.isUrgent ? 1.0 : (ws.isHovered ? 0.5 : 0)
                radius: 3
            }

            Text {
                text: ws.workspace && ws.workspace.name && ws.workspace.name.length > 0 ? ws.workspace.name : (index + 1)
                color: ws.isUrgent ? "#ffffff" : (ws.isActive ? "#ffffff" : (ws.isHovered ? Theme.colFg : (ws.hasWindows ? Theme.colFg : Theme.colMuted)))
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                font.bold: true
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${index + 1} })`)

                onContainsMouseChanged: ws.isHovered = containsMouse
                onWheel: event => {
                    if (event.angleDelta.y < 0)
                        Hyprland.dispatch(`hl.dsp.focus({ workspace = 'e+1' })`);
                    else if (event.angleDelta.y > 0)
                        Hyprland.dispatch(`hl.dsp.focus({ workspace = 'e-1' })`);
                }
            }
        }
    }
}
