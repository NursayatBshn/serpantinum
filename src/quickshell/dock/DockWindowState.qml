import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../"
import "../notifications"

PanelWindow {
    id: dockWindow
    required property var modelData
    screen: modelData

    property int configRevision: 0
    property bool initialized: false

    readonly property real screenWidth: (dockWindow.screen && dockWindow.screen.width > 0) ? dockWindow.screen.width : (modelData && modelData.width > 0 ? modelData.width : 0)
    readonly property real screenHeight: (dockWindow.screen && dockWindow.screen.height > 0) ? dockWindow.screen.height : (modelData && modelData.height > 0 ? modelData.height : 0)
    readonly property real effectiveWindowWidth: dockWindow.width > 0 ? dockWindow.width : screenWidth
    readonly property real effectiveWindowHeight: dockWindow.height > 0 ? dockWindow.height : screenHeight

    Connections {
        target: (typeof Config !== "undefined") ? Config : null
        function onSettingsLoaded() { dockWindow.configRevision++; }
        function onDataReadyChanged() { dockWindow.configRevision++; }
        function onRawSettingsChanged() { dockWindow.configRevision++; }
    }

    property var defaultDockSettings: ({
        "enabled": true,
        "position": "bottom",
        "onTop": true,
        "elementSize": 44,
        "floating": false,
        "background": true,
        "exclusive": false,
        "autohide": false,
        "smartAutohide": true,
        "autohideTimeout": 1000,
        "editing": false,
        "apps": [
            { "name": "Kitty", "comment": "Fast, feature-rich, GPU based terminal", "desktop_id": "kitty.desktop", "icon": "kitty" },
            { "name": "Files", "comment": "Access and organize files", "desktop_id": "ski.desktop", "icon": "ski" }
        ],
        "overrideBoundsCorrection": false,
        "enableScrolling": false,
        "visibleElements": 7,
        "scrollingElements": 7,
        "maxVisibleElements": 7,
        "maxElements": 7,
        "hoverScale": 120,
        "cascadeScale": false,
        "hoverBulge": true,
        "hoverBulgeHeight": 12,
        "hoverBulgeWidth": 140,
        "hoverBulgeSmoothness": 18,
        "hoverStretchEdges": true,
        "hoverEffectMode": "parabolic",
        "cascadeRadius": 2,
        "hoverLift": 5,
        "hoverSpread": 10,
        "hoverAnimDuration": 220,
        "hoverTilt": false,
        "hoverGlow": false,
        "launchBounce": true,
        "dockPadding": 8,
        "itemSpacing": 8,
        "iconRadius": 28,
        "dockCornerRadius": -1,
        "dockOpacity": -1,
        "showNotifBadges": true,
        "notifBadgeStyle": "count",
        "notifBadgeColor": "red",
        "focusRunning": true,
        "showRunningIndicators": true,
        "showRunningApps": false,
        "runningScope": "auto"
    })

    property var rawDockSettings: {
        let dummy = configRevision;
        if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings.dock) {
            return Config.rawSettings.dock;
        }
        if (typeof Config !== "undefined" && typeof Config.getSetting === "function") {
            return Config.getSetting("dock", defaultDockSettings);
        }
        return defaultDockSettings;
    }

    property var defaultLauncherSettings: ({
        "position": "top",
        "width": 600,
        "itemCount": 6,
        "terminalCommand": "kitty -e",
        "smartRanking": true
    })

    property var rawLauncherSettings: {
        let dummy = configRevision;
        if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings.launcher) {
            return Config.rawSettings.launcher;
        }
        if (typeof Config !== "undefined" && typeof Config.getSetting === "function") {
            return Config.getSetting("launcher", defaultLauncherSettings);
        }
        return defaultLauncherSettings;
    }

    property real launcherCustomWidth: (rawLauncherSettings && rawLauncherSettings.width !== undefined && !isNaN(rawLauncherSettings.width) && rawLauncherSettings.width > 0) ? rawLauncherSettings.width : 600
    property int launcherCustomItemCount: (rawLauncherSettings && rawLauncherSettings.itemCount !== undefined && !isNaN(rawLauncherSettings.itemCount) && rawLauncherSettings.itemCount > 0) ? rawLauncherSettings.itemCount : 6

    property bool dockEnabled: rawDockSettings.enabled !== undefined ? rawDockSettings.enabled : true
    property string dockPosition: rawDockSettings.position !== undefined ? rawDockSettings.position : "bottom"
    property bool dockOnTop: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.onTop !== undefined) {
            val = rawDockSettings.onTop;
        } else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.onTop"] !== undefined) {
            val = Config.rawSettings["dock.onTop"];
        }
        if (val === undefined || val === null) return true;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }
    property bool editMode: rawDockSettings.editing !== undefined ? rawDockSettings.editing : false
    property int rawElementSize: rawDockSettings.elementSize !== undefined ? rawDockSettings.elementSize : 44
    property bool overrideBoundsCorrection: rawDockSettings.overrideBoundsCorrection !== undefined ? Boolean(rawDockSettings.overrideBoundsCorrection) : false

    property bool dockExclusive: {
        let val = undefined;
        if (rawDockSettings) {
            val = rawDockSettings.exclusive !== undefined ? rawDockSettings.exclusive : rawDockSettings.exclusiveMode;
        }
        if (val === undefined && typeof Config !== "undefined" && Config.rawSettings) {
            val = Config.rawSettings["dock.exclusive"] !== undefined ? Config.rawSettings["dock.exclusive"] : Config.rawSettings["dock.exclusiveMode"];
        }
        if (val === undefined || val === null) return false;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property bool smartAutohide: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.smartAutohide !== undefined) {
            val = rawDockSettings.smartAutohide;
        } else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.smartAutohide"] !== undefined) {
            val = Config.rawSettings["dock.smartAutohide"];
        }
        if (val === undefined || val === null) return true;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    readonly property string myOutput: (dockWindow.screen && dockWindow.screen.name) ? dockWindow.screen.name : ""
    readonly property int niriActiveIndex: NiriState.activeIndexFor(myOutput)
    readonly property var niriOccupiedMap: NiriState.occupiedMap
    readonly property int mangoActiveIndex: MangoState.activeIndexFor(myOutput)
    readonly property var mangoOccupiedMap: MangoState.occupiedByOutput
    readonly property int swayActiveIndex: SwayState.activeIndexFor(myOutput)
    readonly property var swayOccupiedMap: SwayState.occupiedMap
    property bool swaySubscribed: false

    property int activeIndex: {
        let idx = -1;
        if (Compositor.name === "niri") {
            idx = niriActiveIndex;
        } else if (Compositor.name === "sway") {
            idx = swayActiveIndex;
        } else if (Compositor.name === "mango") {
            idx = mangoActiveIndex;
        } else if (Compositor.name === "hyprland" || typeof Hyprland !== "undefined") {
            const mon = (typeof Hyprland !== "undefined" && Hyprland.monitors && Hyprland.monitors.values) ? Hyprland.monitors.values.find(m => m.name === myOutput) : null;
            const ws = (mon && mon.activeWorkspace) ? mon.activeWorkspace : ((typeof Hyprland !== "undefined") ? Hyprland.focusedWorkspace : null);
            if (!ws) return -1;
            idx = ws.id - 1;
        }
        return idx >= 0 ? idx : -1;
    }

    readonly property var hyprMonitor: (typeof Hyprland !== "undefined" && Hyprland.monitors && Hyprland.monitors.values) ? (Hyprland.monitors.values.find(m => m.name === myOutput) ?? null) : null
    // Name of the special workspace shown on this monitor ("" when none).
    // Hyprland never reports it as the monitor's activeWorkspace.
    property string hyprSpecialName: ""

    function _syncHyprSpecial() {
        const sp = (hyprMonitor && hyprMonitor.lastIpcObject) ? hyprMonitor.lastIpcObject.specialWorkspace : null;
        dockWindow.hyprSpecialName = (sp && sp.name) ? sp.name : "";
    }

    readonly property var hyprSpecialWorkspace: (hyprSpecialName !== "" && typeof Hyprland !== "undefined" && Hyprland.workspaces && Hyprland.workspaces.values) ? (Hyprland.workspaces.values.find(w => w.name === hyprSpecialName) ?? null) : null

    onHyprMonitorChanged: _syncHyprSpecial()

    Connections {
        target: dockWindow.hyprMonitor
        function onLastIpcObjectChanged() { dockWindow._syncHyprSpecial(); }
    }

    Connections {
        target: (typeof Hyprland !== "undefined") ? Hyprland : null
        function onRawEvent(event) {
            // activespecial>>WORKSPACENAME,MONITORNAME (empty name when it closes)
            if (event.name !== "activespecial") return;
            const data = event.data || "";
            const sep = data.lastIndexOf(",");
            if (sep < 0 || data.substring(sep + 1) !== dockWindow.myOutput) return;
            dockWindow.hyprSpecialName = data.substring(0, sep);
        }
    }

    readonly property bool isWorkspaceBusy: {
        if (Compositor.name === "niri") {
            return !!niriOccupiedMap[activeIndex];
        }
        if (Compositor.name === "sway") {
            return !!swayOccupiedMap[activeIndex];
        }
        if (Compositor.name === "mango") {
            return !!(mangoOccupiedMap && MangoState.isOccupied(myOutput, activeIndex));
        }
        if (typeof Hyprland !== "undefined") {
            if (hyprSpecialWorkspace && hyprSpecialWorkspace.toplevels && hyprSpecialWorkspace.toplevels.values.length > 0) {
                return true;
            }
            let ws = null;
            if (dockWindow.screen && Hyprland.monitors && Hyprland.monitors.values) {
                let mon = Hyprland.monitors.values.find(m => m.name === dockWindow.screen.name);
                if (mon && mon.activeWorkspace) {
                    ws = mon.activeWorkspace;
                }
            }
            if (!ws && Hyprland.focusedWorkspace) {
                ws = Hyprland.focusedWorkspace;
            }
            if (!ws && activeIndex >= 0 && Hyprland.workspaces && Hyprland.workspaces.values) {
                ws = Hyprland.workspaces.values.find(w => w.id === activeIndex + 1) ?? null;
            }
            if (ws) {
                if (ws.toplevels && ws.toplevels.values) {
                    return ws.toplevels.values.length > 0;
                }
                if (ws.windows !== undefined) {
                    return ws.windows > 0;
                }
            }
        }
        return false;
    }

    property bool autohide: rawDockSettings.autohide !== undefined ? rawDockSettings.autohide : false
    readonly property bool effectiveAutohide: smartAutohide ? isWorkspaceBusy : autohide


    property real dockHoverScaleMultiplier: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverScale !== undefined) {
            val = rawDockSettings.hoverScale;
        } else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverScale"] !== undefined) {
            val = Config.rawSettings["dock.hoverScale"];
        }
        let parsed = parseFloat(val);
        if (isNaN(parsed) || parsed < 100) return 1.20;
        return parsed / 100.0;
    }

    property bool dockCascadeScale: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.cascadeScale !== undefined) {
            val = rawDockSettings.cascadeScale;
        } else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.cascadeScale"] !== undefined) {
            val = Config.rawSettings["dock.cascadeScale"];
        }
        if (val === undefined || val === null) return false;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property bool dockHoverBulge: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverBulge !== undefined) val = rawDockSettings.hoverBulge;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverBulge"] !== undefined) val = Config.rawSettings["dock.hoverBulge"];
        if (val === undefined || val === null) return true;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property int dockHoverBulgeHeight: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverBulgeHeight !== undefined) val = rawDockSettings.hoverBulgeHeight;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverBulgeHeight"] !== undefined) val = Config.rawSettings["dock.hoverBulgeHeight"];
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 0) ? parsed : 12;
    }

    property int dockHoverBulgeWidth: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverBulgeWidth !== undefined) val = rawDockSettings.hoverBulgeWidth;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverBulgeWidth"] !== undefined) val = Config.rawSettings["dock.hoverBulgeWidth"];
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 40) ? parsed : 140;
    }

    property int dockHoverBulgeSmoothness: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverBulgeSmoothness !== undefined) val = rawDockSettings.hoverBulgeSmoothness;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverBulgeSmoothness"] !== undefined) val = Config.rawSettings["dock.hoverBulgeSmoothness"];
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 0) ? parsed : 18;
    }

    property bool dockHoverStretchEdges: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverStretchEdges !== undefined) val = rawDockSettings.hoverStretchEdges;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverStretchEdges"] !== undefined) val = Config.rawSettings["dock.hoverStretchEdges"];
        if (val === undefined || val === null) return true;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property string dockHoverEffectMode: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverEffectMode !== undefined) val = rawDockSettings.hoverEffectMode;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverEffectMode"] !== undefined) val = Config.rawSettings["dock.hoverEffectMode"];
        if (typeof val === "string" && (val === "parabolic" || val === "wave" || val === "spring" || val === "flat")) return val;
        return "parabolic";
    }

    property int dockCascadeRadius: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.cascadeRadius !== undefined) val = rawDockSettings.cascadeRadius;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.cascadeRadius"] !== undefined) val = Config.rawSettings["dock.cascadeRadius"];
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 1 && parsed <= 5) ? parsed : 2;
    }

    property int dockHoverLift: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverLift !== undefined) val = rawDockSettings.hoverLift;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverLift"] !== undefined) val = Config.rawSettings["dock.hoverLift"];
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 0 && parsed <= 30) ? parsed : 5;
    }

    property int dockHoverSpread: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverSpread !== undefined) val = rawDockSettings.hoverSpread;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverSpread"] !== undefined) val = Config.rawSettings["dock.hoverSpread"];
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 0 && parsed <= 30) ? parsed : 10;
    }

    property int dockHoverAnimDuration: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverAnimDuration !== undefined) val = rawDockSettings.hoverAnimDuration;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverAnimDuration"] !== undefined) val = Config.rawSettings["dock.hoverAnimDuration"];
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 60 && parsed <= 600) ? parsed : 220;
    }

    property bool dockHoverTilt: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverTilt !== undefined) val = rawDockSettings.hoverTilt;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverTilt"] !== undefined) val = Config.rawSettings["dock.hoverTilt"];
        if (val === undefined || val === null) return false;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property bool dockHoverGlow: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.hoverGlow !== undefined) val = rawDockSettings.hoverGlow;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.hoverGlow"] !== undefined) val = Config.rawSettings["dock.hoverGlow"];
        if (val === undefined || val === null) return false;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property bool dockLaunchBounce: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.launchBounce !== undefined) val = rawDockSettings.launchBounce;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.launchBounce"] !== undefined) val = Config.rawSettings["dock.launchBounce"];
        if (val === undefined || val === null) return true;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property int notifRevision: 0

    Connections {
        target: (typeof NotificationManager !== "undefined" && NotificationManager.groupedHistory) ? NotificationManager.groupedHistory : null
        ignoreUnknownSignals: true
        function onCountChanged() { dockWindow.notifRevision++; }
        function onDataChanged() { dockWindow.notifRevision++; }
        function onRowsInserted() { dockWindow.notifRevision++; }
        function onRowsRemoved() { dockWindow.notifRevision++; }
    }

    function _normAppKey(val) {
        if (!val) return "";
        return String(val).toLowerCase().replace(/\.desktop$/i, "").replace(/[^a-z0-9]/g, "");
    }

    function getUnreadNotifCount(desktopId, appName) {
        let _rev = dockWindow.notifRevision;
        if (!dockShowNotifBadges) return 0;
        if (typeof NotificationManager === "undefined" || !NotificationManager.groupedHistory) return 0;
        let k1 = _normAppKey(desktopId);
        let k2 = _normAppKey(appName);
        if (!k1 && !k2) return 0;
        let total = 0;
        let gh = NotificationManager.groupedHistory;
        for (let i = 0; i < gh.count; i++) {
            let entry = gh.get(i);
            if (!entry || !(entry.unreadCount > 0)) continue;
            let gk = _normAppKey(entry.groupKey);
            let dn = _normAppKey(entry.displayName);
            if ((k1 && (gk === k1 || dn === k1 || gk.indexOf(k1) !== -1 || k1.indexOf(gk) !== -1)) ||
                (k2 && (gk === k2 || dn === k2 || dn.indexOf(k2) !== -1 || k2.indexOf(dn) !== -1))) {
                total += entry.unreadCount;
            }
        }
        return total;
    }

    property int dockPadding: {
        let val = (rawDockSettings && rawDockSettings.dockPadding !== undefined) ? rawDockSettings.dockPadding : undefined;
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 2 && parsed <= 32) ? parsed : 8;
    }

    property int dockItemSpacing: {
        let val = (rawDockSettings && rawDockSettings.itemSpacing !== undefined) ? rawDockSettings.itemSpacing : undefined;
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 0 && parsed <= 28) ? parsed : 8;
    }

    property int dockIconRadius: {
        let val = (rawDockSettings && rawDockSettings.iconRadius !== undefined) ? rawDockSettings.iconRadius : undefined;
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= 0 && parsed <= 50) ? parsed : 28;
    }

    property int dockCornerRadius: {
        let val = (rawDockSettings && rawDockSettings.dockCornerRadius !== undefined) ? rawDockSettings.dockCornerRadius : undefined;
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= -1 && parsed <= 48) ? parsed : -1;
    }

    property int dockCustomOpacity: {
        let val = (rawDockSettings && rawDockSettings.dockOpacity !== undefined) ? rawDockSettings.dockOpacity : undefined;
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed >= -1 && parsed <= 100) ? parsed : -1;
    }

    property bool dockShowNotifBadges: {
        let val = (rawDockSettings && rawDockSettings.showNotifBadges !== undefined) ? rawDockSettings.showNotifBadges : undefined;
        if (val === undefined || val === null) return true;
        return Boolean(val);
    }

    property string dockNotifBadgeStyle: {
        let val = (rawDockSettings && rawDockSettings.notifBadgeStyle) ? String(rawDockSettings.notifBadgeStyle) : "count";
        return (val === "dot") ? "dot" : "count";
    }

    property string dockNotifBadgeColor: {
        let val = (rawDockSettings && rawDockSettings.notifBadgeColor) ? String(rawDockSettings.notifBadgeColor) : "red";
        return (val === "accent") ? "accent" : "red";
    }

    property bool focusRunning: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.focusRunning !== undefined) val = rawDockSettings.focusRunning;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.focusRunning"] !== undefined) val = Config.rawSettings["dock.focusRunning"];
        if (val === undefined || val === null) return true;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property bool showRunningIndicators: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.showRunningIndicators !== undefined) val = rawDockSettings.showRunningIndicators;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.showRunningIndicators"] !== undefined) val = Config.rawSettings["dock.showRunningIndicators"];
        if (val === undefined || val === null) return true;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property bool showRunningApps: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.showRunningApps !== undefined) val = rawDockSettings.showRunningApps;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.showRunningApps"] !== undefined) val = Config.rawSettings["dock.showRunningApps"];
        if (val === undefined || val === null) return true;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        return Boolean(val);
    }

    property string runningScopeSetting: {
        let val = undefined;
        if (rawDockSettings && rawDockSettings.runningScope !== undefined) val = rawDockSettings.runningScope;
        else if (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings["dock.runningScope"] !== undefined) val = Config.rawSettings["dock.runningScope"];
        return (typeof val === "string" && val !== "") ? val : "auto";
    }

    readonly property string effectiveRunningScope: {
        if (runningScopeSetting === "auto") {
            return "all";
        }
        return runningScopeSetting;
    }

    property bool enableScrolling: {
        let val = undefined;
        if (rawDockSettings) {
            val = rawDockSettings.enableScrolling !== undefined ? rawDockSettings.enableScrolling :
                  (rawDockSettings.scrollingEnabled !== undefined ? rawDockSettings.scrollingEnabled :
                  (rawDockSettings.scrollEnabled !== undefined ? rawDockSettings.scrollEnabled :
                  (rawDockSettings.scrolling !== undefined ? rawDockSettings.scrolling : undefined)));
        }
        if (val === undefined && typeof Config !== "undefined" && Config.rawSettings) {
            val = Config.rawSettings["dock.enableScrolling"] !== undefined ? Config.rawSettings["dock.enableScrolling"] :
                  (Config.rawSettings["dock.scrollingEnabled"] !== undefined ? Config.rawSettings["dock.scrollingEnabled"] :
                  (Config.rawSettings["enableScrolling"] !== undefined ? Config.rawSettings["enableScrolling"] : undefined));
        }
        if (val === undefined || val === null) return false;
        if (typeof val === "boolean") return val;
        if (typeof val === "string") return val.toLowerCase() === "true" || val === "1";
        if (typeof val === "number") return val !== 0;
        return Boolean(val);
    }

    property int dockVisibleElements: {
        let val = undefined;
        if (rawDockSettings) {
            val = rawDockSettings.visibleElements !== undefined ? rawDockSettings.visibleElements :
                  (rawDockSettings.scrollingElements !== undefined ? rawDockSettings.scrollingElements :
                  (rawDockSettings.maxVisibleElements !== undefined ? rawDockSettings.maxVisibleElements :
                  (rawDockSettings.maxElements !== undefined ? rawDockSettings.maxElements :
                  (rawDockSettings.visibleItems !== undefined ? rawDockSettings.visibleItems :
                  (rawDockSettings.scrollElements !== undefined ? rawDockSettings.scrollElements :
                  (rawDockSettings.scrollingLimit !== undefined ? rawDockSettings.scrollingLimit :
                  (rawDockSettings.scrollingItemCount !== undefined ? rawDockSettings.scrollingItemCount :
                  (rawDockSettings.itemCount !== undefined ? rawDockSettings.itemCount : undefined))))))));
        }
        if (val === undefined && typeof Config !== "undefined" && Config.rawSettings) {
            val = Config.rawSettings["dock.visibleElements"] !== undefined ? Config.rawSettings["dock.visibleElements"] :
                  (Config.rawSettings["dock.scrollingElements"] !== undefined ? Config.rawSettings["dock.scrollingElements"] :
                  (Config.rawSettings["visibleElements"] !== undefined ? Config.rawSettings["visibleElements"] : undefined));
        }
        let parsed = parseInt(val);
        return (!isNaN(parsed) && parsed > 0) ? parsed : 7;
    }

    property var rawBarSettings: {
        let dummy = configRevision;
        return (typeof Config !== "undefined" && Config.rawSettings && Config.rawSettings.bar) ? Config.rawSettings.bar : ({});
    }

    property string barPosition: (rawBarSettings && rawBarSettings.position !== undefined) ? rawBarSettings.position : "top"
    property bool barAutohide: (rawBarSettings && rawBarSettings.autohide !== undefined) ? Boolean(rawBarSettings.autohide) : false
    property real barHeight: (rawBarSettings && rawBarSettings.height !== undefined) ? s(rawBarSettings.height) : s(40)

    property string barStyle: {
        let dummy = configRevision;
        if (typeof Config === "undefined" || !Config.rawSettings || !Config.rawSettings.bar) return "modular";
        let s = Config.rawSettings.bar.style;
        if (typeof s === "string") return s;
        if (s && typeof s === "object") {
            if (s.fill || s.mode === "fill") return "fill";
            if (s.solid || s.mode === "solid") return "solid";
        }
        return "modular";
    }
    readonly property bool isBarSolid: barStyle === "solid" || barStyle === "fill"

    readonly property bool isOsdFullscreen: (typeof OsdController !== "undefined") ? Boolean(OsdController.isFullscreen) : false
    readonly property bool isToplevelFullscreen: {
        try {
            if (typeof ToplevelManager !== "undefined" && ToplevelManager.activeToplevel && ToplevelManager.activeToplevel.fullscreen) {
                let atl = ToplevelManager.activeToplevel;
                if (atl.screens && atl.screens.length > 0) {
                    return atl.screens.indexOf(dockWindow.screen) !== -1;
                }
                return true;
            }
        } catch (e) {}
        return false;
    }
    // Fullscreen on the workspaces shown on this dock's monitor, not on the focused one.
    readonly property bool isHyprlandFullscreen: {
        if (!hyprMonitor) return false;
        if (hyprMonitor.activeWorkspace && hyprMonitor.activeWorkspace.hasFullscreen) return true;
        return Boolean(hyprSpecialWorkspace && hyprSpecialWorkspace.hasFullscreen);
    }
    // OsdController.isFullscreen is shared by every screen, so on Hyprland the per-monitor check replaces it.
    readonly property bool isFullscreenActive: hyprMonitor ? (isHyprlandFullscreen || isToplevelFullscreen) : (isOsdFullscreen || isToplevelFullscreen)

    readonly property bool isBarEffectivelyHidden: barAutohide || isFullscreenActive
    readonly property bool sameSideAsBar: (dockPosition === barPosition) && !isBarEffectivelyHidden
    readonly property real barMarginOffset: (!isBarSolid && !barAutohide) ? s(4) : 0
    readonly property real barOffset: sameSideAsBar ? (barHeight + barMarginOffset) : 0

    readonly property bool isVertical: dockPosition === "left" || dockPosition === "right"

    function s(val) {
        return (typeof Scaler !== "undefined" && Scaler.s) ? Scaler.s(val) : val;
    }

    property real cornerRadius: ThemeBackend.borderRadius <= 16 ? ThemeBackend.borderRadius * 2 : Math.min(32, 32 - 16 * Math.exp(-(ThemeBackend.borderRadius - 16) / 12))
    property real outerCornerRadius: cornerRadius
}
