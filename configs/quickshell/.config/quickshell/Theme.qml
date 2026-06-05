pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property color colBg: "#1d2021"
    property color colFg: "#fbf1c7"
    property color colMuted: "#7c6f64"
    property color colCyan: "#89b482"
    property color colPurple: "#d3869b"
    property color colRed: "#fb4934"
    property color colYellow: "#fabd2f"
    property color colBlue: "#7daea3"
    property color colBgActive: "#3c3836"
    property color colBgHover: "#b8bb26"
    property color colBgAccent: "#b8bb26"

    property real barAlpha: 0.7
    property color barBg: Qt.rgba(colBg.r, colBg.g, colBg.b, barAlpha)

    property string fontFamily: "RobotoMono Nerd Font"
    property int fontSize: 13
}
