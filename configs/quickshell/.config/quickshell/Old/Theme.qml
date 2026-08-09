pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property color colBg: "#16181c"
    readonly property color colFg: "#f5f5f7"
    readonly property color colMuted: "#8e8e93"
    readonly property color colCyan: "#0a84ff"
    readonly property color colPurple: "#bf5af3"
    readonly property color colRed: "#ff453a"
    readonly property color colYellow: "#ffd60a"
    readonly property color colBlue: "#0a84ff"
    readonly property color colGreen: "#30d158"
    readonly property color colBgActive: "#2c2c2e"
    readonly property color colBgHover: "#3a3a3c"
    readonly property color colBgAccent: "#0a84ff"

    readonly property real barAlpha: 0.8
    readonly property color barBg: Qt.rgba(colBg.r, colBg.g, colBg.b, barAlpha)
    readonly property color barBorder: Qt.rgba(1, 1, 1, 0.08)

    readonly property string fontFamily: "Roboto Mono Nerd Font"
    readonly property int fontSize: 12
}
