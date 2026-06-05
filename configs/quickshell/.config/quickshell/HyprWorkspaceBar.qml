import Quickshell.Hyprland
import QtQuick

Row {
    spacing: 0

    Repeater {
        model: 10

        Rectangle {
            width: 20
            height: parent.height
            color: "transparent"

            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool isUrgent: workspace?.urgent ?? false
            property bool hasWindows: workspace !== null
            property bool isHovered: false

            Rectangle {
                anchors.fill: parent
                color: isUrgent ? "#e06c75" : (isActive ? Theme.colBgAccent : Theme.colBgHover)
                opacity: isActive || isUrgent ? 0.9 : (isHovered ? 0.5 : 0)
                radius: 0
            }

            Text {
                text: index + 1
                color: isUrgent ? "#ffffff" : ((isActive || isHovered) ? Theme.colBg : (hasWindows ? Theme.colFg : Theme.colMuted))
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                font.bold: true
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
                onContainsMouseChanged: parent.isHovered = containsMouse
                onWheel: event => {
                    if (event.angleDelta.y < 0)
                        Hyprland.dispatch("workspace e+1")
                    else if (event.angleDelta.y > 0)
                        Hyprland.dispatch("workspace e-1")
                }
            }
        }
    }
}
