import QtQuick

Text {
    id: clockText
    text: Qt.formatDateTime(new Date(), "ddd, MMM dd - h:mm AP")
    color: Theme.colCyan
    font.pixelSize: Theme.fontSize
    font.family: Theme.fontFamily
    font.bold: true

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - h:mm AP")
    }
}
