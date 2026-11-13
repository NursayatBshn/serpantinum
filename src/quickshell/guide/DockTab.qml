import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../"
import "../reusables"
import "../reusables/guide"

GuideTab {
    id: dockTabRoot
    deferredStages: 4

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
        "showRunningApps": true,
        "runningScope": "auto"
    })

    property var dockSettings: {
        let s = (typeof Config !== "undefined" && Config.rawSettings) ? Config.rawSettings["dock"] : undefined;
        if (s !== undefined && s !== null) return s;
        if (typeof Config !== "undefined" && typeof Config.getSetting === "function") {
            return Config.getSetting("dock", dockTabRoot.defaultDockSettings);
        }
        return dockTabRoot.defaultDockSettings;
    }

    property bool currentEnabled: dockSettings && dockSettings.enabled !== undefined ? dockSettings.enabled : true
    property string currentPosition: dockSettings && dockSettings.position !== undefined ? dockSettings.position : "bottom"
    property bool currentOnTop: dockSettings && dockSettings.onTop !== undefined ? Boolean(dockSettings.onTop) : true
    property bool currentBackground: dockSettings && dockSettings.background !== undefined ? Boolean(dockSettings.background) : true
    property bool currentFloating: dockSettings && dockSettings.floating !== undefined ? dockSettings.floating : false
    property bool currentExclusive: dockSettings && (dockSettings.exclusive !== undefined ? dockSettings.exclusive : (dockSettings.exclusiveMode !== undefined ? dockSettings.exclusiveMode : false)) ? true : false
    property int currentElementSize: (dockSettings && dockSettings.elementSize !== undefined && !isNaN(parseInt(dockSettings.elementSize))) ? parseInt(dockSettings.elementSize) : 44
    property bool currentOverrideBoundsCorrection: dockSettings && dockSettings.overrideBoundsCorrection !== undefined ? dockSettings.overrideBoundsCorrection : false
    property int currentHoverScale: (dockSettings && dockSettings.hoverScale !== undefined && !isNaN(parseInt(dockSettings.hoverScale))) ? parseInt(dockSettings.hoverScale) : 120
    property bool currentCascadeScale: dockSettings && dockSettings.cascadeScale !== undefined ? Boolean(dockSettings.cascadeScale) : false
    property bool currentHoverBulge: dockSettings && dockSettings.hoverBulge !== undefined ? Boolean(dockSettings.hoverBulge) : true
    property int currentHoverBulgeHeight: (dockSettings && dockSettings.hoverBulgeHeight !== undefined && !isNaN(parseInt(dockSettings.hoverBulgeHeight))) ? parseInt(dockSettings.hoverBulgeHeight) : 12
    property int currentHoverBulgeWidth: (dockSettings && dockSettings.hoverBulgeWidth !== undefined && !isNaN(parseInt(dockSettings.hoverBulgeWidth))) ? parseInt(dockSettings.hoverBulgeWidth) : 140
    property int currentHoverBulgeSmoothness: (dockSettings && dockSettings.hoverBulgeSmoothness !== undefined && !isNaN(parseInt(dockSettings.hoverBulgeSmoothness))) ? parseInt(dockSettings.hoverBulgeSmoothness) : 18
    property bool currentHoverStretchEdges: dockSettings && dockSettings.hoverStretchEdges !== undefined ? Boolean(dockSettings.hoverStretchEdges) : true
    property string currentHoverEffectMode: (dockSettings && dockSettings.hoverEffectMode) ? String(dockSettings.hoverEffectMode) : "parabolic"
    property int currentCascadeRadius: (dockSettings && dockSettings.cascadeRadius !== undefined && !isNaN(parseInt(dockSettings.cascadeRadius))) ? parseInt(dockSettings.cascadeRadius) : 2
    property int currentHoverLift: (dockSettings && dockSettings.hoverLift !== undefined && !isNaN(parseInt(dockSettings.hoverLift))) ? parseInt(dockSettings.hoverLift) : 5
    property int currentHoverSpread: (dockSettings && dockSettings.hoverSpread !== undefined && !isNaN(parseInt(dockSettings.hoverSpread))) ? parseInt(dockSettings.hoverSpread) : 10
    property int currentHoverAnimDuration: (dockSettings && dockSettings.hoverAnimDuration !== undefined && !isNaN(parseInt(dockSettings.hoverAnimDuration))) ? parseInt(dockSettings.hoverAnimDuration) : 220
    property bool currentHoverTilt: dockSettings && dockSettings.hoverTilt !== undefined ? Boolean(dockSettings.hoverTilt) : false
    property bool currentHoverGlow: dockSettings && dockSettings.hoverGlow !== undefined ? Boolean(dockSettings.hoverGlow) : false
    property bool currentLaunchBounce: dockSettings && dockSettings.launchBounce !== undefined ? Boolean(dockSettings.launchBounce) : true
    property int currentDockPadding: (dockSettings && dockSettings.dockPadding !== undefined && !isNaN(parseInt(dockSettings.dockPadding))) ? parseInt(dockSettings.dockPadding) : 8
    property int currentItemSpacing: (dockSettings && dockSettings.itemSpacing !== undefined && !isNaN(parseInt(dockSettings.itemSpacing))) ? parseInt(dockSettings.itemSpacing) : 8
    property int currentIconRadius: (dockSettings && dockSettings.iconRadius !== undefined && !isNaN(parseInt(dockSettings.iconRadius))) ? parseInt(dockSettings.iconRadius) : 28
    property int currentDockCornerRadius: (dockSettings && dockSettings.dockCornerRadius !== undefined && !isNaN(parseInt(dockSettings.dockCornerRadius))) ? parseInt(dockSettings.dockCornerRadius) : -1
    property int currentDockOpacity: (dockSettings && dockSettings.dockOpacity !== undefined && !isNaN(parseInt(dockSettings.dockOpacity))) ? parseInt(dockSettings.dockOpacity) : -1
    property bool currentShowNotifBadges: dockSettings && dockSettings.showNotifBadges !== undefined ? Boolean(dockSettings.showNotifBadges) : true
    property string currentNotifBadgeStyle: (dockSettings && dockSettings.notifBadgeStyle) ? String(dockSettings.notifBadgeStyle) : "count"
    property string currentNotifBadgeColor: (dockSettings && dockSettings.notifBadgeColor) ? String(dockSettings.notifBadgeColor) : "red"
    property bool currentEnableScrolling: dockSettings && dockSettings.enableScrolling !== undefined ? dockSettings.enableScrolling : false
    property int currentVisibleElements: (dockSettings && dockSettings.visibleElements !== undefined && !isNaN(parseInt(dockSettings.visibleElements)) && parseInt(dockSettings.visibleElements) > 0) ? parseInt(dockSettings.visibleElements) : 7
    property bool currentSmartAutohide: dockSettings && dockSettings.smartAutohide !== undefined ? dockSettings.smartAutohide : true
    property bool currentAutohide: dockSettings && dockSettings.autohide !== undefined ? dockSettings.autohide : false
    property int currentAutohideTimeout: (dockSettings && dockSettings.autohideTimeout !== undefined && !isNaN(parseInt(dockSettings.autohideTimeout))) ? parseInt(dockSettings.autohideTimeout) : 1000
    property bool currentEditing: dockSettings && dockSettings.editing !== undefined ? dockSettings.editing : false
    property var currentAppsList: (dockSettings && Array.isArray(dockSettings.apps)) ? dockSettings.apps : []
    property bool currentFocusRunning: dockSettings && dockSettings.focusRunning !== undefined ? Boolean(dockSettings.focusRunning) : true
    property bool currentShowRunningIndicators: dockSettings && dockSettings.showRunningIndicators !== undefined ? Boolean(dockSettings.showRunningIndicators) : true
    property bool currentShowRunningApps: dockSettings && dockSettings.showRunningApps !== undefined ? Boolean(dockSettings.showRunningApps) : false
    property string currentRunningScope: (dockSettings && dockSettings.runningScope) ? dockSettings.runningScope : "auto"

    function syncSettings() {
        let s = (typeof Config !== "undefined" && typeof Config.getSetting === "function")
            ? Config.getSetting("dock", dockTabRoot.defaultDockSettings)
            : dockTabRoot.defaultDockSettings;
        dockTabRoot.dockSettings = s;
        dockTabRoot.currentEnabled = s.enabled !== undefined ? s.enabled : true;
        dockTabRoot.currentPosition = s.position !== undefined ? s.position : "bottom";
        dockTabRoot.currentOnTop = s.onTop !== undefined ? Boolean(s.onTop) : true;
        dockTabRoot.currentBackground = s.background !== undefined ? Boolean(s.background) : true;
        dockTabRoot.currentFloating = s.floating !== undefined ? s.floating : false;
        dockTabRoot.currentExclusive = s.exclusive !== undefined ? s.exclusive : (s.exclusiveMode !== undefined ? Boolean(s.exclusiveMode) : false);
        dockTabRoot.currentElementSize = (s.elementSize !== undefined && !isNaN(parseInt(s.elementSize))) ? parseInt(s.elementSize) : 44;
        dockTabRoot.currentOverrideBoundsCorrection = s.overrideBoundsCorrection !== undefined ? s.overrideBoundsCorrection : false;
        dockTabRoot.currentHoverScale = (s.hoverScale !== undefined && !isNaN(parseInt(s.hoverScale))) ? parseInt(s.hoverScale) : 120;
        dockTabRoot.currentCascadeScale = s.cascadeScale !== undefined ? Boolean(s.cascadeScale) : false;
        dockTabRoot.currentHoverBulge = s.hoverBulge !== undefined ? Boolean(s.hoverBulge) : true;
        dockTabRoot.currentHoverBulgeHeight = (s.hoverBulgeHeight !== undefined && !isNaN(parseInt(s.hoverBulgeHeight))) ? parseInt(s.hoverBulgeHeight) : 12;
        dockTabRoot.currentHoverBulgeWidth = (s.hoverBulgeWidth !== undefined && !isNaN(parseInt(s.hoverBulgeWidth))) ? parseInt(s.hoverBulgeWidth) : 140;
        dockTabRoot.currentHoverBulgeSmoothness = (s.hoverBulgeSmoothness !== undefined && !isNaN(parseInt(s.hoverBulgeSmoothness))) ? parseInt(s.hoverBulgeSmoothness) : 18;
        dockTabRoot.currentHoverStretchEdges = s.hoverStretchEdges !== undefined ? Boolean(s.hoverStretchEdges) : true;
        dockTabRoot.currentHoverEffectMode = (s.hoverEffectMode) ? String(s.hoverEffectMode) : "parabolic";
        dockTabRoot.currentCascadeRadius = (s.cascadeRadius !== undefined && !isNaN(parseInt(s.cascadeRadius))) ? parseInt(s.cascadeRadius) : 2;
        dockTabRoot.currentHoverLift = (s.hoverLift !== undefined && !isNaN(parseInt(s.hoverLift))) ? parseInt(s.hoverLift) : 5;
        dockTabRoot.currentHoverSpread = (s.hoverSpread !== undefined && !isNaN(parseInt(s.hoverSpread))) ? parseInt(s.hoverSpread) : 10;
        dockTabRoot.currentHoverAnimDuration = (s.hoverAnimDuration !== undefined && !isNaN(parseInt(s.hoverAnimDuration))) ? parseInt(s.hoverAnimDuration) : 220;
        dockTabRoot.currentHoverTilt = s.hoverTilt !== undefined ? Boolean(s.hoverTilt) : false;
        dockTabRoot.currentHoverGlow = s.hoverGlow !== undefined ? Boolean(s.hoverGlow) : false;
        dockTabRoot.currentLaunchBounce = s.launchBounce !== undefined ? Boolean(s.launchBounce) : true;
        dockTabRoot.currentDockPadding = (s.dockPadding !== undefined && !isNaN(parseInt(s.dockPadding))) ? parseInt(s.dockPadding) : 8;
        dockTabRoot.currentItemSpacing = (s.itemSpacing !== undefined && !isNaN(parseInt(s.itemSpacing))) ? parseInt(s.itemSpacing) : 8;
        dockTabRoot.currentIconRadius = (s.iconRadius !== undefined && !isNaN(parseInt(s.iconRadius))) ? parseInt(s.iconRadius) : 28;
        dockTabRoot.currentDockCornerRadius = (s.dockCornerRadius !== undefined && !isNaN(parseInt(s.dockCornerRadius))) ? parseInt(s.dockCornerRadius) : -1;
        dockTabRoot.currentDockOpacity = (s.dockOpacity !== undefined && !isNaN(parseInt(s.dockOpacity))) ? parseInt(s.dockOpacity) : -1;
        dockTabRoot.currentShowNotifBadges = s.showNotifBadges !== undefined ? Boolean(s.showNotifBadges) : true;
        dockTabRoot.currentNotifBadgeStyle = s.notifBadgeStyle ? String(s.notifBadgeStyle) : "count";
        dockTabRoot.currentNotifBadgeColor = s.notifBadgeColor ? String(s.notifBadgeColor) : "red";
        dockTabRoot.currentEnableScrolling = s.enableScrolling !== undefined ? s.enableScrolling : false;
        dockTabRoot.currentVisibleElements = (s.visibleElements !== undefined && !isNaN(parseInt(s.visibleElements)) && parseInt(dockSettings.visibleElements) > 0) ? parseInt(s.visibleElements) : 7;
        dockTabRoot.currentSmartAutohide = s.smartAutohide !== undefined ? s.smartAutohide : true;
        dockTabRoot.currentAutohide = s.autohide !== undefined ? s.autohide : false;
        dockTabRoot.currentAutohideTimeout = (s.autohideTimeout !== undefined && !isNaN(parseInt(s.autohideTimeout))) ? parseInt(s.autohideTimeout) : 1000;
        dockTabRoot.currentEditing = s.editing !== undefined ? s.editing : false;
        dockTabRoot.currentAppsList = (s.apps && Array.isArray(s.apps)) ? s.apps : [];
        dockTabRoot.currentFocusRunning = s.focusRunning !== undefined ? Boolean(s.focusRunning) : true;
        dockTabRoot.currentShowRunningIndicators = s.showRunningIndicators !== undefined ? Boolean(s.showRunningIndicators) : true;
        dockTabRoot.currentShowRunningApps = s.showRunningApps !== undefined ? Boolean(s.showRunningApps) : false;
        dockTabRoot.currentRunningScope = s.runningScope ? s.runningScope : "auto";
    }

    function updateDockSetting(key, value) {
        let base = (typeof Config !== "undefined" && typeof Config.getSetting === "function")
            ? Config.getSetting("dock", defaultDockSettings)
            : defaultDockSettings;
        let current = JSON.parse(JSON.stringify(base || defaultDockSettings));
        current[key] = value;
        if (typeof Config !== "undefined" && typeof Config.setSetting === "function") {
            Config.setSetting("dock", current);
        }
        dockTabRoot.dockSettings = current;
    }

    function removeApp(idx) {
        let list = dockTabRoot.currentAppsList ? dockTabRoot.currentAppsList.slice() : [];
        if (idx >= 0 && idx < list.length) {
            list.splice(idx, 1);
            dockTabRoot.currentAppsList = list;
            dockTabRoot.updateDockSetting("apps", list);
        }
    }

    Timer {
        id: dockDebounceTimer
        interval: 120
        repeat: false
        property var pendingCallback: null
        onTriggered: {
            if (pendingCallback) {
                pendingCallback();
                pendingCallback = null;
            }
        }
    }

    function triggerDebounced(cb) {
        dockDebounceTimer.pendingCallback = cb;
        dockDebounceTimer.restart();
    }

    onVisibleChanged: {
        if (visible) {
            syncSettings();
        } else {
            if (posDropdown.isOpen) posDropdown.closePopup();
        }
    }

    Component.onCompleted: syncSettings()

    Connections {
        target: typeof Config !== "undefined" ? Config : null
        function onSettingsLoaded() {
            dockTabRoot.syncSettings();
        }
    }

    Flickable {
        id: mainFlickable
        anchors.fill: parent
        anchors.topMargin: rootObj.s(8)
        anchors.leftMargin: rootObj.s(8)
        anchors.rightMargin: rootObj.s(8)
        anchors.bottomMargin: rootObj.s(8)
        contentHeight: settingsCol.implicitHeight + rootObj.s(16)
        contentWidth: width
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar {
            active: parent.moving || parent.movingVertically
            width: rootObj.s(4)
            policy: ScrollBar.AsNeeded
            contentItem: Rectangle {
                implicitWidth: rootObj.s(4)
                radius: rootObj.s(2)
                color: ThemeBackend.surface2
            }
        }

        ColumnLayout {
            id: settingsCol
            width: parent.width - (parent.contentHeight > parent.height ? rootObj.s(6) : 0)
            spacing: rootObj.s(6)

            SettingsRow {
                settingId: "dock_enabled"
                rootObj: dockTabRoot.rootObj
                icon: "󰅀"
                title: I18n.t("guide.dock.enabled.title", "Enable dock")
                description: I18n.t("guide.dock.enabled.desc", "Enable floating application dock")

                Toggle {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    checked: dockTabRoot.currentEnabled
                    accentColor: ThemeBackend.mauve
                    baseColor: ThemeBackend.surface1
                    handleColor: ThemeBackend.crust
                    handleOffColor: ThemeBackend.text
                    onToggled: function(val) {
                        dockTabRoot.currentEnabled = val;
                        dockTabRoot.updateDockSetting("enabled", val);
                    }
                }
            }

            CollapsibleSection {
                open: dockTabRoot.currentEnabled || dockAppsCard.tempVisible
                row: dockAppsCard

                Rectangle {
                    id: dockAppsCard
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    clip: true
                    radius: ThemeBackend.borderRadius
                    readonly property color legacyColor: {
                        let base = Qt.alpha(ThemeBackend.surface0, 0.4);
                        if (highlightFlash > 0.001) {
                            return Qt.tint(base, Qt.rgba(ThemeBackend.mauve.r, ThemeBackend.mauve.g, ThemeBackend.mauve.b, highlightFlash * 0.12));
                        }
                        return base;
                    }
                    color: dockAppsGlass.active ? (highlightFlash > 0.001 ? Qt.alpha(ThemeBackend.mauve, highlightFlash * 0.12) : "transparent") : legacyColor

                    GlassFill {
                        id: dockAppsGlass
                        anchors.fill: parent
                        radius: parent.radius
                        tintColor: ThemeBackend.surface0
                        tintAmount: 0.25
                    }

                    property string settingId: "dock_apps"
                    property string title: I18n.t("guide.dock.apps.title", "Dock Applications")
                    property string description: I18n.t("guide.dock.apps.desc", "Configure and organize applications displayed on the dock")
                    property string icon: "󰀻"
                    property string searchKeywords: "applications shortcuts pins favorites"
                    property bool searchable: true

                    property real highlightFlash: 0.0
                    property int handledHighlightToken: -1
                    property bool tempVisible: false

                    function ensureVisibleInFlickable() {
                        let flick = mainFlickable;
                        if (!flick) return;
                        let targetPos = dockAppsCard.mapToItem(flick.contentItem, 0, 0);
                        if (targetPos) {
                            let viewTop = flick.contentY;
                            let viewBottom = flick.contentY + flick.height;
                            if (targetPos.y < viewTop || targetPos.y + dockAppsCard.height > viewBottom) {
                                flick.contentY = Math.max(0, Math.min(targetPos.y - flick.height / 2 + dockAppsCard.height / 2, flick.contentHeight - flick.height));
                            }
                        }
                    }

                    function triggerHighlightAnimation() {
                        dockAppsHighlightAnim.restart();
                        dockAppsCard.ensureVisibleInFlickable();
                    }

                    function checkHighlight() {
                        let r = dockTabRoot.rootObj;
                        if (!r) return;
                        if (r.highlightToken === dockAppsCard.handledHighlightToken) return;
                        if (r.highlightedSettingId && (r.highlightedSettingId === dockAppsCard.settingId || r.highlightedSettingId === "dock_apps")) {
                            dockAppsCard.handledHighlightToken = r.highlightToken;
                            r.highlightedSettingId = "";
                            if (!dockTabRoot.currentEnabled) {
                                dockAppsCard.tempVisible = true;
                                appsCardCollapseTimer.restart();
                            }
                            dockAppsDelayTimer.restart();
                        }
                    }

                    Connections {
                        target: dockTabRoot.rootObj
                        ignoreUnknownSignals: true
                        function onHighlightTokenChanged() {
                            dockAppsCard.checkHighlight();
                        }
                    }

                    Timer {
                        id: dockAppsDelayTimer
                        interval: 80
                        repeat: false
                        onTriggered: dockAppsCard.triggerHighlightAnimation()
                    }

                    Timer {
                        id: appsCardCollapseTimer
                        interval: 2800
                        repeat: false
                        onTriggered: dockAppsCard.tempVisible = false
                    }

                    SequentialAnimation {
                        id: dockAppsHighlightAnim
                        NumberAnimation { target: dockAppsCard; property: "highlightFlash"; from: 0.0; to: 1.0; duration: 400; easing.type: Easing.OutCubic }
                        PauseAnimation { duration: 1500 }
                        NumberAnimation { target: dockAppsCard; property: "highlightFlash"; from: 1.0; to: 0.0; duration: 900; easing.type: Easing.InOutSine }
                    }

                    function resolveTabInfo() {
                        let r = dockTabRoot.rootObj;
                        let tabKey = "";
                        let subtabKey = "";
                        if (r && r.tabsModel && dockTabRoot.tabIndex >= 0 && dockTabRoot.tabIndex < r.tabsModel.length) {
                            let tModel = r.tabsModel[dockTabRoot.tabIndex];
                            tabKey = tModel.key || tModel.id || "";
                        }
                        return { tab: tabKey, subtab: subtabKey };
                    }

                    function registerWithSearch() {
                        let r = dockTabRoot.rootObj;
                        if (!r || typeof r.registerSearchItem !== "function") return;
                        if (!dockAppsCard.searchable || !dockAppsCard.title || dockAppsCard.title === "") {
                            if (dockAppsCard.settingId !== "") {
                                r.unregisterSearchItem(dockAppsCard.settingId);
                            }
                            return;
                        }
                        let info = dockAppsCard.resolveTabInfo();
                        r.registerSearchItem({
                            id: dockAppsCard.settingId,
                            title: dockAppsCard.title,
                            desc: dockAppsCard.description,
                            tab: info.tab,
                            subtab: info.subtab,
                            icon: dockAppsCard.icon,
                            keywords: dockAppsCard.searchKeywords,
                            target: dockAppsCard
                        });
                    }

                    function unregisterFromSearch() {
                        let r = dockTabRoot.rootObj;
                        if (!r || typeof r.unregisterSearchItem !== "function") return;
                        if (dockAppsCard.settingId !== "") {
                            r.unregisterSearchItem(dockAppsCard.settingId);
                        }
                    }

                    Timer {
                        id: appsSearchRegTimer
                        interval: 10
                        repeat: false
                        onTriggered: dockAppsCard.registerWithSearch()
                    }

                    Component.onCompleted: {
                        appsSearchRegTimer.restart();
                        dockAppsCard.checkHighlight();
                    }
                    Component.onDestruction: dockAppsCard.unregisterFromSearch()

                    onTitleChanged: appsSearchRegTimer.restart()
                    onDescriptionChanged: appsSearchRegTimer.restart()
                    onIconChanged: appsSearchRegTimer.restart()
                    onSearchableChanged: appsSearchRegTimer.restart()
                    onSettingIdChanged: appsSearchRegTimer.restart()

                    implicitHeight: cardLayout.implicitHeight + dockTabRoot.rootObj.s(24)

                    ColumnLayout {
                        id: cardLayout
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: dockTabRoot.rootObj.s(12)
                        spacing: dockTabRoot.rootObj.s(12)

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: dockTabRoot.rootObj.s(10)

                            Text {
                                text: dockAppsCard.title
                                font.family: ThemeBackend.fontFamily
                                font.pixelSize: dockTabRoot.rootObj.s(13)
                                color: ThemeBackend.text
                            }

                            Text {
                                text: "(" + dockTabRoot.currentAppsList.length + " " + (dockTabRoot.currentAppsList.length === 1 ? I18n.t("guide.dock.apps.singular", "app") : I18n.t("guide.dock.apps.plural", "apps")) + ")"
                                font.family: ThemeBackend.fontFamily
                                font.pixelSize: dockTabRoot.rootObj.s(11)
                                color: ThemeBackend.subtext0
                            }

                            Item { Layout.fillWidth: true }

                            ClickButton {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                maxWidth: dockTabRoot.rootObj.s(160)
                                implicitHeight: dockTabRoot.rootObj.s(32)
                                cornerRadius: ThemeBackend.borderRadius
                                buttonText: dockTabRoot.currentEditing ? I18n.t("guide.dock.apps.exit_edit", "Exit edit mode") : I18n.t("guide.dock.apps.enter_edit", "Edit")
                                buttonIcon: dockTabRoot.currentEditing ? "󰅖" : "󰏫"
                                iconFontSize: dockTabRoot.rootObj.s(14)
                                accentColor: dockTabRoot.currentEditing ? ThemeBackend.red : ThemeBackend.mauve
                                textColor: ThemeBackend.crust
                                onClicked: {
                                    dockTabRoot.currentEditing = !dockTabRoot.currentEditing;
                                    dockTabRoot.updateDockSetting("editing", dockTabRoot.currentEditing);
                                    if (typeof Sounds !== "undefined") {
                                        Sounds.playSfx(dockTabRoot.currentEditing ? "guide/barconfig/out.wav" : "guide/barconfig/in.wav");
                                    }
                                    dockTabRoot.rootObj.dismissHost();
                                }
                            }
                        }

                        GridLayout {
                            id: appsGrid
                            Layout.fillWidth: true
                            columns: 3
                            rowSpacing: dockTabRoot.rootObj.s(8)
                            columnSpacing: dockTabRoot.rootObj.s(8)
                            visible: dockTabRoot.currentAppsList.length > 0

                            property real colWidth: Math.max(0, (cardLayout.width - appsGrid.columnSpacing * 2) / 3)

                            Repeater {
                                model: dockTabRoot.currentAppsList
                                delegate: Rectangle {
                                    id: appItemCard
                                    required property var modelData
                                    required property int index

                                    Layout.preferredWidth: appsGrid.colWidth
                                    Layout.maximumWidth: appsGrid.colWidth
                                    Layout.fillWidth: false
                                    Layout.preferredHeight: dockTabRoot.rootObj.s(48)
                                    radius: ThemeBackend.borderRadius
                                    color: appCardGlass1.active ? "transparent" : Qt.alpha(ThemeBackend.surface1, 0.3)

                                    GlassFill {
                                        id: appCardGlass1
                                        anchors.fill: parent
                                        radius: parent.radius
                                        tintColor: Qt.alpha(ThemeBackend.surface1, 0.3)
                                        tintAmount: 0.25
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: dockTabRoot.rootObj.s(8)
                                        anchors.rightMargin: dockTabRoot.rootObj.s(8)
                                        spacing: dockTabRoot.rootObj.s(8)

                                        Rectangle {
                                            id: iconWrapper
                                            implicitWidth: dockTabRoot.rootObj.s(32)
                                            implicitHeight: dockTabRoot.rootObj.s(32)
                                            Layout.alignment: Qt.AlignVCenter
                                            radius: Math.round(dockTabRoot.rootObj.s(32) * 0.28)
                                            color: gf1.active ? "transparent" : ThemeBackend.surface0

                                            GlassFill {
                                                id: gf1
                                                anchors.fill: parent
                                                radius: parent.radius
                                                tintColor: ThemeBackend.surface0
                                                tintAmount: 0.25
                                            }
                                            clip: true

                                            Image {
                                                id: appCardIcon
                                                anchors.fill: parent
                                                anchors.margins: dockTabRoot.rootObj.s(4)
                                                fillMode: Image.PreserveAspectFit
                                                asynchronous: true
                                                smooth: true
                                                mipmap: true
                                                property bool failedLoad: false

                                                visible: source !== "" && status === Image.Ready && !failedLoad

                                                source: {
                                                    let ic = modelData.icon || "";
                                                    if (!ic) return "";
                                                    if (ic.startsWith("file://") || ic.startsWith("image://") || ic.startsWith("http://") || ic.startsWith("https://")) return ic;
                                                    return ic.startsWith("/") ? "file://" + ic : "image://icon/" + ic;
                                                }

                                                onStatusChanged: {
                                                    if (status === Image.Error) failedLoad = true;
                                                }
                                            }

                                            Text {
                                                anchors.centerIn: parent
                                                visible: !appCardIcon.visible
                                                text: modelData.name ? modelData.name.charAt(0).toUpperCase() : "?"
                                                font.family: ThemeBackend.fontFamily
                                                font.pixelSize: dockTabRoot.rootObj.s(13)
                                                font.bold: true
                                                color: ThemeBackend.text
                                            }
                                        }

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignVCenter
                                            spacing: dockTabRoot.rootObj.s(1)

                                            Text {
                                                text: modelData.name || modelData.desktop_id || "App"
                                                font.family: ThemeBackend.fontFamily
                                                font.pixelSize: dockTabRoot.rootObj.s(12)
                                                font.bold: true
                                                color: ThemeBackend.text
                                                elide: Text.ElideRight
                                                Layout.fillWidth: true
                                            }

                                            Text {
                                                text: modelData.comment || modelData.desktop_id || ""
                                                font.family: ThemeBackend.fontFamily
                                                font.pixelSize: dockTabRoot.rootObj.s(10)
                                                color: ThemeBackend.subtext0
                                                elide: Text.ElideRight
                                                Layout.fillWidth: true
                                            }
                                        }

                                        DeleteButton {
                                            size: dockTabRoot.rootObj.s(28)
                                            cornerRadius: Math.min(ThemeBackend.borderRadius, dockTabRoot.rootObj.s(8))
                                            iconFontSize: dockTabRoot.rootObj.s(14)
                                            Layout.alignment: Qt.AlignVCenter
                                            onClicked: {
                                                dockTabRoot.removeApp(index);
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: dockTabRoot.rootObj.s(40)
                            visible: dockTabRoot.currentAppsList.length === 0

                            Text {
                                anchors.centerIn: parent
                                text: I18n.t("guide.dock.apps.empty", "No applications configured for the dock")
                                font.family: ThemeBackend.fontFamily
                                font.pixelSize: dockTabRoot.rootObj.s(12)
                                color: ThemeBackend.subtext0
                            }
                        }
                    }
                }
            }

            SettingsBlob {
                CollapsibleSection {
                    open: dockTabRoot.currentEnabled || positionRow.tempVisible
                    row: positionRow

                    RevealableSettingsRow {
                        id: positionRow
                        settingId: "dock_position"
                        rootObj: dockTabRoot.rootObj
                        icon: "󰍹"
                        title: I18n.t("guide.dock.position.title", "Dock position")
                        description: I18n.t("guide.dock.position.desc", "Select the screen edge to anchor the dock")
                        revealWhenClosed: !dockTabRoot.currentEnabled

                        Dropdown {
                            id: posDropdown
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            implicitWidth: dockTabRoot.rootObj.s(180)
                            implicitHeight: dockTabRoot.rootObj.s(32)
                            options: [
                                I18n.t("guide.dock.position.bottom", "Bottom"),
                                I18n.t("guide.dock.position.top", "Top"),
                                I18n.t("guide.dock.position.left", "Left"),
                                I18n.t("guide.dock.position.right", "Right")
                            ]
                            currentIndex: {
                                if (dockTabRoot.currentPosition === "top") return 1;
                                if (dockTabRoot.currentPosition === "left") return 2;
                                if (dockTabRoot.currentPosition === "right") return 3;
                                return 0;
                            }
                            accentColor: ThemeBackend.mauve
                            baseColor: ThemeBackend.surface0
                            hoverColor: ThemeBackend.surface1
                            dropdownColor: ThemeBackend.surface0
                            borderColor: Qt.alpha(ThemeBackend.surface2, 0.6)
                            textColor: ThemeBackend.text
                            activeTextColor: ThemeBackend.crust
                            fontPixelSize: dockTabRoot.rootObj.s(11)
                            onValueChanged: function(index, value) {
                                let pos = "bottom";
                                if (index === 1) pos = "top";
                                else if (index === 2) pos = "left";
                                else if (index === 3) pos = "right";
                                dockTabRoot.currentPosition = pos;
                                dockTabRoot.updateDockSetting("position", pos);
                            }
                        }
                    }
                }

                CollapsibleSection {
                    open: dockTabRoot.currentEnabled || onTopRow.tempVisible
                    row: onTopRow

                    RevealableSettingsRow {
                        id: onTopRow
                        settingId: "dock_on_top"
                        rootObj: dockTabRoot.rootObj
                        icon: "󰹤"
                        title: I18n.t("guide.dock.on_top.title", "Place dock on top of windows")
                        description: I18n.t("guide.dock.on_top.desc", "Keep the dock visible above application windows")
                        revealWhenClosed: !dockTabRoot.currentEnabled

                        Toggle {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            checked: dockTabRoot.currentOnTop
                            accentColor: ThemeBackend.mauve
                            baseColor: ThemeBackend.surface1
                            handleColor: ThemeBackend.crust
                            handleOffColor: ThemeBackend.text
                            onToggled: function(val) {
                                dockTabRoot.currentOnTop = val;
                                dockTabRoot.updateDockSetting("onTop", val);
                            }
                        }
                    }
                }

                CollapsibleSection {
                    open: dockTabRoot.currentEnabled || floatingRow.tempVisible
                    row: floatingRow

                    RevealableSettingsRow {
                        id: floatingRow
                        settingId: "dock_floating"
                        rootObj: dockTabRoot.rootObj
                        icon: "󰉈"
                        title: I18n.t("guide.dock.floating.title", "Floating dock")
                        description: I18n.t("guide.dock.floating.desc", "Detach dock from screen edge with rounded corners")
                        revealWhenClosed: !dockTabRoot.currentEnabled

                        Toggle {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            checked: dockTabRoot.currentFloating
                            accentColor: ThemeBackend.mauve
                            baseColor: ThemeBackend.surface1
                            handleColor: ThemeBackend.crust
                            handleOffColor: ThemeBackend.text
                            onToggled: function(val) {
                                dockTabRoot.currentFloating = val;
                                dockTabRoot.updateDockSetting("floating", val);
                            }
                        }
                    }
                }

                CollapsibleSection {
                    open: dockTabRoot.currentEnabled || backgroundRow.tempVisible
                    row: backgroundRow

                    RevealableSettingsRow {
                        id: backgroundRow
                        settingId: "dock_background"
                        rootObj: dockTabRoot.rootObj
                        icon: "󰂵"
                        title: I18n.t("guide.dock.background.title", "Draw a background behind apps")
                        description: I18n.t("guide.dock.background.desc", "Show the dock panel behind app icons")
                        revealWhenClosed: !dockTabRoot.currentEnabled

                        Toggle {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            checked: dockTabRoot.currentBackground
                            accentColor: ThemeBackend.mauve
                            baseColor: ThemeBackend.surface1
                            handleColor: ThemeBackend.crust
                            handleOffColor: ThemeBackend.text
                            onToggled: function(val) {
                                dockTabRoot.currentBackground = val;
                                dockTabRoot.updateDockSetting("background", val);
                            }
                        }
                    }
                }

                CollapsibleSection {
                    open: dockTabRoot.currentEnabled || exclusiveRow.tempVisible
                    row: exclusiveRow

                    RevealableSettingsRow {
                        id: exclusiveRow
                        settingId: "dock_exclusive"
                        rootObj: dockTabRoot.rootObj
                        icon: "󰖲"
                        title: I18n.t("guide.dock.exclusive.title", "Exclusive mode")
                        description: I18n.t("guide.dock.exclusive.desc", "Prevent windows from taking space occupied by the dock")
                        revealWhenClosed: !dockTabRoot.currentEnabled

                        Toggle {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            checked: dockTabRoot.currentExclusive
                            accentColor: ThemeBackend.mauve
                            baseColor: ThemeBackend.surface1
                            handleColor: ThemeBackend.crust
                            handleOffColor: ThemeBackend.text
                            onToggled: function(val) {
                                dockTabRoot.currentExclusive = val;
                                dockTabRoot.updateDockSetting("exclusive", val);
                            }
                        }
                    }
                }
            }

            Loader {
                Layout.fillWidth: true
                active: dockTabRoot.deferredStage >= 1
                sourceComponent: SettingsBlob {
                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || elementSizeRow.tempVisible
                        row: elementSizeRow

                        RevealableSettingsRow {
                            id: elementSizeRow
                            settingId: "dock_element_size"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰘖"
                            title: I18n.t("guide.dock.size.title", "Element size")
                            description: I18n.t("guide.dock.size.desc", "Dimensions of individual app buttons in pixels")
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Draggable {
                                id: sizeSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 32
                                to: 72
                                stepSize: 2
                                defaultValue: 44
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " px" }
                                value: dockTabRoot.currentElementSize
                                backgroundColor: ThemeBackend.surface0
                                accentColor: ThemeBackend.mauve
                                handleColor: ThemeBackend.text
                                handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let rounded = Math.round(val);
                                    if (dockTabRoot.currentElementSize !== rounded) {
                                        dockTabRoot.currentElementSize = rounded;
                                        dockTabRoot.triggerDebounced(function() {
                                            dockTabRoot.updateDockSetting("elementSize", rounded);
                                        });
                                    }
                                }
                                onDragFinished: {
                                    dockDebounceTimer.stop();
                                    dockTabRoot.updateDockSetting("elementSize", Math.round(sizeSlider.value));
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || overrideBoundsRow.tempVisible
                        row: overrideBoundsRow

                        RevealableSettingsRow {
                            id: overrideBoundsRow
                            settingId: "dock_override_bounds"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰜤"
                            title: I18n.t("guide.dock.override_bounds.title", "Override out-of-screen-bounds size correction")
                            description: I18n.t("guide.dock.override_bounds.desc", "Keep custom element size even if dock exceeds screen limits")
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentOverrideBoundsCorrection
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentOverrideBoundsCorrection = val;
                                    dockTabRoot.updateDockSetting("overrideBoundsCorrection", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || scrollingGroup.tempVisible
                        row: scrollingGroup

                        SettingsGroup {
                            id: scrollingGroup
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            settingId: "dock_scrolling"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰍽"
                            title: I18n.t("guide.dock.scrolling.title", "Enable element scrolling")
                            description: I18n.t("guide.dock.scrolling.desc", "Limit visible elements and allow mouse wheel or touchpad scrolling")
                            expanded: dockTabRoot.currentEnableScrolling
                            forceOpen: visibleElementsRow.tempVisible

                            property bool tempVisible: false

                            function checkHighlight() {
                                let r = effectiveRootObj;
                                if (!r) return;
                                if (r.highlightToken === handledHighlightToken) return;
                                if (r.highlightedSettingId && (r.highlightedSettingId === effectiveSettingId || r.highlightedSettingId === settingId)) {
                                    handledHighlightToken = r.highlightToken;
                                    r.highlightedSettingId = "";
                                    if (!dockTabRoot.currentEnabled) {
                                        tempVisible = true;
                                        scrollingCollapseTimer.restart();
                                    }
                                    highlightDelayTimer.restart();
                                }
                            }

                            Timer {
                                id: scrollingCollapseTimer
                                interval: 2800
                                repeat: false
                                onTriggered: scrollingGroup.tempVisible = false
                            }

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentEnableScrolling
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentEnableScrolling = val;
                                    dockTabRoot.updateDockSetting("enableScrolling", val);
                                }
                            }

                            subSettings: [
                                RevealableSettingsRow {
                                    id: visibleElementsRow
                                    settingId: "dock_visible_elements"
                                    rootObj: dockTabRoot.rootObj
                                    icon: "󰅫"
                                    title: I18n.t("guide.dock.visible_elements.title", "Visible elements")
                                    description: I18n.t("guide.dock.visible_elements.desc", "Number of dock items visible at the same time")

                                    pinToParent: false
                                    revealWhenClosed: !dockTabRoot.currentEnabled || !dockTabRoot.currentEnableScrolling

                                    NumberSelector {
                                        id: visibleElementsSelector
                                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                        implicitWidth: dockTabRoot.rootObj.s(120)
                                        implicitHeight: dockTabRoot.rootObj.s(32)
                                        from: 1
                                        to: 20
                                        stepSize: 1
                                        decimals: 0
                                        value: dockTabRoot.currentVisibleElements
                                        baseColor: ThemeBackend.surface0
                                        accentColor: ThemeBackend.mauve
                                        buttonColor: ThemeBackend.surface1
                                        buttonTextColor: ThemeBackend.text
                                        textColor: ThemeBackend.text
                                        subTextColor: ThemeBackend.subtext0
                                        borderColor: Qt.alpha(ThemeBackend.surface2, 0.6)
                                        cornerRadius: ThemeBackend.borderRadius
                                        fontFamily: ThemeBackend.fontFamily
                                        fontPixelSize: dockTabRoot.rootObj.s(11)
                                        onValueChanged: {
                                            let v = Math.round(visibleElementsSelector.value);
                                            if (!isNaN(v) && v > 0 && dockTabRoot.currentVisibleElements !== v) {
                                                dockTabRoot.currentVisibleElements = v;
                                                dockTabRoot.updateDockSetting("visibleElements", v);
                                            }
                                        }
                                    }
                                }
                            ]
                        }
                    }
                }
            }

            Loader {
                Layout.fillWidth: true
                active: dockTabRoot.deferredStage >= 2
                sourceComponent: SettingsBlob {
                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || hoverScaleRow.tempVisible
                        row: hoverScaleRow

                        RevealableSettingsRow {
                            id: hoverScaleRow
                            settingId: "dock_hover_scale"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰍔"
                            title: I18n.t("guide.dock.hover_scale.title", "Hover scale effect")
                            description: I18n.t("guide.dock.hover_scale.desc", "Magnification level when hovering over dock items")
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Draggable {
                                id: hoverScaleSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 100
                                to: 160
                                stepSize: 2
                                defaultValue: 120
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + "%" }
                                value: dockTabRoot.currentHoverScale
                                backgroundColor: ThemeBackend.surface0
                                accentColor: ThemeBackend.mauve
                                handleColor: ThemeBackend.text
                                handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let rounded = Math.round(val);
                                    if (dockTabRoot.currentHoverScale !== rounded) {
                                        dockTabRoot.currentHoverScale = rounded;
                                        dockTabRoot.triggerDebounced(function() {
                                            dockTabRoot.updateDockSetting("hoverScale", rounded);
                                        });
                                    }
                                }
                                onDragFinished: {
                                    dockDebounceTimer.stop();
                                    dockTabRoot.updateDockSetting("hoverScale", Math.round(hoverScaleSlider.value));
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || cascadeScaleRow.tempVisible
                        row: cascadeScaleRow

                        RevealableSettingsRow {
                            id: cascadeScaleRow
                            settingId: "dock_cascade_scale"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰘚"
                            title: I18n.t("guide.dock.cascade_scale.title", "Scale nearest elements")
                            description: I18n.t("guide.dock.cascade_scale.desc", "Cascading magnification on neighboring icons")
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentCascadeScale
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentCascadeScale = val;
                                    dockTabRoot.updateDockSetting("cascadeScale", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || hoverBulgeRow.tempVisible
                        row: hoverBulgeRow

                        RevealableSettingsRow {
                            id: hoverBulgeRow
                            settingId: "dock_hover_bulge"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰘖"
                            title: "Выпуклость фона при наведении"
                            description: "Плавный купол над увеличенной иконкой и соседями"
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentHoverBulge
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentHoverBulge = val;
                                    dockTabRoot.updateDockSetting("hoverBulge", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: (dockTabRoot.currentEnabled && dockTabRoot.currentHoverBulge) || hoverBulgeHeightRow.tempVisible
                        row: hoverBulgeHeightRow

                        RevealableSettingsRow {
                            id: hoverBulgeHeightRow
                            settingId: "dock_hover_bulge_height"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰹹"
                            title: "Высота выпуклости"
                            description: "Дополнительный выступ купола над иконкой"
                            revealWhenClosed: !dockTabRoot.currentEnabled || !dockTabRoot.currentHoverBulge

                            Draggable {
                                id: hoverBulgeHeightSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 0
                                to: 36
                                stepSize: 1
                                defaultValue: 12
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " px" }
                                value: dockTabRoot.currentHoverBulgeHeight
                                backgroundColor: ThemeBackend.surface0
                                accentColor: ThemeBackend.mauve
                                handleColor: ThemeBackend.text
                                handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let rounded = Math.round(val);
                                    if (dockTabRoot.currentHoverBulgeHeight !== rounded) {
                                        dockTabRoot.currentHoverBulgeHeight = rounded;
                                        dockTabRoot.triggerDebounced(function() {
                                            dockTabRoot.updateDockSetting("hoverBulgeHeight", rounded);
                                        });
                                    }
                                }
                                onDragFinished: {
                                    dockDebounceTimer.stop();
                                    dockTabRoot.updateDockSetting("hoverBulgeHeight", Math.round(hoverBulgeHeightSlider.value));
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: (dockTabRoot.currentEnabled && dockTabRoot.currentHoverBulge) || hoverBulgeWidthRow.tempVisible
                        row: hoverBulgeWidthRow

                        RevealableSettingsRow {
                            id: hoverBulgeWidthRow
                            settingId: "dock_hover_bulge_width"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰹺"
                            title: "Ширина выпуклости"
                            description: "Охват купола для соседних увеличенных иконок"
                            revealWhenClosed: !dockTabRoot.currentEnabled || !dockTabRoot.currentHoverBulge

                            Draggable {
                                id: hoverBulgeWidthSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 60
                                to: 260
                                stepSize: 4
                                defaultValue: 140
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " px" }
                                value: dockTabRoot.currentHoverBulgeWidth
                                backgroundColor: ThemeBackend.surface0
                                accentColor: ThemeBackend.mauve
                                handleColor: ThemeBackend.text
                                handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let rounded = Math.round(val);
                                    if (dockTabRoot.currentHoverBulgeWidth !== rounded) {
                                        dockTabRoot.currentHoverBulgeWidth = rounded;
                                        dockTabRoot.triggerDebounced(function() {
                                            dockTabRoot.updateDockSetting("hoverBulgeWidth", rounded);
                                        });
                                    }
                                }
                                onDragFinished: {
                                    dockDebounceTimer.stop();
                                    dockTabRoot.updateDockSetting("hoverBulgeWidth", Math.round(hoverBulgeWidthSlider.value));
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: (dockTabRoot.currentEnabled && dockTabRoot.currentHoverBulge) || hoverBulgeSmoothRow.tempVisible
                        row: hoverBulgeSmoothRow

                        RevealableSettingsRow {
                            id: hoverBulgeSmoothRow
                            settingId: "dock_hover_bulge_smoothness"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰕠"
                            title: "Мягкость перехода выпуклости"
                            description: "Радиус плавного перетекания купола в панель дока"
                            revealWhenClosed: !dockTabRoot.currentEnabled || !dockTabRoot.currentHoverBulge

                            Draggable {
                                id: hoverBulgeSmoothSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 4
                                to: 36
                                stepSize: 1
                                defaultValue: 18
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " px" }
                                value: dockTabRoot.currentHoverBulgeSmoothness
                                backgroundColor: ThemeBackend.surface0
                                accentColor: ThemeBackend.mauve
                                handleColor: ThemeBackend.text
                                handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let rounded = Math.round(val);
                                    if (dockTabRoot.currentHoverBulgeSmoothness !== rounded) {
                                        dockTabRoot.currentHoverBulgeSmoothness = rounded;
                                        dockTabRoot.triggerDebounced(function() {
                                            dockTabRoot.updateDockSetting("hoverBulgeSmoothness", rounded);
                                        });
                                    }
                                }
                                onDragFinished: {
                                    dockDebounceTimer.stop();
                                    dockTabRoot.updateDockSetting("hoverBulgeSmoothness", Math.round(hoverBulgeSmoothSlider.value));
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || hoverStretchEdgesRow.tempVisible
                        row: hoverStretchEdgesRow

                        RevealableSettingsRow {
                            id: hoverStretchEdgesRow
                            settingId: "dock_hover_stretch_edges"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰩨"
                            title: "Растягивать края при наведении"
                            description: "Расширяет док по краям под сдвиг и масштаб соседних иконок"
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentHoverStretchEdges
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentHoverStretchEdges = val;
                                    dockTabRoot.updateDockSetting("hoverStretchEdges", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || hoverEffectModeRow.tempVisible
                        row: hoverEffectModeRow

                        RevealableSettingsRow {
                            id: hoverEffectModeRow
                            settingId: "dock_hover_effect_mode"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰔎"
                            title: "Стиль эффекта наведения"
                            description: "Кривая увеличения и анимации (macOS / Latte / Spring / Flat)"
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Dropdown {
                                id: hoverEffectDropdown
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(180)
                                implicitHeight: dockTabRoot.rootObj.s(32)
                                options: ["Парабола (macOS)", "Волна (Latte)", "Пружина (Spring)", "Без зума (Flat)"]
                                currentIndex: {
                                    if (dockTabRoot.currentHoverEffectMode === "wave") return 1;
                                    if (dockTabRoot.currentHoverEffectMode === "spring") return 2;
                                    if (dockTabRoot.currentHoverEffectMode === "flat") return 3;
                                    return 0;
                                }
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface0
                                onSelected: function(idx) {
                                    let mode = "parabolic";
                                    if (idx === 1) mode = "wave";
                                    else if (idx === 2) mode = "spring";
                                    else if (idx === 3) mode = "flat";
                                    dockTabRoot.currentHoverEffectMode = mode;
                                    dockTabRoot.updateDockSetting("hoverEffectMode", mode);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: (dockTabRoot.currentEnabled && dockTabRoot.currentCascadeScale) || cascadeRadiusRow.tempVisible
                        row: cascadeRadiusRow

                        RevealableSettingsRow {
                            id: cascadeRadiusRow
                            settingId: "dock_cascade_radius"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰃀"
                            title: "Радиус волны соседей"
                            description: "Сколько соседних иконок с каждой стороны реагируют на курсор"
                            revealWhenClosed: !dockTabRoot.currentEnabled || !dockTabRoot.currentCascadeScale

                            Draggable {
                                id: cascadeRadiusSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 1
                                to: 5
                                stepSize: 1
                                defaultValue: 2
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " икон." }
                                value: dockTabRoot.currentCascadeRadius
                                backgroundColor: ThemeBackend.surface0
                                accentColor: ThemeBackend.mauve
                                handleColor: ThemeBackend.text
                                handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let rounded = Math.round(val);
                                    if (dockTabRoot.currentCascadeRadius !== rounded) {
                                        dockTabRoot.currentCascadeRadius = rounded;
                                        dockTabRoot.triggerDebounced(function() {
                                            dockTabRoot.updateDockSetting("cascadeRadius", rounded);
                                        });
                                    }
                                }
                                onDragFinished: {
                                    dockDebounceTimer.stop();
                                    dockTabRoot.updateDockSetting("cascadeRadius", Math.round(cascadeRadiusSlider.value));
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || hoverLiftRow.tempVisible
                        row: hoverLiftRow

                        RevealableSettingsRow {
                            id: hoverLiftRow
                            settingId: "dock_hover_lift"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰁝"
                            title: "Подъём иконки при наведении"
                            description: "Смещение иконки от края экрана вверх"
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Draggable {
                                id: hoverLiftSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 0
                                to: 20
                                stepSize: 1
                                defaultValue: 5
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " px" }
                                value: dockTabRoot.currentHoverLift
                                backgroundColor: ThemeBackend.surface0
                                accentColor: ThemeBackend.mauve
                                handleColor: ThemeBackend.text
                                handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let rounded = Math.round(val);
                                    if (dockTabRoot.currentHoverLift !== rounded) {
                                        dockTabRoot.currentHoverLift = rounded;
                                        dockTabRoot.triggerDebounced(function() {
                                            dockTabRoot.updateDockSetting("hoverLift", rounded);
                                        });
                                    }
                                }
                                onDragFinished: {
                                    dockDebounceTimer.stop();
                                    dockTabRoot.updateDockSetting("hoverLift", Math.round(hoverLiftSlider.value));
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || hoverSpreadRow.tempVisible
                        row: hoverSpreadRow

                        RevealableSettingsRow {
                            id: hoverSpreadRow
                            settingId: "dock_hover_spread"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰁌"
                            title: "Разлёт соседних иконок"
                            description: "Насколько сильно соседние иконки расступаются в стороны"
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Draggable {
                                id: hoverSpreadSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 0
                                to: 20
                                stepSize: 1
                                defaultValue: 10
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " px" }
                                value: dockTabRoot.currentHoverSpread
                                backgroundColor: ThemeBackend.surface0
                                accentColor: ThemeBackend.mauve
                                handleColor: ThemeBackend.text
                                handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let rounded = Math.round(val);
                                    if (dockTabRoot.currentHoverSpread !== rounded) {
                                        dockTabRoot.currentHoverSpread = rounded;
                                        dockTabRoot.triggerDebounced(function() {
                                            dockTabRoot.updateDockSetting("hoverSpread", rounded);
                                        });
                                    }
                                }
                                onDragFinished: {
                                    dockDebounceTimer.stop();
                                    dockTabRoot.updateDockSetting("hoverSpread", Math.round(hoverSpreadSlider.value));
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || hoverAnimDurRow.tempVisible
                        row: hoverAnimDurRow

                        RevealableSettingsRow {
                            id: hoverAnimDurRow
                            settingId: "dock_hover_anim_duration"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰓅"
                            title: "Скорость анимации дока"
                            description: "Длительность реакции иконок и выпуклости"
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Draggable {
                                id: hoverAnimDurSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 80
                                to: 450
                                stepSize: 10
                                defaultValue: 220
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " ms" }
                                value: dockTabRoot.currentHoverAnimDuration
                                backgroundColor: ThemeBackend.surface0
                                accentColor: ThemeBackend.mauve
                                handleColor: ThemeBackend.text
                                handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let rounded = Math.round(val);
                                    if (dockTabRoot.currentHoverAnimDuration !== rounded) {
                                        dockTabRoot.currentHoverAnimDuration = rounded;
                                        dockTabRoot.triggerDebounced(function() {
                                            dockTabRoot.updateDockSetting("hoverAnimDuration", rounded);
                                        });
                                    }
                                }
                                onDragFinished: {
                                    dockDebounceTimer.stop();
                                    dockTabRoot.updateDockSetting("hoverAnimDuration", Math.round(hoverAnimDurSlider.value));
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || hoverTiltRow.tempVisible
                        row: hoverTiltRow

                        RevealableSettingsRow {
                            id: hoverTiltRow
                            settingId: "dock_hover_tilt"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰑵"
                            title: "Наклон соседних иконок"
                            description: "Лёгкий 3D-наклон иконок в стороны от курсора"
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentHoverTilt
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentHoverTilt = val;
                                    dockTabRoot.updateDockSetting("hoverTilt", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || hoverGlowRow.tempVisible
                        row: hoverGlowRow

                        RevealableSettingsRow {
                            id: hoverGlowRow
                            settingId: "dock_hover_glow"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰌶"
                            title: "Свечение иконки при наведении"
                            description: "Мягкая акцентная подсветка под активной иконкой"
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentHoverGlow
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentHoverGlow = val;
                                    dockTabRoot.updateDockSetting("hoverGlow", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || launchBounceRow.tempVisible
                        row: launchBounceRow

                        RevealableSettingsRow {
                            id: launchBounceRow
                            settingId: "dock_launch_bounce"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰜷"
                            title: "Прыжок при запуске (Bounce)"
                            description: "Подпрыгивание иконки при клике для запуска приложения"
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentLaunchBounce
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentLaunchBounce = val;
                                    dockTabRoot.updateDockSetting("launchBounce", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || dockPaddingRow.tempVisible
                        row: dockPaddingRow
                        RevealableSettingsRow {
                            id: dockPaddingRow
                            settingId: "dock_padding"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰆟"
                            title: "Отступы внутри дока (Padding)"
                            description: "Внутренние поля фона вокруг иконок"
                            revealWhenClosed: !dockTabRoot.currentEnabled
                            Draggable {
                                id: dockPaddingSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 2; to: 24; stepSize: 1; defaultValue: 8
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " px" }
                                value: dockTabRoot.currentDockPadding
                                backgroundColor: ThemeBackend.surface0; accentColor: ThemeBackend.mauve; handleColor: ThemeBackend.text; handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let r = Math.round(val);
                                    if (dockTabRoot.currentDockPadding !== r) {
                                        dockTabRoot.currentDockPadding = r;
                                        dockTabRoot.triggerDebounced(function() { dockTabRoot.updateDockSetting("dockPadding", r); });
                                    }
                                }
                                onDragFinished: { dockDebounceTimer.stop(); dockTabRoot.updateDockSetting("dockPadding", Math.round(dockPaddingSlider.value)); }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || itemSpacingRow.tempVisible
                        row: itemSpacingRow
                        RevealableSettingsRow {
                            id: itemSpacingRow
                            settingId: "dock_item_spacing"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰹷"
                            title: "Интервал между иконками"
                            description: "Расстояние между элементами дока"
                            revealWhenClosed: !dockTabRoot.currentEnabled
                            Draggable {
                                id: itemSpacingSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 0; to: 24; stepSize: 1; defaultValue: 8
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + " px" }
                                value: dockTabRoot.currentItemSpacing
                                backgroundColor: ThemeBackend.surface0; accentColor: ThemeBackend.mauve; handleColor: ThemeBackend.text; handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let r = Math.round(val);
                                    if (dockTabRoot.currentItemSpacing !== r) {
                                        dockTabRoot.currentItemSpacing = r;
                                        dockTabRoot.triggerDebounced(function() { dockTabRoot.updateDockSetting("itemSpacing", r); });
                                    }
                                }
                                onDragFinished: { dockDebounceTimer.stop(); dockTabRoot.updateDockSetting("itemSpacing", Math.round(itemSpacingSlider.value)); }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || iconRadiusRow.tempVisible
                        row: iconRadiusRow
                        RevealableSettingsRow {
                            id: iconRadiusRow
                            settingId: "dock_icon_radius"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰗘"
                            title: "Скругление плиток иконок"
                            description: "0% — квадрат, 28% — стандарт, 50% — круг"
                            revealWhenClosed: !dockTabRoot.currentEnabled
                            Draggable {
                                id: iconRadiusSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: 0; to: 50; stepSize: 1; defaultValue: 28
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) + "%" }
                                value: dockTabRoot.currentIconRadius
                                backgroundColor: ThemeBackend.surface0; accentColor: ThemeBackend.mauve; handleColor: ThemeBackend.text; handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let r = Math.round(val);
                                    if (dockTabRoot.currentIconRadius !== r) {
                                        dockTabRoot.currentIconRadius = r;
                                        dockTabRoot.triggerDebounced(function() { dockTabRoot.updateDockSetting("iconRadius", r); });
                                    }
                                }
                                onDragFinished: { dockDebounceTimer.stop(); dockTabRoot.updateDockSetting("iconRadius", Math.round(iconRadiusSlider.value)); }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || dockCornerRadiusRow.tempVisible
                        row: dockCornerRadiusRow
                        RevealableSettingsRow {
                            id: dockCornerRadiusRow
                            settingId: "dock_corner_radius"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰗙"
                            title: "Скругление углов дока"
                            description: "-1 = авто из темы, 0–40 px — вручную"
                            revealWhenClosed: !dockTabRoot.currentEnabled
                            Draggable {
                                id: dockCornerRadiusSlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: -1; to: 40; stepSize: 1; defaultValue: -1
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) < 0 ? "Авто" : (Math.round(v) + " px") }
                                value: dockTabRoot.currentDockCornerRadius
                                backgroundColor: ThemeBackend.surface0; accentColor: ThemeBackend.mauve; handleColor: ThemeBackend.text; handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let r = Math.round(val);
                                    if (dockTabRoot.currentDockCornerRadius !== r) {
                                        dockTabRoot.currentDockCornerRadius = r;
                                        dockTabRoot.triggerDebounced(function() { dockTabRoot.updateDockSetting("dockCornerRadius", r); });
                                    }
                                }
                                onDragFinished: { dockDebounceTimer.stop(); dockTabRoot.updateDockSetting("dockCornerRadius", Math.round(dockCornerRadiusSlider.value)); }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || dockOpacityRow.tempVisible
                        row: dockOpacityRow
                        RevealableSettingsRow {
                            id: dockOpacityRow
                            settingId: "dock_opacity"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰂵"
                            title: "Прозрачность фона дока"
                            description: "-1 = авто из темы, 0–100% — вручную"
                            revealWhenClosed: !dockTabRoot.currentEnabled
                            Draggable {
                                id: dockOpacitySlider
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(18)
                                from: -1; to: 100; stepSize: 2; defaultValue: -1
                                showValueBubble: true
                                valueFormatter: function(v) { return Math.round(v) < 0 ? "Авто" : (Math.round(v) + "%") }
                                value: dockTabRoot.currentDockOpacity
                                backgroundColor: ThemeBackend.surface0; accentColor: ThemeBackend.mauve; handleColor: ThemeBackend.text; handleBorderColor: ThemeBackend.mantle
                                onMoved: function(val) {
                                    let r = Math.round(val);
                                    if (dockTabRoot.currentDockOpacity !== r) {
                                        dockTabRoot.currentDockOpacity = r;
                                        dockTabRoot.triggerDebounced(function() { dockTabRoot.updateDockSetting("dockOpacity", r); });
                                    }
                                }
                                onDragFinished: { dockDebounceTimer.stop(); dockTabRoot.updateDockSetting("dockOpacity", Math.round(dockOpacitySlider.value)); }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || showNotifBadgesRow.tempVisible
                        row: showNotifBadgesRow
                        RevealableSettingsRow {
                            id: showNotifBadgesRow
                            settingId: "dock_notif_badges"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰂚"
                            title: "Бейджи уведомлений на иконках"
                            description: "Счётчик непрочитанных уведомлений для приложений"
                            revealWhenClosed: !dockTabRoot.currentEnabled
                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentShowNotifBadges
                                accentColor: ThemeBackend.mauve; baseColor: ThemeBackend.surface1; handleColor: ThemeBackend.crust; handleOffColor: ThemeBackend.text
                                onToggled: function(val) { dockTabRoot.currentShowNotifBadges = val; dockTabRoot.updateDockSetting("showNotifBadges", val); }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: (dockTabRoot.currentEnabled && dockTabRoot.currentShowNotifBadges) || notifBadgeStyleRow.tempVisible
                        row: notifBadgeStyleRow
                        RevealableSettingsRow {
                            id: notifBadgeStyleRow
                            settingId: "dock_notif_badge_style"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰎠"
                            title: "Вид бейджа уведомлений"
                            description: "Число непрочитанных или компактная точка"
                            revealWhenClosed: !dockTabRoot.currentEnabled || !dockTabRoot.currentShowNotifBadges
                            Dropdown {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(180); implicitHeight: dockTabRoot.rootObj.s(32)
                                options: ["Счётчик (1, 2...)", "Точка"]
                                currentIndex: dockTabRoot.currentNotifBadgeStyle === "dot" ? 1 : 0
                                accentColor: ThemeBackend.mauve; baseColor: ThemeBackend.surface0
                                onSelected: function(idx) {
                                    let val = idx === 1 ? "dot" : "count";
                                    dockTabRoot.currentNotifBadgeStyle = val;
                                    dockTabRoot.updateDockSetting("notifBadgeStyle", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: (dockTabRoot.currentEnabled && dockTabRoot.currentShowNotifBadges) || notifBadgeColorRow.tempVisible
                        row: notifBadgeColorRow
                        RevealableSettingsRow {
                            id: notifBadgeColorRow
                            settingId: "dock_notif_badge_color"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰏘"
                            title: "Цвет бейджа уведомлений"
                            description: "Красный (классический) или акцентный цвет темы"
                            revealWhenClosed: !dockTabRoot.currentEnabled || !dockTabRoot.currentShowNotifBadges
                            Dropdown {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(180); implicitHeight: dockTabRoot.rootObj.s(32)
                                options: ["Красный", "Акцент темы"]
                                currentIndex: dockTabRoot.currentNotifBadgeColor === "accent" ? 1 : 0
                                accentColor: ThemeBackend.mauve; baseColor: ThemeBackend.surface0
                                onSelected: function(idx) {
                                    let val = idx === 1 ? "accent" : "red";
                                    dockTabRoot.currentNotifBadgeColor = val;
                                    dockTabRoot.updateDockSetting("notifBadgeColor", val);
                                }
                            }
                        }
                    }

                }
            }

            Loader {
                Layout.fillWidth: true
                active: dockTabRoot.deferredStage >= 3
                sourceComponent: SettingsBlob {
                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || autohideGroup.tempVisible
                        row: autohideGroup

                        SettingsGroup {
                            id: autohideGroup
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            settingId: "dock_autohide"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰘓"
                            title: I18n.t("guide.dock.autohide.title", "Auto-hide")
                            description: I18n.t("guide.dock.autohide.desc", "Hide the dock when not hovering over the screen edge")
                            expanded: dockTabRoot.currentAutohide || dockTabRoot.currentSmartAutohide
                            forceOpen: autohideTimeoutRow.tempVisible

                            property bool tempVisible: false

                            function checkHighlight() {
                                let r = effectiveRootObj;
                                if (!r) return;
                                if (r.highlightToken === handledHighlightToken) return;
                                if (r.highlightedSettingId && (r.highlightedSettingId === effectiveSettingId || r.highlightedSettingId === settingId)) {
                                    handledHighlightToken = r.highlightToken;
                                    r.highlightedSettingId = "";
                                    if (!dockTabRoot.currentEnabled) {
                                        tempVisible = true;
                                        autohideCollapseTimer.restart();
                                    }
                                    highlightDelayTimer.restart();
                                }
                            }

                            Timer {
                                id: autohideCollapseTimer
                                interval: 2800
                                repeat: false
                                onTriggered: autohideGroup.tempVisible = false
                            }

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentAutohide
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentAutohide = val;
                                    dockTabRoot.updateDockSetting("autohide", val);
                                }
                            }

                            subSettings: [
                                RevealableSettingsRow {
                                    id: autohideTimeoutRow
                                    settingId: "dock_autohide_delay"
                                    rootObj: dockTabRoot.rootObj
                                    icon: "󰔛"
                                    title: I18n.t("guide.dock.timeout.title", "Auto-hide delay")
                                    description: I18n.t("guide.dock.timeout.desc", "Duration before hiding after pointer leaves")

                                    pinToParent: false
                                    revealWhenClosed: !dockTabRoot.currentEnabled || (!dockTabRoot.currentAutohide && !dockTabRoot.currentSmartAutohide)

                                    Draggable {
                                        id: timeoutSlider
                                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                        implicitWidth: dockTabRoot.rootObj.s(220)
                                        implicitHeight: dockTabRoot.rootObj.s(18)
                                        from: 250
                                        to: 5000
                                        stepSize: 50
                                        defaultValue: 1000
                                        showValueBubble: true
                                        valueFormatter: function(v) { return Math.round(v) + " ms" }
                                        value: dockTabRoot.currentAutohideTimeout
                                        backgroundColor: ThemeBackend.surface0
                                        accentColor: ThemeBackend.mauve
                                        handleColor: ThemeBackend.text
                                        handleBorderColor: ThemeBackend.mantle
                                        onMoved: function(val) {
                                            let rounded = Math.round(val);
                                            if (dockTabRoot.currentAutohideTimeout !== rounded) {
                                                dockTabRoot.currentAutohideTimeout = rounded;
                                                dockTabRoot.triggerDebounced(function() {
                                                    dockTabRoot.updateDockSetting("autohideTimeout", rounded);
                                                });
                                            }
                                        }
                                        onDragFinished: {
                                            dockDebounceTimer.stop();
                                            dockTabRoot.updateDockSetting("autohideTimeout", Math.round(timeoutSlider.value));
                                        }
                                    }
                                }
                            ]
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || smartAutohideRow.tempVisible
                        row: smartAutohideRow

                        RevealableSettingsRow {
                            id: smartAutohideRow
                            settingId: "dock_smart_autohide"
                            rootObj: dockTabRoot.rootObj
                            icon: "󱂬"
                            title: I18n.t("guide.dock.smart_autohide.title", "Smart auto-hide")
                            description: I18n.t("guide.dock.smart_autohide.desc", "Auto-hide dock only when windows are open, keep visible on desktop")
                            revealWhenClosed: !dockTabRoot.currentEnabled

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentSmartAutohide
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentSmartAutohide = val;
                                    dockTabRoot.updateDockSetting("smartAutohide", val);
                                }
                            }
                        }
                    }
                }
            }

            Loader {
                Layout.fillWidth: true
                active: dockTabRoot.deferredStage >= 4
                sourceComponent: SettingsBlob {
                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || focusRunningRow.tempVisible
                        row: focusRunningRow

                        SettingsRow {
                            id: focusRunningRow
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            settingId: "dock_focus_running"
                            rootObj: dockTabRoot.rootObj
                            icon: "󱂬"
                            title: I18n.t("guide.dock.focus_running.title", "Focus existing window")
                            description: I18n.t("guide.dock.focus_running.desc", "Clicking an app icon activates its open window instead of launching a new instance")

                            property bool tempVisible: false

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentFocusRunning
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentFocusRunning = val;
                                    dockTabRoot.updateDockSetting("focusRunning", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || showIndicatorsRow.tempVisible
                        row: showIndicatorsRow

                        SettingsRow {
                            id: showIndicatorsRow
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            settingId: "dock_show_running_indicators"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰄯"
                            title: I18n.t("guide.dock.show_running_indicators.title", "Running indicators")
                            description: I18n.t("guide.dock.show_running_indicators.desc", "Show dot or pill indicators on open application icons")

                            property bool tempVisible: false

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentShowRunningIndicators
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentShowRunningIndicators = val;
                                    dockTabRoot.updateDockSetting("showRunningIndicators", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || showRunningAppsRow.tempVisible
                        row: showRunningAppsRow

                        SettingsRow {
                            id: showRunningAppsRow
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            settingId: "dock_show_running_apps"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰘓"
                            title: I18n.t("guide.dock.show_running_apps.title", "Show open applications")
                            description: I18n.t("guide.dock.show_running_apps.desc", "Display unpinned open applications in the dock")

                            property bool tempVisible: false

                            Toggle {
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                checked: dockTabRoot.currentShowRunningApps
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface1
                                handleColor: ThemeBackend.crust
                                handleOffColor: ThemeBackend.text
                                onToggled: function(val) {
                                    dockTabRoot.currentShowRunningApps = val;
                                    dockTabRoot.updateDockSetting("showRunningApps", val);
                                }
                            }
                        }
                    }

                    CollapsibleSection {
                        open: dockTabRoot.currentEnabled || runningScopeRow.tempVisible
                        row: runningScopeRow

                        SettingsRow {
                            id: runningScopeRow
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            settingId: "dock_running_scope"
                            rootObj: dockTabRoot.rootObj
                            icon: "󰍹"
                            title: I18n.t("guide.dock.running_scope.title", "Active window scope")
                            description: I18n.t("guide.dock.running_scope.desc", "Filter running windows displayed and controlled by the dock")

                            property bool tempVisible: false

                            Dropdown {
                                id: scopeDropdown
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                implicitWidth: dockTabRoot.rootObj.s(220)
                                implicitHeight: dockTabRoot.rootObj.s(32)
                                options: [
                                    I18n.t("guide.dock.running_scope.auto", "Automatic (compositor default)"),
                                    I18n.t("guide.dock.running_scope.all", "All workspaces & monitors"),
                                    I18n.t("guide.dock.running_scope.output", "Current monitor only"),
                                    I18n.t("guide.dock.running_scope.workspace", "Active workspace only")
                                ]
                                currentIndex: {
                                    if (dockTabRoot.currentRunningScope === "all") return 1;
                                    if (dockTabRoot.currentRunningScope === "output") return 2;
                                    if (dockTabRoot.currentRunningScope === "workspace") return 3;
                                    return 0;
                                }
                                accentColor: ThemeBackend.mauve
                                baseColor: ThemeBackend.surface0
                                hoverColor: ThemeBackend.surface1
                                dropdownColor: ThemeBackend.surface0
                                borderColor: Qt.alpha(ThemeBackend.surface2, 0.6)
                                textColor: ThemeBackend.text
                                activeTextColor: ThemeBackend.crust
                                fontPixelSize: dockTabRoot.rootObj.s(11)
                                onValueChanged: function(index, value) {
                                    let sc = "auto";
                                    if (index === 1) sc = "all";
                                    else if (index === 2) sc = "output";
                                    else if (index === 3) sc = "workspace";
                                    dockTabRoot.currentRunningScope = sc;
                                    dockTabRoot.updateDockSetting("runningScope", sc);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
