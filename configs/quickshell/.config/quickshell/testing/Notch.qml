import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    property bool isHovered: false

    property real topRadius: 4
    property real bottomRadius: 12
    property color notchColor: "#080808"

    property real collapsedWidth: 220
    property real collapsedHeight: 36

    required property var content

    width: isHovered ? content.implicitWidth : collapsedWidth
    height: isHovered ? content.implicitHeight : collapsedHeight
    antialiasing: true
    preferredRendererType: Shape.CurveRenderer

    Behavior on width {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutExpo
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutExpo
        }
    }

    Timer {
        id: closeTimer
        interval: 200
        onTriggered: {
            root.isHovered = false;
        }
    }

    HoverHandler {
        id: hoverHandler

        onHoveredChanged: {
            if (hovered) {
                closeTimer.stop();
                root.isHovered = true;
            } else {
                closeTimer.restart();
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
    }

    ShapePath {

        startX: 0
        startY: 0
        fillColor: root.notchColor
        strokeColor: "transparent"

        // top left
        PathArc {
            x: root.topRadius
            y: root.topRadius
            radiusX: root.topRadius
            radiusY: root.topRadius
            direction: PathArc.Clockwise
        }

        // left wall
        PathLine {
            x: root.topRadius
            y: root.height - root.bottomRadius
        }

        // bot left corner
        PathArc {
            x: root.topRadius + root.bottomRadius
            y: root.height
            radiusX: root.bottomRadius
            radiusY: root.bottomRadius
            direction: PathArc.Counterclockwise
        }

        // bot line
        PathLine {
            x: root.width - root.topRadius - root.bottomRadius
            y: root.height
        }

        // bot right corner
        PathArc {
            x: root.width - root.topRadius
            y: root.height - root.bottomRadius
            radiusX: root.bottomRadius
            radiusY: root.bottomRadius
            direction: PathArc.Counterclockwise
        }

        // right wall
        PathLine {
            x: root.width - root.topRadius
            y: root.topRadius
        }

        // top right corner
        PathArc {
            x: root.width
            y: 0
            radiusX: root.topRadius
            radiusY: root.topRadius
            direction: PathArc.Clockwise
        }
    }
}
