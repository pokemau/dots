import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland._FocusGrab
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    required property var panelWindow

    // Compositor detection
    property bool isHyprland: false

    Process {
        id: compositorDetectProc
        running: true
        command: ["sh", "-c", "[ -n \"$HYPRLAND_INSTANCE_SIGNATURE\" ] && echo hyprland || echo other"]
        stdout: SplitParser {
            onRead: data => { root.isHyprland = data.trim() === "hyprland" }
        }
    }

    // Popup open state
    property bool popupOpen: false
    property bool wifiOpen: true
    property bool volumeOpen: false
    property bool bluetoothOpen: false

    // WiFi state
    property bool wifiEnabled: false
    property bool wifiConnecting: false

    // Audio state (reactive via Pipewire service)
    readonly property var sinkNode: Pipewire.defaultAudioSink
    readonly property var sourceNode: Pipewire.defaultAudioSource
    readonly property string defaultSink: sinkNode ? sinkNode.name : ""
    readonly property string defaultSource: sourceNode ? sourceNode.name : ""
    readonly property int volumeLevel: sinkNode && sinkNode.audio
        ? Math.round(sinkNode.audio.volume * 100) : 0
    readonly property var sinkList: Pipewire.nodes.values.filter(n =>
        n && n.audio && n.isSink && !n.isStream)
    readonly property var sourceList: Pipewire.nodes.values.filter(n =>
        n && n.audio && !n.isSink && !n.isStream)

    PwObjectTracker {
        objects: [root.sinkNode, root.sourceNode]
    }

    // Bluetooth state
    property bool bluetoothEnabled: false
    property bool btConnecting: false
    property string btConnectingName: ""

    implicitWidth: triggerLabel.implicitWidth + 20
    implicitHeight: 24

    // ─── helpers ────────────────────────────────────────────────────
    function signalIcon(sig) {
        if (sig >= 75) return "󰤨"
        if (sig >= 50) return "󰤥"
        if (sig >= 25) return "󰤢"
        return "󰤟"
    }

    function refreshWifi() {
        wifiNetworks.clear()
        wifiStatusProc.running = true
    }

    function refreshBluetooth() {
        btDevices.clear()
        btStatusProc.running = true
    }

    // ─── models ─────────────────────────────────────────────────────
    ListModel { id: wifiNetworks }
    ListModel { id: btDevices }

    // ─── wifi processes ─────────────────────────────────────────────
    Process {
        id: wifiStatusProc
        command: ["nmcli", "radio", "wifi"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                root.wifiEnabled = data.trim().toLowerCase().indexOf("enabled") !== -1
                if (root.wifiEnabled && root.wifiOpen) wifiScanProc.running = true
            }
        }
    }

    Process {
        id: wifiScanProc
        command: ["nmcli", "--escape", "no", "-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "dev", "wifi"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.split(":")
                if (parts.length < 4) return
                var inUse    = parts[0] === "*"
                var security = parts[parts.length - 1]
                var signal   = parseInt(parts[parts.length - 2])
                var ssid     = parts.slice(1, parts.length - 2).join(":")
                if (!ssid) return
                for (var i = 0; i < wifiNetworks.count; i++)
                    if (wifiNetworks.get(i).ssid === ssid) return
                wifiNetworks.append({ ssid: ssid, signal: signal, security: security, inUse: inUse })
            }
        }
    }

    Process {
        id: wifiToggleProc
        command: ["nmcli", "radio", "wifi", root.wifiEnabled ? "off" : "on"]
        onRunningChanged: {
            if (!running) { wifiNetworks.clear(); wifiRefreshTimer.restart() }
        }
    }

    Process {
        id: wifiConnectProc
        property string targetSsid: ""
        command: ["nmcli", "dev", "wifi", "connect", targetSsid]
        onRunningChanged: {
            if (!running) { root.wifiConnecting = false; wifiRefreshTimer.restart() }
        }
    }

    Timer {
        id: wifiRefreshTimer
        interval: 1200; running: false; repeat: false
        onTriggered: refreshWifi()
    }

    // Live NetworkManager event stream → debounced refresh
    Process {
        id: nmMonitorProc
        running: true
        command: ["stdbuf", "-oL", "nmcli", "monitor"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                wifiEventDebounce.restart()
            }
        }
    }

    Timer {
        id: wifiEventDebounce
        interval: 400; running: false; repeat: false
        onTriggered: {
            wifiStatusProc.running = true
            if (root.wifiOpen) refreshWifi()
        }
    }

    // ─── bluetooth processes ─────────────────────────────────────────
    Process {
        id: btStatusProc
        command: ["sh", "-c", "bluetoothctl show | grep 'Powered:'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                root.bluetoothEnabled = data.indexOf("yes") !== -1
                if (root.bluetoothEnabled && root.bluetoothOpen) btPairedProc.running = true
            }
        }
    }

    Process {
        id: btPairedProc
        command: ["bluetoothctl", "devices", "Paired"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                // "Device AA:BB:CC:DD:EE:FF Name"
                var p = data.trim().split(" ")
                if (p.length < 3) return
                btDevices.append({ mac: p[1], name: p.slice(2).join(" "), connected: false })
            }
        }
        onRunningChanged: { if (!running) btConnectedProc.running = true }
    }

    Process {
        id: btConnectedProc
        command: ["bluetoothctl", "devices", "Connected"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var p = data.trim().split(" ")
                if (p.length < 2) return
                var mac = p[1]
                for (var i = 0; i < btDevices.count; i++) {
                    if (btDevices.get(i).mac === mac) {
                        btDevices.set(i, { mac: mac, name: btDevices.get(i).name, connected: true })
                        break
                    }
                }
            }
        }
    }

    Process {
        id: btPowerProc
        property bool turningOn: true
        command: ["bluetoothctl", "power", turningOn ? "on" : "off"]
        onRunningChanged: { if (!running) { btDevices.clear(); btStatusProc.running = true } }
    }

    Process {
        id: btActionProc
        property string targetMac: ""
        property bool shouldConnect: true
        command: ["bluetoothctl", shouldConnect ? "connect" : "disconnect", targetMac]
        onRunningChanged: { if (!running) { root.btConnecting = false; btDevices.clear(); btPairedProc.running = true } }
    }

    // Live BlueZ event stream via DBus → debounced refresh
    Process {
        id: btMonitorProc
        running: true
        command: ["stdbuf", "-oL", "dbus-monitor", "--system",
            "type='signal',sender='org.bluez'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                btEventDebounce.restart()
            }
        }
    }

    Timer {
        id: btEventDebounce
        interval: 400; running: false; repeat: false
        onTriggered: {
            btStatusProc.running = true
            if (root.bluetoothOpen) refreshBluetooth()
        }
    }

    Component.onCompleted: {
        wifiStatusProc.running = true
        btStatusProc.running = true
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
            text: "󰒓"
            color: root.popupOpen ? Theme.colCyan : Theme.colFg
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily
            font.bold: true
        }

        MouseArea {
            id: triggerMouse
            anchors.fill: parent
            anchors.rightMargin: -8
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (!root.popupOpen) controlPopup.anchor.updateAnchor()
                root.popupOpen = !root.popupOpen
            }
        }
    }

    // ─── focus grab ─────────────────────────────────────────────────
    HyprlandFocusGrab {
        id: focusGrab
        active: root.isHyprland && root.popupOpen
        windows: [controlPopup]
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
        id: controlPopup
        visible: root.popupOpen
        anchor.item: triggerPill
        anchor.rect.x: triggerPill.width - controlPopup.implicitWidth
        anchor.rect.y: triggerPill.height + 6
        implicitWidth: 300
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

                // ── Section buttons ───────────────────────────────────
                Row {
                    width: parent.width
                    height: 44
                    spacing: 6

                    // WiFi button
                    Rectangle {
                        width: (parent.width - 12) / 3
                        height: 44
                        radius: 6
                        color: root.wifiOpen ? Qt.rgba(Theme.colCyan.r, Theme.colCyan.g, Theme.colCyan.b, 0.2) : Qt.rgba(1,1,1,0.04)
                        border.width: 1
                        border.color: root.wifiOpen ? Theme.colCyan : Theme.colMuted
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                        Column {
                            anchors.centerIn: parent
                            spacing: 3
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: root.wifiEnabled ? "󰤨" : "󰤮"
                                color: root.wifiOpen ? Theme.colCyan : Theme.colFg
                                font.pixelSize: 17; font.family: Theme.fontFamily
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Wi-Fi"
                                color: root.wifiOpen ? Theme.colCyan : Theme.colFg
                                font.pixelSize: 9; font.family: Theme.fontFamily
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var next = !root.wifiOpen
                                root.wifiOpen = false; root.volumeOpen = false; root.bluetoothOpen = false
                                root.wifiOpen = next
                                if (root.wifiOpen) refreshWifi()
                            }
                        }
                    }

                    // Volume button
                    Rectangle {
                        width: (parent.width - 12) / 3
                        height: 44
                        radius: 6
                        color: root.volumeOpen ? Qt.rgba(Theme.colYellow.r, Theme.colYellow.g, Theme.colYellow.b, 0.2) : Qt.rgba(1,1,1,0.04)
                        border.width: 1
                        border.color: root.volumeOpen ? Theme.colYellow : Theme.colMuted
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                        Column {
                            anchors.centerIn: parent
                            spacing: 3
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: root.volumeLevel > 0 ? "󰕾" : "󰖁"
                                color: root.volumeOpen ? Theme.colYellow : Theme.colFg
                                font.pixelSize: 17; font.family: Theme.fontFamily
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Volume"
                                color: root.volumeOpen ? Theme.colYellow : Theme.colFg
                                font.pixelSize: 9; font.family: Theme.fontFamily
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var next = !root.volumeOpen
                                root.wifiOpen = false; root.volumeOpen = false; root.bluetoothOpen = false
                                root.volumeOpen = next
                            }
                        }
                    }

                    // Bluetooth button
                    Rectangle {
                        width: (parent.width - 12) / 3
                        height: 44
                        radius: 6
                        color: root.bluetoothOpen ? Qt.rgba(Theme.colPurple.r, Theme.colPurple.g, Theme.colPurple.b, 0.2) : Qt.rgba(1,1,1,0.04)
                        border.width: 1
                        border.color: root.bluetoothOpen ? Theme.colPurple : Theme.colMuted
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }
                        Column {
                            anchors.centerIn: parent
                            spacing: 3
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "󰂯"
                                color: root.bluetoothOpen ? Theme.colPurple : Theme.colFg
                                font.pixelSize: 17; font.family: Theme.fontFamily
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Bluetooth"
                                color: root.bluetoothOpen ? Theme.colPurple : Theme.colFg
                                font.pixelSize: 9; font.family: Theme.fontFamily
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var next = !root.bluetoothOpen
                                root.wifiOpen = false; root.volumeOpen = false; root.bluetoothOpen = false
                                root.bluetoothOpen = next
                                if (root.bluetoothOpen) refreshBluetooth()
                            }
                        }
                    }
                }

                // ── WiFi section ──────────────────────────────────────
                Item {
                    width: parent.width
                    height: root.wifiOpen ? (root.wifiConnecting ? 291 : 265) : 0
                    clip: true
                    Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                    Column {
                        width: parent.width
                        topPadding: 10
                        spacing: 6

                        Rectangle { width: parent.width; height: 1; color: Theme.colMuted; opacity: 0.4 }

                        // Header row
                        Item {
                            width: parent.width
                            height: 26

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Wi-Fi"
                                color: Theme.colFg
                                font.pixelSize: Theme.fontSize - 1
                                font.family: Theme.fontFamily
                                font.bold: true
                            }

                            Row {
                                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                                spacing: 8

                                Text {
                                    text: "󰑐"
                                    color: Theme.colMuted
                                    font.pixelSize: Theme.fontSize
                                    font.family: Theme.fontFamily
                                    anchors.verticalCenter: parent.verticalCenter
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: { wifiNetworks.clear(); wifiScanProc.running = true }
                                    }
                                }

                                Rectangle {
                                    width: 48; height: 20; radius: 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: root.wifiEnabled ? Qt.rgba(0.54, 0.71, 0.51, 0.2) : Qt.rgba(0.92, 0.41, 0.38, 0.2)
                                    border.width: 1
                                    border.color: root.wifiEnabled ? Theme.colCyan : Theme.colRed
                                    Text {
                                        anchors.centerIn: parent
                                        text: root.wifiEnabled ? "ON" : "OFF"
                                        color: root.wifiEnabled ? Theme.colCyan : Theme.colRed
                                        font.pixelSize: Theme.fontSize - 3
                                        font.family: Theme.fontFamily
                                        font.bold: true
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: wifiToggleProc.running = true
                                    }
                                }
                            }
                        }

                        // Network list
                        ListView {
                            id: wifiListView
                            width: parent.width
                            height: Math.min(contentHeight, 210)
                            model: wifiNetworks
                            clip: true
                            spacing: 3

                            Text {
                                anchors.centerIn: parent
                                text: wifiNetworks.count === 0 ? (root.wifiEnabled ? "Scanning…" : "Wi-Fi disabled") : ""
                                color: Theme.colMuted
                                font.pixelSize: Theme.fontSize - 2
                                font.family: Theme.fontFamily
                                visible: text !== ""
                            }

                            delegate: Rectangle {
                                width: wifiListView.width
                                height: 26
                                radius: 4
                                color: model.inUse
                                    ? Qt.rgba(Theme.colCyan.r, Theme.colCyan.g, Theme.colCyan.b, 0.15)
                                    : (wMouse.containsMouse ? Qt.rgba(1,1,1,0.05) : "transparent")
                                border.width: model.inUse ? 1 : 0
                                border.color: Theme.colCyan

                                Row {
                                    anchors { fill: parent; leftMargin: 6; rightMargin: 6 }
                                    spacing: 5
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: root.signalIcon(model.signal)
                                        color: model.inUse ? Theme.colCyan : Theme.colMuted
                                        font.pixelSize: Theme.fontSize - 1
                                        font.family: Theme.fontFamily
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - 52
                                        text: model.ssid
                                        color: model.inUse ? Theme.colCyan : Theme.colFg
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                        elide: Text.ElideRight
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "󰌾"
                                        color: Theme.colMuted
                                        font.pixelSize: Theme.fontSize - 3
                                        font.family: Theme.fontFamily
                                        visible: model.security !== "" && model.security !== "--"
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "󰄬"
                                        color: Theme.colCyan
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                        visible: model.inUse
                                    }
                                }

                                MouseArea {
                                    id: wMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: model.inUse ? Qt.ArrowCursor : Qt.PointingHandCursor
                                    onClicked: {
                                        if (!model.inUse && !root.wifiConnecting) {
                                            root.wifiConnecting = true
                                            wifiConnectProc.targetSsid = model.ssid
                                            wifiConnectProc.running = true
                                        }
                                    }
                                }
                            }
                        }

                        Item {
                            width: parent.width
                            height: root.wifiConnecting ? 20 : 0
                            clip: true
                            Behavior on height { NumberAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                text: "Connecting to " + wifiConnectProc.targetSsid + "…"
                                color: Theme.colYellow
                                font.pixelSize: Theme.fontSize - 3
                                font.family: Theme.fontFamily
                                visible: root.wifiConnecting
                                horizontalAlignment: Text.AlignHCenter

                                SequentialAnimation on opacity {
                                    running: root.wifiConnecting
                                    loops: Animation.Infinite
                                    NumberAnimation { to: 0.3; duration: 600; easing.type: Easing.InOutSine }
                                    NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine }
                                }
                            }
                        }
                    }
                }

                // ── Volume section ────────────────────────────────────
                Item {
                    width: parent.width
                    height: root.volumeOpen ? 285 : 0
                    clip: true
                    Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                    Column {
                        width: parent.width
                        topPadding: 10
                        spacing: 6

                        Rectangle { width: parent.width; height: 1; color: Theme.colMuted; opacity: 0.4 }

                        // Volume slider
                        Row {
                            width: parent.width
                            height: 28
                            spacing: 6
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.volumeLevel > 0 ? "󰕾" : "󰖁"
                                color: Theme.colYellow
                                font.pixelSize: Theme.fontSize
                                font.family: Theme.fontFamily
                            }
                            Slider {
                                width: parent.width - 58
                                anchors.verticalCenter: parent.verticalCenter
                                from: 0; to: 100; value: root.volumeLevel
                                onMoved: {
                                    if (root.sinkNode && root.sinkNode.audio)
                                        root.sinkNode.audio.volume = value / 100
                                }
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.volumeLevel + "%"
                                color: Theme.colYellow
                                font.pixelSize: Theme.fontSize - 2
                                font.family: Theme.fontFamily
                                width: 32
                                horizontalAlignment: Text.AlignRight
                            }
                        }

                        // Output label
                        Text {
                            text: "Output"
                            color: Theme.colMuted
                            font.pixelSize: Theme.fontSize - 3
                            font.family: Theme.fontFamily
                            font.bold: true
                            leftPadding: 2
                        }

                        // Output device list
                        ListView {
                            id: sinkListView
                            width: parent.width
                            height: Math.min(contentHeight, 88)
                            model: root.sinkList
                            clip: true
                            spacing: 3

                            Text {
                                anchors.centerIn: parent
                                text: "Loading…"
                                color: Theme.colMuted
                                font.pixelSize: Theme.fontSize - 3
                                font.family: Theme.fontFamily
                                visible: root.sinkList.length === 0
                            }

                            delegate: Rectangle {
                                required property var modelData
                                width: sinkListView.width
                                height: 26
                                radius: 4
                                readonly property bool isDefault: modelData && root.sinkNode === modelData
                                color: isDefault
                                    ? Qt.rgba(Theme.colYellow.r, Theme.colYellow.g, Theme.colYellow.b, 0.15)
                                    : (sMouse.containsMouse ? Qt.rgba(1,1,1,0.05) : "transparent")
                                border.width: isDefault ? 1 : 0
                                border.color: Theme.colYellow

                                Row {
                                    anchors { fill: parent; leftMargin: 6; rightMargin: 6 }
                                    spacing: 5
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: parent.parent.isDefault ? "󰄬" : " "
                                        color: Theme.colYellow
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - 24
                                        text: modelData ? (modelData.description || modelData.name) : ""
                                        color: parent.parent.isDefault ? Theme.colYellow : Theme.colFg
                                        font.pixelSize: Theme.fontSize - 3
                                        font.family: Theme.fontFamily
                                        elide: Text.ElideRight
                                    }
                                }
                                MouseArea {
                                    id: sMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Pipewire.preferredDefaultAudioSink = modelData
                                }
                            }
                        }

                        // Input label
                        Text {
                            text: "Input"
                            color: Theme.colMuted
                            font.pixelSize: Theme.fontSize - 3
                            font.family: Theme.fontFamily
                            font.bold: true
                            leftPadding: 2
                        }

                        // Input device list
                        ListView {
                            id: sourceListView
                            width: parent.width
                            height: Math.min(contentHeight, 88)
                            model: root.sourceList
                            clip: true
                            spacing: 3

                            Text {
                                anchors.centerIn: parent
                                text: "Loading…"
                                color: Theme.colMuted
                                font.pixelSize: Theme.fontSize - 3
                                font.family: Theme.fontFamily
                                visible: root.sourceList.length === 0
                            }

                            delegate: Rectangle {
                                required property var modelData
                                width: sourceListView.width
                                height: 26
                                radius: 4
                                readonly property bool isDefault: modelData && root.sourceNode === modelData
                                color: isDefault
                                    ? Qt.rgba(Theme.colYellow.r, Theme.colYellow.g, Theme.colYellow.b, 0.15)
                                    : (srcMouse.containsMouse ? Qt.rgba(1,1,1,0.05) : "transparent")
                                border.width: isDefault ? 1 : 0
                                border.color: Theme.colYellow

                                Row {
                                    anchors { fill: parent; leftMargin: 6; rightMargin: 6 }
                                    spacing: 5
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: parent.parent.isDefault ? "󰄬" : " "
                                        color: Theme.colYellow
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - 24
                                        text: modelData ? (modelData.description || modelData.name) : ""
                                        color: parent.parent.isDefault ? Theme.colYellow : Theme.colFg
                                        font.pixelSize: Theme.fontSize - 3
                                        font.family: Theme.fontFamily
                                        elide: Text.ElideRight
                                    }
                                }
                                MouseArea {
                                    id: srcMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Pipewire.preferredDefaultAudioSource = modelData
                                }
                            }
                        }
                    }
                }

                // ── Bluetooth section ─────────────────────────────────
                Item {
                    width: parent.width
                    height: root.bluetoothOpen ? (root.btConnecting ? 211 : 185) : 0
                    clip: true
                    Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                    Column {
                        width: parent.width
                        topPadding: 10
                        spacing: 6

                        Rectangle { width: parent.width; height: 1; color: Theme.colMuted; opacity: 0.4 }

                        // Header row
                        Item {
                            width: parent.width
                            height: 26

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Bluetooth"
                                color: Theme.colFg
                                font.pixelSize: Theme.fontSize - 1
                                font.family: Theme.fontFamily
                                font.bold: true
                            }

                            Rectangle {
                                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                                width: 48; height: 20; radius: 4
                                color: root.bluetoothEnabled
                                    ? Qt.rgba(Theme.colPurple.r, Theme.colPurple.g, Theme.colPurple.b, 0.2)
                                    : Qt.rgba(0.92, 0.41, 0.38, 0.2)
                                border.width: 1
                                border.color: root.bluetoothEnabled ? Theme.colPurple : Theme.colRed

                                Text {
                                    anchors.centerIn: parent
                                    text: root.bluetoothEnabled ? "ON" : "OFF"
                                    color: root.bluetoothEnabled ? Theme.colPurple : Theme.colRed
                                    font.pixelSize: Theme.fontSize - 3
                                    font.family: Theme.fontFamily
                                    font.bold: true
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        btPowerProc.turningOn = !root.bluetoothEnabled
                                        btPowerProc.running = true
                                    }
                                }
                            }
                        }

                        // Device list
                        ListView {
                            id: btListView
                            width: parent.width
                            height: 130
                            model: btDevices
                            clip: true
                            spacing: 3

                            Text {
                                anchors.centerIn: parent
                                text: btDevices.count === 0
                                    ? (root.bluetoothEnabled ? "No paired devices" : "Bluetooth disabled")
                                    : ""
                                color: Theme.colMuted
                                font.pixelSize: Theme.fontSize - 2
                                font.family: Theme.fontFamily
                                visible: text !== ""
                            }

                            delegate: Rectangle {
                                width: btListView.width
                                height: 26
                                radius: 4
                                color: model.connected
                                    ? Qt.rgba(Theme.colPurple.r, Theme.colPurple.g, Theme.colPurple.b, 0.15)
                                    : (btMouse.containsMouse ? Qt.rgba(1,1,1,0.05) : "transparent")
                                border.width: model.connected ? 1 : 0
                                border.color: Theme.colPurple

                                Row {
                                    anchors { fill: parent; leftMargin: 6; rightMargin: 6 }
                                    spacing: 6
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: model.connected ? "󰂱" : "󰂯"
                                        color: model.connected ? Theme.colPurple : Theme.colMuted
                                        font.pixelSize: Theme.fontSize
                                        font.family: Theme.fontFamily
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - 36
                                        text: model.name
                                        color: model.connected ? Theme.colPurple : Theme.colFg
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                        elide: Text.ElideRight
                                    }
                                }

                                MouseArea {
                                    id: btMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: root.btConnecting ? Qt.ArrowCursor : Qt.PointingHandCursor
                                    onClicked: {
                                        if (!root.btConnecting) {
                                            root.btConnecting = true
                                            root.btConnectingName = model.name
                                            btActionProc.targetMac = model.mac
                                            btActionProc.shouldConnect = !model.connected
                                            btActionProc.running = true
                                        }
                                    }
                                }
                            }
                        }

                        // Connecting indicator
                        Item {
                            width: parent.width
                            height: root.btConnecting ? 20 : 0
                            clip: true
                            Behavior on height { NumberAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                text: "Connecting to " + root.btConnectingName + "…"
                                color: Theme.colPurple
                                font.pixelSize: Theme.fontSize - 3
                                font.family: Theme.fontFamily
                                visible: root.btConnecting

                                SequentialAnimation on opacity {
                                    running: root.btConnecting
                                    loops: Animation.Infinite
                                    NumberAnimation { to: 0.3; duration: 600; easing.type: Easing.InOutSine }
                                    NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
