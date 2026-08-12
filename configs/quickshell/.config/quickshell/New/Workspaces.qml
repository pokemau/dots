import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    Layout.fillHeight: true
    spacing: 0

    Repeater {
        model: 10

        Rectangle {
            id: wsBtn

            required property int index

            property var workspace: Hyprland.workspaces.values.find(w => w.id === (index + 1)) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool hasWindows: workspace !== null
            property bool isUrgent: workspace?.urgent ?? false
            property bool isHovered: false

            color: "transparent"
            radius: 4
            implicitWidth: 20
            Layout.fillHeight: true

            // for hover/active/urgent colors in each workspace
            Rectangle {
                anchors.centerIn: parent
                anchors {
                    topMargin: 2
                    bottomMargin: 2
                    // leftMargin: 2
                    // rightMargin: 2
                }
                anchors.fill: parent
                color: wsBtn.isUrgent ? Theme.red : (wsBtn.isActive ? Theme.bgAccent : Theme.bgHover)
                opacity: wsBtn.isActive || wsBtn.isUrgent ? 1.0 : (wsBtn.isHovered ? 0.5 : 0)
                radius: 3
            }

            Text {
                id: label
                anchors.centerIn: parent
                text: wsBtn.index + 1
                color: wsBtn.isUrgent ? Theme.fgWhite : (wsBtn.isActive ? Theme.fgWhite : (wsBtn.isHovered ? Theme.fg : (wsBtn.hasWindows ? Theme.fg : Theme.fgMuted)))
                font {
                    family: Theme.fontFamily
                    pixelSize: Theme.fontSize
                    bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + "})")
                onContainsMouseChanged: wsBtn.isHovered = containsMouse
                onWheel: event => {
                    if (event.angleDelta.y > 0)
                        Hyprland.dispatch(`hl.dsp.focus({ workspace = 'r-1' })`);
                    else if (event.angleDelta.y < 0)
                        Hyprland.dispatch(`hl.dsp.focus({ workspace = 'r+1' })`);
                }
            }
        }
    }
}
