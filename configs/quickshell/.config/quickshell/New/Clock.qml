import Quickshell
import QtQuick

Text {
    color: Theme.fg
    text: Qt.formatDateTime(clock.date, "ddd, MMM d h:mm AP")

    font {
        family: "SF Mono"
        pixelSize: 12
        weight: 600
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
