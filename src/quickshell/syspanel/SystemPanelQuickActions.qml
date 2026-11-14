import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.Pipewire
import "../"
import "../reusables"

Item {
    required property var panel
    property alias nightLight: nightLightBtn
    property alias coffee: coffeeBtn
    property alias warp: warpBtn
    property alias phantom: phantomBtn
    property alias record: recBtn

    component QuickActionBtn : Rectangle {
        id: qaBtn
        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: view.panel.cardRadius

        property bool isActive: false
        property string iconText: ""
        property color activeColor: ThemeBackend.blue
        readonly property bool isHovered: qaMa.containsMouse
        property real customFontSize: 0
        property string customFontFamily: ""

        property real togglePulse: 0.0

        onIsActiveChanged: {
            if (qaGlass.active) togglePulseAnim.restart();
        }

        SequentialAnimation {
            id: togglePulseAnim
            NumberAnimation { target: qaBtn; property: "togglePulse"; to: 1.0; duration: 90; easing.type: Easing.OutQuad }
            NumberAnimation { target: qaBtn; property: "togglePulse"; to: 0.0; duration: 560; easing.type: Easing.OutCubic }
        }

        signal leftClicked()
        signal rightClicked()

        color: qaGlass.active ? "transparent" : (isActive ? activeColor : ThemeBackend.faded(qaMa.containsMouse ? ThemeBackend.surface1 : Qt.darker(ThemeBackend.surface0, 1.04)))

        GlassFill {
            id: qaGlass
            anchors.fill: parent
            radius: parent.radius
            tintColor: qaBtn.isActive ? qaBtn.activeColor : (qaMa.containsMouse ? ThemeBackend.surface1 : ThemeBackend.surface0)
            tintAmount: qaBtn.isActive ? 0.6 : 0.3
            shadow: 1
            press: qaMa.pressed ? 1 : (qaMa.containsMouse ? 0.25 : 0)
            pulse: qaBtn.togglePulse
            Behavior on press { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
            Behavior on tintAmount { NumberAnimation { duration: 150 } }
        }
        Behavior on color {
            enabled: view.panel.visible
            ColorAnimation { duration: 150 }
        }

        scale: qaMa.pressed ? 0.95 : (qaMa.containsMouse ? 1.01 : 1.0)
        Behavior on scale {
            enabled: view.panel.visible
            NumberAnimation { duration: 250; easing.type: Easing.OutQuart }
        }

        Text {
            anchors.centerIn: parent
            font.family: qaBtn.customFontFamily !== "" ? qaBtn.customFontFamily : ThemeBackend.iconFont
            font.pixelSize: qaBtn.customFontSize > 0 ? qaBtn.customFontSize : view.panel.s(18)
            font.weight: qaBtn.customFontSize > 0 ? Font.Bold : Font.Normal
            color: (qaBtn.isActive && !qaGlass.active) ? ThemeBackend.crust : ((qaBtn.isActive || qaMa.containsMouse) ? ThemeBackend.text : ThemeBackend.subtext0)
            text: qaBtn.iconText
            Behavior on color {
                enabled: view.panel.visible
                ColorAnimation { duration: 150 }
            }
        }

        MouseArea {
            id: qaMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {
                if (mouse.button === Qt.RightButton) qaBtn.rightClicked();
                else qaBtn.leftClicked();
            }
        }
    }

    id: view
    z: 5
    Layout.fillWidth: true
    Layout.preferredHeight: view.panel.s(146)
    Layout.maximumHeight: view.panel.s(146)
    opacity: view.panel.introQuickActions
    transform: Translate { x: (view.panel.isLeftAnchored ? -view.panel.rowSlideDistance : view.panel.rowSlideDistance) * (1.0 - view.panel.introQuickActions) }

    Component.onCompleted: {
        RecordingState.subscribe();
        warpBtn.checkWarp();
        phantomBtn.checkPhantom();
    }

    Component.onDestruction: {
        RecordingState.unsubscribe();
    }

    Connections {
        target: view.panel
        function onVisibleChanged() {
            if (view.panel.visible) {
                warpBtn.checkWarp();
                phantomBtn.checkPhantom();
            }
        }
    }

    // Process for Cloudflare WARP status
    Process {
        id: warpProc
        command: ["bash", "-c", "warp-cli status 2>/dev/null | grep -i 'Status update: Connected' >/dev/null && echo 'ON' || echo 'OFF'"]
        stdout: StdioCollector {
            id: warpOut
            onStreamFinished: {
                let res = warpOut.text.trim();
                warpBtn.isActive = (res === "ON");
            }
        }
    }

    Timer {
        id: warpDelayTimer
        interval: 800
        repeat: false
        onTriggered: warpBtn.checkWarp()
    }

    Timer {
        id: warpPollTimer
        interval: 3500
        repeat: true
        running: view.panel.visible
        onTriggered: warpBtn.checkWarp()
    }

    // Process for PhantomPlayer status
    Process {
        id: phantomProc
        command: ["bash", "-c", "if playerctl -l 2>/dev/null | grep -q PhantomPlayer || (test -f /tmp/phantomplayer.pid && kill -0 \"$(cat /tmp/phantomplayer.pid 2>/dev/null)\" 2>/dev/null); then echo 'ON'; else echo 'OFF'; fi"]
        stdout: StdioCollector {
            id: phantomOut
            onStreamFinished: {
                let res = phantomOut.text.trim();
                phantomBtn.isActive = (res === "ON");
            }
        }
    }

    FileView {
        path: "/tmp/phantomplayer.pid"
        watchChanges: true
        printErrors: false
        onFileChanged: phantomBtn.checkPhantom()
    }

    Timer {
        id: phantomDelayTimer
        interval: 700
        repeat: false
        onTriggered: phantomBtn.checkPhantom()
    }

    Timer {
        id: phantomPollTimer
        interval: 3500
        repeat: true
        running: view.panel.visible
        onTriggered: phantomBtn.checkPhantom()
    }

    GridLayout {
        anchors.fill: parent
        columns: 4
        rows: 2
        rowSpacing: view.panel.s(6)
        columnSpacing: view.panel.s(6)

        // ================= ROW 1 =================

        // 1. Wi-Fi
        QuickActionBtn {
            iconText: isActive ? "󰤨" : "󰤮"
            activeColor: ThemeBackend.blue
            isActive: view.panel.wifiRadioEnabled
            onLeftClicked: {
                Sounds.playSfx("system/quick_click.wav");
                Networking.wifiEnabled = !Networking.wifiEnabled;
            }
            onRightClicked: {
                view.panel.closeAnim.start();
                Quickshell.execDetached(["bash", Caching.serpantinumDir + "/scripts/qs_manager.sh", "toggle", "network", "wifi"]);
            }
        }

        // 2. Bluetooth
        QuickActionBtn {
            iconText: isActive ? "󰂯" : "󰂲"
            activeColor: ThemeBackend.mauve
            isActive: view.panel.btRadioEnabled
            onLeftClicked: {
                Sounds.playSfx("system/quick_click.wav");
                if (Bluetooth.defaultAdapter) {
                    Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                }
            }
            onRightClicked: {
                view.panel.closeAnim.start();
                Quickshell.execDetached(["bash", Caching.serpantinumDir + "/scripts/qs_manager.sh", "toggle", "network", "bt"]);
            }
        }

        // 3. Night Light
        QuickActionBtn {
            id: nightLightBtn
            iconText: "󰖔"
            activeColor: ThemeBackend.peach

            function updateState() {
                let anyEnabled = false;
                if (typeof Gamma !== "undefined" && typeof Gamma.isAnyEnabled === "function") {
                    anyEnabled = Gamma.isAnyEnabled();
                } else if (typeof Config !== "undefined") {
                    let ds = Config.getSetting("display", {"monitors": {}});
                    let mons = (ds && ds.monitors) ? ds.monitors : {};
                    for (let mName in mons) {
                        if (mons[mName] && mons[mName].enabled) {
                            anyEnabled = true;
                            break;
                        }
                    }
                }
                isActive = anyEnabled;
            }

            Component.onCompleted: updateState()

            Connections {
                target: typeof Gamma !== "undefined" ? Gamma : null
                enabled: true
                ignoreUnknownSignals: true
                function onStateChanged() {
                    nightLightBtn.updateState();
                }
            }

            Connections {
                target: typeof Config !== "undefined" ? Config : null
                enabled: true
                ignoreUnknownSignals: true
                function onSettingsLoaded() {
                    nightLightBtn.updateState();
                }
            }

            onLeftClicked: {
                Sounds.playSfx("system/quick_click.wav");
                let shouldEnable = !isActive;
                if (typeof Gamma !== "undefined" && typeof Gamma.setAllMonitorsEnabled === "function") {
                    Gamma.setAllMonitorsEnabled(shouldEnable);
                } else if (typeof Config !== "undefined") {
                    let ds = Config.getSetting("display", {"monitors": {}});
                    let mons = (ds && ds.monitors) ? ds.monitors : {};
                    for (let mName in mons) {
                        if (mons[mName]) mons[mName].enabled = shouldEnable;
                    }
                    Config.setSetting("display", {"monitors": mons});
                }
                updateState();
            }

            onRightClicked: {
                view.panel.closeAnim.start();
                Quickshell.execDetached(["bash", Caching.serpantinumDir + "/scripts/qs_manager.sh", "toggle", "settings", "display:display_general"]);
            }
        }

        // 4. Caffeine
        QuickActionBtn {
            id: coffeeBtn
            activeColor: ThemeBackend.sapphire
            property real coffeeStartTime: 0
            property real coffeeEndTime: 0
            property int remainingSeconds: 0

            iconText: {
                if (!isActive) return "󰅶";
                if (remainingSeconds <= 0) return "󰅶";
                let mins = Math.ceil(remainingSeconds / 60);
                if (mins < 60) return mins + "m";
                let hrs = Math.floor(mins / 60);
                let remMins = mins % 60;
                return remMins > 0 ? hrs + "h" : hrs + "h";
            }

            customFontSize: {
                if (!isActive) return 0;
                let t = iconText;
                if (t.length >= 3) return view.panel.s(12);
                if (t.length >= 2) return view.panel.s(14);
                return 0;
            }

            function updateRemaining() {
                if (!isActive || coffeeEndTime <= 0) {
                    remainingSeconds = 0;
                    return;
                }
                let now = Date.now();
                let diff = Math.max(0, Math.floor((coffeeEndTime - now) / 1000));
                remainingSeconds = diff;
                if (diff <= 0) {
                    disableCaffeine();
                }
            }

            function syncConfig(enable) {
                if (typeof Config === "undefined") return;
                let idleObj = Config.getSetting("idle", {}) || {};
                idleObj.manualInhibit = enable;
                idleObj.caffeineStartTime = enable ? coffeeStartTime : 0;
                idleObj.caffeineEndTime = enable ? coffeeEndTime : 0;
                Config.setSetting("idle", idleObj);
            }

            function enableCaffeine(durationMs) {
                let now = Date.now();
                coffeeStartTime = now;
                coffeeEndTime = now + durationMs;
                isActive = true;
                updateRemaining();
                syncConfig(true);
            }

            function increaseCaffeine(addMs) {
                let now = Date.now();
                if (!isActive || coffeeEndTime <= now) {
                    enableCaffeine(addMs);
                } else {
                    coffeeEndTime += addMs;
                    updateRemaining();
                    syncConfig(true);
                }
            }

            function disableCaffeine() {
                isActive = false;
                coffeeStartTime = 0;
                coffeeEndTime = 0;
                remainingSeconds = 0;
                syncConfig(false);
            }

            function updateState() {
                if (typeof Config === "undefined") return;
                let idleObj = Config.getSetting("idle", {}) || {};
                let endTime = Number(idleObj.caffeineEndTime) || 0;

                if (!idleObj.manualInhibit) {
                    isActive = false;
                    coffeeStartTime = 0;
                    coffeeEndTime = 0;
                    remainingSeconds = 0;
                } else if (endTime > 0 && endTime <= Date.now()) {
                    disableCaffeine();
                } else {
                    coffeeStartTime = Number(idleObj.caffeineStartTime) || 0;
                    coffeeEndTime = endTime;
                    isActive = true;
                    updateRemaining();
                }
            }

            Timer {
                id: coffeeTicker
                interval: view.panel.visible ? 1000 : 15000
                repeat: true
                running: coffeeBtn.isActive
                triggeredOnStart: true
                onTriggered: {
                    coffeeBtn.updateRemaining();
                }
            }

            Component.onCompleted: updateState()

            Connections {
                target: typeof Config !== "undefined" ? Config : null
                enabled: true
                ignoreUnknownSignals: true
                function onSettingsLoaded() {
                    coffeeBtn.updateState();
                }
            }

            onLeftClicked: {
                Sounds.playSfx("system/quick_click.wav");
                if (isActive) {
                    disableCaffeine();
                } else {
                    enableCaffeine(3600 * 1000);
                }
            }

            onRightClicked: {
                Sounds.playSfx("system/quick_click.wav");
                increaseCaffeine(3600 * 1000);
            }
        }

        // ================= ROW 2 =================

        // 5. Cloudflare WARP
        QuickActionBtn {
            id: warpBtn
            iconText: "󰖂"
            activeColor: "#f6821f" // Official Cloudflare Orange
            isActive: false

            function checkWarp() {
                warpProc.running = false;
                warpProc.running = true;
            }

            onLeftClicked: {
                Sounds.playSfx("system/quick_click.wav");
                if (isActive) {
                    isActive = false;
                    Quickshell.execDetached(["warp-cli", "disconnect"]);
                } else {
                    isActive = true;
                    Quickshell.execDetached(["warp-cli", "connect"]);
                }
                warpDelayTimer.restart();
            }

            onRightClicked: {
                Sounds.playSfx("system/quick_click.wav");
                checkWarp();
            }
        }

        // 6. PhantomPlayer
        QuickActionBtn {
            id: phantomBtn
            iconText: "󰥠"
            activeColor: ThemeBackend.mauve
            isActive: false

            function checkPhantom() {
                phantomProc.running = false;
                phantomProc.running = true;
            }

            onLeftClicked: {
                Sounds.playSfx("system/quick_click.wav");
                Quickshell.execDetached(["/home/nursayat/Documents/MyProjects/PhantomPlayer/phantom-toggle.sh"]);
                phantomDelayTimer.restart();
            }

            onRightClicked: {
                Sounds.playSfx("system/quick_click.wav");
                Quickshell.execDetached(["/home/nursayat/Documents/MyProjects/PhantomPlayer/phantom-trigger.sh"]);
                phantomDelayTimer.restart();
            }
        }

        // 7. Screen Recording
        QuickActionBtn {
            id: recBtn
            iconText: RecordingState.isRecording ? "󰻃" : "󰹑"
            activeColor: ThemeBackend.red
            isActive: RecordingState.isRecording

            onLeftClicked: {
                Sounds.playSfx("system/quick_click.wav");
                view.panel.closeAnim.start();
                Quickshell.execDetached(["serpantinum", "screenshot", "--record"]);
            }

            onRightClicked: {
                Sounds.playSfx("system/quick_click.wav");
                view.panel.closeAnim.start();
                Quickshell.execDetached(["serpantinum", "screenshot", "--record", "--full"]);
            }
        }

        // 8. Airplane Mode
        QuickActionBtn {
            iconText: "󰀝"
            activeColor: ThemeBackend.red
            isActive: !view.panel.wifiRadioEnabled && !view.panel.btRadioEnabled
            onLeftClicked: {
                Sounds.playSfx("system/quick_click.wav");
                let enableAirplane = !isActive;
                if (enableAirplane) {
                    view.panel.btStateBeforeAirplane = view.panel.btRadioEnabled;
                    view.panel.wifiStateBeforeAirplane = view.panel.wifiRadioEnabled;
                    Networking.wifiEnabled = false;
                    if (Bluetooth.defaultAdapter) Bluetooth.defaultAdapter.enabled = false;
                } else {
                    let restoreWifi = view.panel.wifiStateBeforeAirplane;
                    let restoreBt = view.panel.btStateBeforeAirplane;
                    if (!restoreWifi && !restoreBt) {
                        restoreWifi = true;
                    }
                    Networking.wifiEnabled = restoreWifi;
                    if (Bluetooth.defaultAdapter) Bluetooth.defaultAdapter.enabled = restoreBt;
                }
            }
        }
    }
}
