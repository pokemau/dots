import QtQuick

Item {
    id: testRoot

    implicitWidth : textContent.width + 140
    implicitHeight: textContent.height + 140

    Text {
        id: textContent
        anchors.centerIn: parent
        text: "CHASE CHASE CAHSE CHASE ?"
        color: "white"
        font.pixelSize: 18
        font.bold: true
    }
}
