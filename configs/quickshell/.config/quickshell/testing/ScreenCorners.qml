import QtQuick
import QtQuick.Shapes

// TOP LEFT CORNER
Shape {
    id: leftCorner

    readonly property real cornerRadius: 12

    width: cornerRadius
    height: cornerRadius

    anchors {
        left: parent.left
        top: parent.top
    }

    layer {
        enabled: true
        samples: 4
    }

    ShapePath {
        startX: 0
        startY: 0
        fillColor: "black"
        strokeColor: "transparent"

        // top line
        PathLine {
            x: leftCorner.cornerRadius
            y: 0
        }

        // the arc
        PathArc {
            x: 0
            y: leftCorner.cornerRadius
            radiusX: leftCorner.cornerRadius
            radiusY: leftCorner.cornerRadius
            direction: PathArc.Counterclockwise
        }
    }
}

// // TOP RIGHT CORNER
// Shape {
//     id: rightCorner
//
//     readonly property real cornerRadius: 12
//
//     width: cornerRadius
//     height: cornerRadius
//
//     anchors {
//         right: parent.right
//         top: parent.top
//     }
//
//     layer {
//         enabled: true
//         samples: 4
//     }
//
//     ShapePath {
//         startX: 0
//         startY: 0
//         fillColor: "black"
//         strokeColor: "transparent"
//
//         PathLine {
//             x: rightCorner.cornerRadius
//             y: 0
//         }
//
//         PathLine {
//             x: rightCorner.cornerRadius
//             y: rightCorner.cornerRadius
//         }
//
//         PathArc {
//             x: 0
//             y: 0
//             radiusX: rightCorner.cornerRadius
//             radiusY: rightCorner.cornerRadius
//             direction: PathArc.Counterclockwise
//         }
//
//     }
//
// }
