pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var workspaces: []
    property int focusedId: -1

    function _replaceWorkspaces(list) {
        workspaces = (list ?? []).slice().sort((a, b) => {
            const o = (a.output ?? "").localeCompare(b.output ?? "");
            return o !== 0 ? o : (a.idx - b.idx);
        });
        const f = workspaces.find(w => w.is_focused);
        focusedId = f ? f.id : -1;
    }

    function _patchWorkspace(id, patch) {
        const next = workspaces.map(w => w.id === id ? Object.assign({}, w, patch) : w);
        workspaces = next;
    }

    function focusWorkspace(id) {
        focusProc.command = ["niri", "msg", "action", "focus-workspace", String(id)];
        focusProc.running = true;
    }

    function focusUp()   { upProc.running = true; }
    function focusDown() { dnProc.running = true; }

    Process { id: focusProc }
    Process { id: upProc;   command: ["niri", "msg", "action", "focus-workspace-up"] }
    Process { id: dnProc;   command: ["niri", "msg", "action", "focus-workspace-down"] }

    Process {
        running: true
        command: ["niri", "msg", "--json", "event-stream"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return;
                let evt;
                try { evt = JSON.parse(data); } catch (e) { return; }
                const key = Object.keys(evt)[0];
                const body = evt[key];
                switch (key) {
                case "WorkspacesChanged":
                    root._replaceWorkspaces(body.workspaces);
                    break;
                case "WorkspaceActivated": {
                    const target = root.workspaces.find(w => w.id === body.id);
                    if (!target) return;
                    const next = root.workspaces.map(w => {
                        const sameOutput = w.output === target.output;
                        const isTarget = w.id === body.id;
                        return Object.assign({}, w, {
                            is_active: sameOutput ? isTarget : w.is_active,
                            is_focused: body.focused ? isTarget : (isTarget ? false : w.is_focused),
                        });
                    });
                    root.workspaces = next;
                    if (body.focused) root.focusedId = body.id;
                    break;
                }
                case "WorkspaceUrgencyChanged":
                    root._patchWorkspace(body.id, { is_urgent: body.urgent });
                    break;
                case "WorkspaceActiveWindowChanged":
                    root._patchWorkspace(body.workspace_id, { active_window_id: body.active_window_id });
                    break;
                }
            }
        }
    }
}
