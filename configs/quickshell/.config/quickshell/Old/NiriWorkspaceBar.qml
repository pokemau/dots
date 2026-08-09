import QtQuick

Row {
    spacing: 0

    Repeater {
        model: NiriService.workspaces

        Rectangle {
            id: ws
            required property var modelData
            width: 20
            height: parent.height
            color: "transparent"

            property bool isActive: modelData.is_focused
            property bool isUrgent: modelData.is_urgent
            property bool hasWindows: (modelData.active_window_id ?? null) !== null
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
                text: ws.modelData.name && ws.modelData.name.length > 0 ? ws.modelData.name : ws.modelData.idx
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
                onClicked: NiriService.focusWorkspace(ws.modelData.id)
                onContainsMouseChanged: ws.isHovered = containsMouse
                onWheel: event => {
                    if (event.angleDelta.y < 0) NiriService.focusDown();
                    else if (event.angleDelta.y > 0) NiriService.focusUp();
                }
            }
        }
    }
}
