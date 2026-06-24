pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property color colBg: "#16181c"
    property color colFg: "#f5f5f7"
    property color colMuted: "#8e8e93"
    property color colCyan: "#0a84ff"
    property color colPurple: "#bf5af3"
    property color colRed: "#ff453a"
    property color colYellow: "#ffd60a"
    property color colBlue: "#0a84ff"
    property color colGreen: "#30d158"
    property color colBgActive: "#2c2c2e"
    property color colBgHover: "#3a3a3c"
    property color colBgAccent: "#0a84ff"

    property real barAlpha: 0.6
    property color barBg: Qt.rgba(colBg.r, colBg.g, colBg.b, barAlpha)
    property color barBorder: Qt.rgba(1, 1, 1, 0.08)

    property string fontFamily: "JetBrains Mono Nerd Font"
    property int fontSize: 12
}
