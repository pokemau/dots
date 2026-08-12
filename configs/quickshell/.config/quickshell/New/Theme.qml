pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: theme

    readonly property string fontFamily: "SF Mono"
    readonly property int fontSize: 12

    readonly property color bg: "#16181c"
    readonly property color fg: "#f5f5f7"
    readonly property color bgActive: "#2c2c2e"
    readonly property color bgAccent: "#0a84ff"
    readonly property color bgHover: "#3a3a3c"

    readonly property color fgWhite: "#ffffff"
    readonly property color fgMuted: "#8e8e93"

    readonly property color red: "#ff453a"

    readonly property real barAlpha: 0.8
    readonly property color barBg: Qt.rgba(bg.r, bg.g, bg.b, barAlpha)
    readonly property color barBorder: Qt.rgba(1, 1, 1, 0.08)
}
