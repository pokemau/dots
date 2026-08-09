pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    property int cpuUsage: 0
    property int memUsage: 0
    property string activeWindow: "Window"

    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var user    = parseInt(parts[1]) || 0
                var nice    = parseInt(parts[2]) || 0
                var system  = parseInt(parts[3]) || 0
                var idle    = parseInt(parts[4]) || 0
                var iowait  = parseInt(parts[5]) || 0
                var irq     = parseInt(parts[6]) || 0
                var softirq = parseInt(parts[7]) || 0

                var total    = user + nice + system + idle + iowait + irq + softirq
                var idleTime = idle + iowait

                if (root.lastCpuTotal > 0) {
                    var totalDiff = total - root.lastCpuTotal
                    var idleDiff  = idleTime - root.lastCpuIdle
                    if (totalDiff > 0)
                        root.cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
                }
                root.lastCpuTotal = total
                root.lastCpuIdle  = idleTime
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used  = parseInt(parts[2]) || 0
                root.memUsage = Math.round(100 * used / total)
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: windowProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.title // empty'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim())
                    root.activeWindow = data.trim()
            }
        }
        Component.onCompleted: running = true
    }

    // System stats every 2s
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
        }
    }

    // Event-based window title update
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            windowProc.running = true
        }
    }

    // Backup poll for window title
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: windowProc.running = true
    }
}
