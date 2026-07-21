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
    property bool wifiOpen: false
    property bool volumeOpen: false
    property bool bluetoothOpen: false

    // Hardware presence
    property bool hasWifi: false
    property bool hasBluetooth: false

    // WiFi state
    property bool wifiEnabled: false
    property bool wifiConnecting: false
    property string wifiConnectedName: ""

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
    property string btConnectedName: ""

    // Power profile state
    property string powerProfile: ""

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
        root.wifiConnectedName = ""
        wifiStatusProc.running = true
    }

    function refreshBluetooth() {
        btDevices.clear()
        root.btConnectedName = ""
        btStatusProc.running = true
    }

    function refreshProfile() {
        profileGetProc.running = true
    }

    function profileAccent(profile) {
        if (profile === "power-saver") return Theme.colGreen
        if (profile === "balanced") return Theme.colYellow
        return Theme.colRed
    }

    // ─── hardware detection ─────────────────────────────────────────
    Process {
        id: wifiDetectProc
        running: true
        command: ["sh", "-c", "nmcli -t -f TYPE device 2>/dev/null | grep -qx wifi && echo yes || echo no"]
        stdout: SplitParser {
            onRead: data => { root.hasWifi = data.trim() === "yes" }
        }
    }

    Process {
        id: btDetectProc
        running: true
        command: ["sh", "-c", "bluetoothctl list 2>/dev/null | grep -q Controller && echo yes || echo no"]
        stdout: SplitParser {
            onRead: data => { root.hasBluetooth = data.trim() === "yes" }
        }
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
                if (root.wifiEnabled) wifiScanProc.running = true
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
                if (inUse) root.wifiConnectedName = ssid
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
                if (root.bluetoothEnabled) btPairedProc.running = true
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
                        root.btConnectedName = btDevices.get(i).name
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

    // ─── power profile processes ────────────────────────────────────
    Process {
        id: profileGetProc
        command: ["powerprofilesctl", "get"]
        stdout: SplitParser {
            onRead: data => { root.powerProfile = data.trim() }
        }
    }

    Process {
        id: profileSetProc
        property string target: ""
        command: ["powerprofilesctl", "set", target]
        onRunningChanged: {
            if (!running && target !== "") root.powerProfile = target
        }
    }

    Component.onCompleted: {
        wifiStatusProc.running = true
        btStatusProc.running = true
        refreshProfile()
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
                if (!root.popupOpen) {
                    controlPopup.anchor.updateAnchor()
                    refreshProfile()
                }
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

    PopupWindow {
        id: controlPopup
        visible: root.popupOpen
        anchor.item: triggerPill
        anchor.rect.x: triggerPill.width - controlPopup.implicitWidth
        anchor.rect.y: triggerPill.height + 8
        implicitWidth: 320
        implicitHeight: card.implicitHeight
        color: "transparent"

        // ── outer translucent card ──
        Rectangle {
            id: card
            width: parent.width
            height: implicitHeight
            implicitHeight: contentCol.implicitHeight + 24
            radius: 18
            color: Qt.rgba(Theme.colBg.r, Theme.colBg.g, Theme.colBg.b, 0.92)
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.08)

            Column {
                id: contentCol
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
                spacing: 10

                // ══ Connectivity module ══════════════════════════════
                Rectangle {
                    id: connModule
                    width: parent.width
                    height: connCol.implicitHeight
                    radius: 14
                    color: Theme.colBgActive
                    visible: root.hasWifi || root.hasBluetooth

                    Column {
                        id: connCol
                        width: parent.width

                        // ── Wi-Fi row ──
                        Item {
                            width: parent.width
                            height: 58
                            visible: root.hasWifi

                            // circular toggle button
                            Rectangle {
                                id: wifiToggle
                                width: 38; height: 38; radius: 19
                                anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
                                color: root.wifiEnabled ? Theme.colBlue : Qt.rgba(1, 1, 1, 0.14)
                                Behavior on color { ColorAnimation { duration: 150 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: root.wifiEnabled ? "󰤨" : "󰤮"
                                    color: root.wifiEnabled ? "#ffffff" : Theme.colFg
                                    font.pixelSize: 18
                                    font.family: Theme.fontFamily
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: wifiToggleProc.running = true
                                }
                            }

                            Column {
                                anchors { left: wifiToggle.right; leftMargin: 12; verticalCenter: parent.verticalCenter }
                                spacing: 1
                                Text {
                                    text: "Wi-Fi"
                                    color: Theme.colFg
                                    font.pixelSize: Theme.fontSize
                                    font.family: Theme.fontFamily
                                    font.bold: true
                                }
                                Text {
                                    text: !root.wifiEnabled ? "Off"
                                        : (root.wifiConnectedName !== "" ? root.wifiConnectedName : "On")
                                    color: Theme.colMuted
                                    font.pixelSize: Theme.fontSize - 2
                                    font.family: Theme.fontFamily
                                    width: 180
                                    elide: Text.ElideRight
                                }
                            }

                            Text {
                                anchors { right: parent.right; rightMargin: 14; verticalCenter: parent.verticalCenter }
                                text: root.wifiOpen ? "󰅃" : "󰅀"
                                color: Theme.colMuted
                                font.pixelSize: Theme.fontSize
                                font.family: Theme.fontFamily
                            }

                            MouseArea {
                                anchors { left: parent.left; right: parent.right; top: parent.top; bottom: parent.bottom; leftMargin: 62 }
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    var next = !root.wifiOpen
                                    root.bluetoothOpen = false
                                    root.wifiOpen = next
                                    if (root.wifiOpen) refreshWifi()
                                }
                            }
                        }

                        // ── Wi-Fi expansion ──
                        Item {
                            width: parent.width
                            visible: root.hasWifi
                            height: root.wifiOpen ? (root.wifiConnecting ? 282 : 256) : 0
                            clip: true
                            Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                            Column {
                                width: parent.width

                                Rectangle {
                                    anchors { left: parent.left; right: parent.right; leftMargin: 14; rightMargin: 14 }
                                    height: 1
                                    color: Qt.rgba(1, 1, 1, 0.08)
                                }

                                // sub-header
                                Item {
                                    width: parent.width
                                    height: 30
                                    Text {
                                        anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
                                        text: "Networks"
                                        color: Theme.colMuted
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                        font.bold: true
                                    }
                                    Text {
                                        anchors { right: parent.right; rightMargin: 14; verticalCenter: parent.verticalCenter }
                                        text: "󰑐"
                                        color: Theme.colMuted
                                        font.pixelSize: Theme.fontSize
                                        font.family: Theme.fontFamily
                                        MouseArea {
                                            anchors.fill: parent
                                            anchors.margins: -6
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: { wifiNetworks.clear(); wifiScanProc.running = true }
                                        }
                                    }
                                }

                                ListView {
                                    id: wifiListView
                                    width: parent.width
                                    height: Math.min(contentHeight, 206)
                                    model: wifiNetworks
                                    clip: true
                                    spacing: 2

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
                                        height: 32
                                        readonly property bool sel: model.inUse
                                        color: sel
                                            ? Qt.rgba(Theme.colBlue.r, Theme.colBlue.g, Theme.colBlue.b, 0.18)
                                            : (wMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : "transparent")

                                        Row {
                                            anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
                                            spacing: 8
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: root.signalIcon(model.signal)
                                                color: sel ? Theme.colBlue : Theme.colFg
                                                font.pixelSize: Theme.fontSize
                                                font.family: Theme.fontFamily
                                            }
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                width: parent.width - 64
                                                text: model.ssid
                                                color: Theme.colFg
                                                font.pixelSize: Theme.fontSize - 2
                                                font.family: Theme.fontFamily
                                                elide: Text.ElideRight
                                            }
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: "󰌾"
                                                color: Theme.colMuted
                                                font.pixelSize: Theme.fontSize - 2
                                                font.family: Theme.fontFamily
                                                visible: model.security !== "" && model.security !== "--"
                                            }
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: "󰄬"
                                                color: Theme.colBlue
                                                font.pixelSize: Theme.fontSize - 1
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
                                    height: root.wifiConnecting ? 26 : 0
                                    clip: true
                                    Behavior on height { NumberAnimation { duration: 150 } }
                                    Text {
                                        anchors.centerIn: parent
                                        text: "Connecting to " + wifiConnectProc.targetSsid + "…"
                                        color: Theme.colYellow
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                        visible: root.wifiConnecting
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

                        // ── divider between rows ──
                        Rectangle {
                            anchors { left: parent.left; leftMargin: 62 }
                            width: parent.width - 62
                            height: 1
                            color: Qt.rgba(1, 1, 1, 0.06)
                            visible: root.hasWifi && root.hasBluetooth
                        }

                        // ── Bluetooth row ──
                        Item {
                            width: parent.width
                            height: 58
                            visible: root.hasBluetooth

                            Rectangle {
                                id: btToggle
                                width: 38; height: 38; radius: 19
                                anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
                                color: root.bluetoothEnabled ? Theme.colBlue : Qt.rgba(1, 1, 1, 0.14)
                                Behavior on color { ColorAnimation { duration: 150 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: "󰂯"
                                    color: root.bluetoothEnabled ? "#ffffff" : Theme.colFg
                                    font.pixelSize: 18
                                    font.family: Theme.fontFamily
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

                            Column {
                                anchors { left: btToggle.right; leftMargin: 12; verticalCenter: parent.verticalCenter }
                                spacing: 1
                                Text {
                                    text: "Bluetooth"
                                    color: Theme.colFg
                                    font.pixelSize: Theme.fontSize
                                    font.family: Theme.fontFamily
                                    font.bold: true
                                }
                                Text {
                                    text: !root.bluetoothEnabled ? "Off"
                                        : (root.btConnectedName !== "" ? root.btConnectedName : "On")
                                    color: Theme.colMuted
                                    font.pixelSize: Theme.fontSize - 2
                                    font.family: Theme.fontFamily
                                    width: 180
                                    elide: Text.ElideRight
                                }
                            }

                            Text {
                                anchors { right: parent.right; rightMargin: 14; verticalCenter: parent.verticalCenter }
                                text: root.bluetoothOpen ? "󰅃" : "󰅀"
                                color: Theme.colMuted
                                font.pixelSize: Theme.fontSize
                                font.family: Theme.fontFamily
                            }

                            MouseArea {
                                anchors { left: parent.left; right: parent.right; top: parent.top; bottom: parent.bottom; leftMargin: 62 }
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    var next = !root.bluetoothOpen
                                    root.wifiOpen = false
                                    root.bluetoothOpen = next
                                    if (root.bluetoothOpen) refreshBluetooth()
                                }
                            }
                        }

                        // ── Bluetooth expansion ──
                        Item {
                            width: parent.width
                            visible: root.hasBluetooth
                            height: root.bluetoothOpen ? (root.btConnecting ? 198 : 172) : 0
                            clip: true
                            Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                            Column {
                                width: parent.width

                                Rectangle {
                                    anchors { left: parent.left; right: parent.right; leftMargin: 14; rightMargin: 14 }
                                    height: 1
                                    color: Qt.rgba(1, 1, 1, 0.08)
                                }

                                Item {
                                    width: parent.width
                                    height: 30
                                    Text {
                                        anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
                                        text: "Devices"
                                        color: Theme.colMuted
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                        font.bold: true
                                    }
                                }

                                ListView {
                                    id: btListView
                                    width: parent.width
                                    height: 124
                                    model: btDevices
                                    clip: true
                                    spacing: 2

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
                                        height: 32
                                        color: model.connected
                                            ? Qt.rgba(Theme.colBlue.r, Theme.colBlue.g, Theme.colBlue.b, 0.18)
                                            : (btMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : "transparent")

                                        Row {
                                            anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
                                            spacing: 8
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: model.connected ? "󰂱" : "󰂯"
                                                color: model.connected ? Theme.colBlue : Theme.colFg
                                                font.pixelSize: Theme.fontSize
                                                font.family: Theme.fontFamily
                                            }
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                width: parent.width - 48
                                                text: model.name
                                                color: Theme.colFg
                                                font.pixelSize: Theme.fontSize - 2
                                                font.family: Theme.fontFamily
                                                elide: Text.ElideRight
                                            }
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: "󰄬"
                                                color: Theme.colBlue
                                                font.pixelSize: Theme.fontSize - 1
                                                font.family: Theme.fontFamily
                                                visible: model.connected
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

                                Item {
                                    width: parent.width
                                    height: root.btConnecting ? 26 : 0
                                    clip: true
                                    Behavior on height { NumberAnimation { duration: 150 } }
                                    Text {
                                        anchors.centerIn: parent
                                        text: "Connecting to " + root.btConnectingName + "…"
                                        color: Theme.colYellow
                                        font.pixelSize: Theme.fontSize - 2
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

                // ══ Sound module ═════════════════════════════════════
                Rectangle {
                    id: soundModule
                    width: parent.width
                    height: soundCol.implicitHeight
                    radius: 14
                    color: Theme.colBgActive

                    Column {
                        id: soundCol
                        width: parent.width
                        topPadding: 12
                        bottomPadding: 12
                        spacing: 10

                        // header
                        Item {
                            width: parent.width
                            height: 16
                            Text {
                                anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
                                text: "Sound"
                                color: Theme.colFg
                                font.pixelSize: Theme.fontSize - 1
                                font.family: Theme.fontFamily
                                font.bold: true
                            }
                            Text {
                                anchors { right: parent.right; rightMargin: 14; verticalCenter: parent.verticalCenter }
                                text: root.volumeOpen ? "󰅃" : "󰅀"
                                color: Theme.colMuted
                                font.pixelSize: Theme.fontSize
                                font.family: Theme.fontFamily
                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -8
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.volumeOpen = !root.volumeOpen
                                }
                            }
                        }

                        // capsule slider
                        Item {
                            id: volSlider
                            anchors { left: parent.left; right: parent.right; leftMargin: 14; rightMargin: 14 }
                            height: 30

                            Rectangle {
                                id: volTrack
                                anchors.fill: parent
                                radius: height / 2
                                color: Qt.rgba(1, 1, 1, 0.10)

                                Rectangle {
                                    id: volFill
                                    height: parent.height
                                    width: Math.max(parent.height, parent.width * root.volumeLevel / 100)
                                    radius: parent.radius
                                    color: "#ffffff"
                                }

                                Text {
                                    anchors { left: parent.left; leftMargin: 9; verticalCenter: parent.verticalCenter }
                                    text: root.volumeLevel > 0 ? "󰕾" : "󰖁"
                                    color: Theme.colBg
                                    font.pixelSize: Theme.fontSize - 1
                                    font.family: Theme.fontFamily
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                function apply(mx) {
                                    var v = Math.max(0, Math.min(1, mx / width))
                                    if (root.sinkNode && root.sinkNode.audio)
                                        root.sinkNode.audio.volume = v
                                }
                                onPressed: apply(mouseX)
                                onPositionChanged: if (pressed) apply(mouseX)
                            }
                        }

                        // ── device expansion ──
                        Item {
                            width: parent.width
                            height: root.volumeOpen ? 244 : 0
                            clip: true
                            Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                            Column {
                                width: parent.width
                                spacing: 4

                                Text {
                                    leftPadding: 14
                                    topPadding: 4
                                    text: "Output"
                                    color: Theme.colMuted
                                    font.pixelSize: Theme.fontSize - 2
                                    font.family: Theme.fontFamily
                                    font.bold: true
                                }

                                ListView {
                                    id: sinkListView
                                    width: parent.width
                                    height: Math.min(contentHeight, 96)
                                    model: root.sinkList
                                    clip: true
                                    spacing: 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: "Loading…"
                                        color: Theme.colMuted
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                        visible: root.sinkList.length === 0
                                    }

                                    delegate: Rectangle {
                                        required property var modelData
                                        width: sinkListView.width
                                        height: 30
                                        readonly property bool isDefault: modelData && root.sinkNode === modelData
                                        color: isDefault
                                            ? Qt.rgba(Theme.colBlue.r, Theme.colBlue.g, Theme.colBlue.b, 0.18)
                                            : (sMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : "transparent")

                                        Row {
                                            anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
                                            spacing: 8
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: parent.parent.isDefault ? "󰄬" : "󰕾"
                                                color: parent.parent.isDefault ? Theme.colBlue : Theme.colMuted
                                                font.pixelSize: Theme.fontSize - 1
                                                font.family: Theme.fontFamily
                                            }
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                width: parent.width - 32
                                                text: modelData ? (modelData.description || modelData.name) : ""
                                                color: Theme.colFg
                                                font.pixelSize: Theme.fontSize - 2
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

                                Text {
                                    leftPadding: 14
                                    topPadding: 4
                                    text: "Input"
                                    color: Theme.colMuted
                                    font.pixelSize: Theme.fontSize - 2
                                    font.family: Theme.fontFamily
                                    font.bold: true
                                }

                                ListView {
                                    id: sourceListView
                                    width: parent.width
                                    height: Math.min(contentHeight, 96)
                                    model: root.sourceList
                                    clip: true
                                    spacing: 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: "Loading…"
                                        color: Theme.colMuted
                                        font.pixelSize: Theme.fontSize - 2
                                        font.family: Theme.fontFamily
                                        visible: root.sourceList.length === 0
                                    }

                                    delegate: Rectangle {
                                        required property var modelData
                                        width: sourceListView.width
                                        height: 30
                                        readonly property bool isDefault: modelData && root.sourceNode === modelData
                                        color: isDefault
                                            ? Qt.rgba(Theme.colBlue.r, Theme.colBlue.g, Theme.colBlue.b, 0.18)
                                            : (srcMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : "transparent")

                                        Row {
                                            anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
                                            spacing: 8
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: parent.parent.isDefault ? "󰄬" : "󰍬"
                                                color: parent.parent.isDefault ? Theme.colBlue : Theme.colMuted
                                                font.pixelSize: Theme.fontSize - 1
                                                font.family: Theme.fontFamily
                                            }
                                            Text {
                                                anchors.verticalCenter: parent.verticalCenter
                                                width: parent.width - 32
                                                text: modelData ? (modelData.description || modelData.name) : ""
                                                color: Theme.colFg
                                                font.pixelSize: Theme.fontSize - 2
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
                    }
                }

                // ══ Power Mode module ════════════════════════════════
                Rectangle {
                    id: powerModule
                    width: parent.width
                    height: powerCol.implicitHeight
                    radius: 14
                    color: Theme.colBgActive
                    visible: root.powerProfile !== ""

                    Column {
                        id: powerCol
                        width: parent.width
                        topPadding: 12
                        bottomPadding: 12
                        spacing: 10

                        Text {
                            leftPadding: 14
                            text: "Power Mode"
                            color: Theme.colFg
                            font.pixelSize: Theme.fontSize - 1
                            font.family: Theme.fontFamily
                            font.bold: true
                        }

                        // segmented control
                        Rectangle {
                            anchors { left: parent.left; right: parent.right; leftMargin: 14; rightMargin: 14 }
                            height: 56
                            radius: 12
                            color: Qt.rgba(1, 1, 1, 0.06)

                            Row {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 4

                                Repeater {
                                    model: [
                                        { profileId: "power-saver", label: "Saver",    icon: "󰌪" },
                                        { profileId: "balanced",    label: "Balanced", icon: "󰛲" },
                                        { profileId: "performance", label: "Perform",  icon: "󰓅" }
                                    ]
                                    delegate: Rectangle {
                                        required property var modelData
                                        readonly property bool active: root.powerProfile === modelData.profileId
                                        readonly property color accent: root.profileAccent(modelData.profileId)
                                        width: (parent.width - 8) / 3
                                        height: parent.height
                                        radius: 9
                                        color: active ? Qt.rgba(accent.r, accent.g, accent.b, 0.22) : "transparent"
                                        Behavior on color { ColorAnimation { duration: 150 } }

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 3
                                            Text {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: modelData.icon
                                                color: parent.parent.active ? parent.parent.accent : Theme.colFg
                                                font.pixelSize: 18
                                                font.family: Theme.fontFamily
                                            }
                                            Text {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: modelData.label
                                                color: parent.parent.active ? parent.parent.accent : Theme.colMuted
                                                font.pixelSize: Theme.fontSize - 4
                                                font.family: Theme.fontFamily
                                            }
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                profileSetProc.target = modelData.profileId
                                                profileSetProc.running = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
