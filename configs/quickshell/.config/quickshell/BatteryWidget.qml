import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland._FocusGrab
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property var panelWindow

    property bool isHyprland: false

    Process {
        id: compositorDetectProc
        running: true
        command: ["sh", "-c", "[ -n \"$HYPRLAND_INSTANCE_SIGNATURE\" ] && echo hyprland || echo other"]
        stdout: SplitParser {
            onRead: data => { root.isHyprland = data.trim() === "hyprland" }
        }
    }

    property bool popupOpen: false
    property int batteryLevel: -1
    property string batteryStatus: ""
    property bool hasBattery: false

    implicitWidth: triggerLabel.implicitWidth + 16
    implicitHeight: 24

    // ─── helpers ────────────────────────────────────────────────────
    function batteryIcon() {
        var charging = batteryStatus === "Charging"
        if (charging) {
            if (batteryLevel >= 90) return "󰂅"
            if (batteryLevel >= 60) return "󰢝"
            if (batteryLevel >= 30) return "󰂉"
            return "󰢜"
        }
        if (batteryLevel >= 95) return "󰁹"
        if (batteryLevel >= 80) return "󰂂"
        if (batteryLevel >= 60) return "󰂀"
        if (batteryLevel >= 40) return "󰁾"
        if (batteryLevel >= 20) return "󰁼"
        if (batteryLevel >= 10) return "󰁺"
        return "󰂎"
    }

    function batteryColor() {
        if (batteryLevel <= 15 && batteryStatus !== "Charging") return Theme.colRed
        if (root.popupOpen) return Theme.colCyan
        return Theme.colFg
    }

    function refreshBattery() {
        batteryCapProc.running = true
        batteryStatusProc.running = true
    }

    // ─── data sources ───────────────────────────────────────────────
    Process {
        id: batteryDetectProc
        running: true
        command: ["sh", "-c", "for d in /sys/class/power_supply/*; do [ \"$(cat $d/type 2>/dev/null)\" = Battery ] && echo yes && exit; done; echo no"]
        stdout: SplitParser {
            onRead: data => { root.hasBattery = data.trim() === "yes" }
        }
    }

    Process {
        id: batteryCapProc
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
        stdout: SplitParser {
            onRead: data => {
                var val = parseInt(data.trim())
                if (!isNaN(val)) root.batteryLevel = val
            }
        }
    }

    Process {
        id: batteryStatusProc
        command: ["cat", "/sys/class/power_supply/BAT0/status"]
        stdout: SplitParser {
            onRead: data => {
                root.batteryStatus = data.trim()
            }
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: refreshBattery()
    }

    Component.onCompleted: {
        refreshBattery()
    }

    // ─── trigger ────────────────────────────────────────────────────
    Rectangle {
        id: triggerPill
        width: root.implicitWidth
        height: root.implicitHeight
        radius: 4
        color: root.popupOpen
            ? Qt.rgba(Theme.colCyan.r, Theme.colCyan.g, Theme.colCyan.b, 0.2)
            : (triggerMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.07) : "transparent")

        Behavior on color { ColorAnimation { duration: 120 } }

        Text {
            id: triggerLabel
            anchors.centerIn: parent
            text: batteryIcon() + " " + (batteryLevel >= 0 ? batteryLevel + "%" : "—")
            color: batteryColor()
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily
            font.bold: true
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        MouseArea {
            id: triggerMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (!root.popupOpen) {
                    batteryPopup.anchor.updateAnchor()
                    refreshBattery()
                }
                root.popupOpen = !root.popupOpen
            }
        }
    }

    // ─── focus grab ─────────────────────────────────────────────────
    HyprlandFocusGrab {
        id: focusGrab
        active: root.isHyprland && root.popupOpen
        windows: [batteryPopup]
        onCleared: root.popupOpen = false
    }

    // ─── click-outside catcher (non-Hyprland compositors) ───────────
    PanelWindow {
        id: dismissOverlay
        visible: !root.isHyprland && root.popupOpen
        color: "transparent"
        anchors { top: true; bottom: true; left: true; right: true }
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        MouseArea {
            anchors.fill: parent
            onPressed: root.popupOpen = false
        }
    }

    // ─── popup ──────────────────────────────────────────────────────
    PopupWindow {
        id: batteryPopup
        visible: root.popupOpen
        anchor.item: triggerPill
        anchor.rect.x: triggerPill.width - batteryPopup.implicitWidth
        anchor.rect.y: triggerPill.height + 6
        implicitWidth: 280
        implicitHeight: innerRect.implicitHeight
        color: "transparent"

        Rectangle {
            id: innerRect
            width: parent.width
            height: implicitHeight
            implicitHeight: mainColumn.implicitHeight + 20
            radius: 8
            border.width: 1
            border.color: Theme.colMuted
            color: Theme.colBg

            Column {
                id: mainColumn
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 10 }
                spacing: 0

                // ── Battery info ─────────────────────────────────────
                Item {
                    width: parent.width
                    height: 60

                    Row {
                        anchors.centerIn: parent
                        spacing: 12

                        Text {
                            text: batteryIcon()
                            color: batteryColor()
                            font.pixelSize: 32
                            font.family: Theme.fontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            Text {
                                text: (batteryLevel >= 0 ? batteryLevel + "%" : "—")
                                color: batteryColor()
                                font.pixelSize: 22
                                font.family: Theme.fontFamily
                                font.bold: true
                            }

                            Text {
                                text: batteryStatus || "Unknown"
                                color: Theme.colMuted
                                font.pixelSize: 11
                                font.family: Theme.fontFamily
                            }
                        }
                    }
                }
            }
        }
    }
}
