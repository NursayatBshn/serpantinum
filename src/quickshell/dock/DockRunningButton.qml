import QtQuick
import QtQuick.Layouts
import "../"
import "../reusables"

Item {
    id: runningDockButton
    required property var dockWindow
    required property var dockContainer
    required property var model
    required property int index

    implicitWidth: dockWindow.s(dockWindow.dockElementSize)
    implicitHeight: dockWindow.s(dockWindow.dockElementSize)
    Layout.preferredWidth: dockWindow.s(dockWindow.dockElementSize)
    Layout.preferredHeight: dockWindow.s(dockWindow.dockElementSize)
    Layout.alignment: Qt.AlignCenter

    property int itemIndex: dockWindow.dockAppsModel.count + 1 + index
    property real popScale: 1.0
    property real flashOpacity: 0.0
    property color btnColor: ThemeBackend.surface0
    property int cornerRadius: Math.round(dockWindow.s(dockWindow.dockElementSize) * (dockWindow.dockIconRadius / 100.0))
    readonly property int unreadNotifCount: dockWindow.getUnreadNotifCount(model.desktop_id, model.name)
    property int btnSize: dockWindow.s(dockWindow.dockElementSize)

    readonly property var runningInfo: dockWindow.getRunningInfoForApp(model.desktop_id)
    readonly property bool isAppRunning: runningInfo !== null && runningInfo.hasWindows
    readonly property bool isAppHere: runningInfo !== null && runningInfo.count > 0
    readonly property bool isAppFocused: runningInfo !== null && runningInfo.isFocused
    readonly property int appWindowCount: runningInfo !== null ? runningInfo.count : 0
    readonly property bool isOnlyElsewhere: runningInfo !== null && runningInfo.count === 0 && runningInfo.elsewhere.length > 0

    z: Math.round(runningBtnShape.scale * 100)

    readonly property bool canHoverScale: !dockWindow.editMode && dockWindow.dragSourceIndex === -1
    readonly property real maxHoverScale: dockWindow.dockHoverScaleMultiplier
    readonly property real hoverScaleDelta: Math.max(0.0, maxHoverScale - 1.0)

    property real hoverWeight: {
        if (!canHoverScale || dockContainer.hoveredItemIndex < 0) return 0.0;
        let d = Math.abs(runningDockButton.itemIndex - dockContainer.hoveredItemIndex);
        if (d === 0) return 1.0;
        if (!dockWindow.dockCascadeScale) return 0.0;
        let r = dockWindow.dockCascadeRadius;
        if (d > r) return 0.0;
        if (dockWindow.dockHoverEffectMode === "wave") {
            return 0.5 * (1.0 + Math.cos(Math.PI * d / (r + 1.0)));
        }
        let norm = d / (r + 1.0);
        return Math.max(0.0, (1.0 - norm) * (1.0 - norm));
    }

    property real baseHoverScale: {
        if (dockWindow.dockHoverEffectMode === "flat") return 1.0;
        return 1.0 + hoverScaleDelta * hoverWeight;
    }

    property real targetScale: {
        let s = baseHoverScale;
        if (runningBtnMa.pressed && canHoverScale) {
            return s > 1.0 ? (s * 1.04) : 1.06;
        }
        return s;
    }

    property real targetTilt: {
        if (!dockWindow.dockHoverTilt || !canHoverScale || dockContainer.hoveredItemIndex < 0) return 0.0;
        let diff = itemIndex - dockContainer.hoveredItemIndex;
        if (diff === 0) return 0.0;
        let d = Math.abs(diff);
        if (d > dockWindow.dockCascadeRadius) return 0.0;
        return (diff > 0 ? 1 : -1) * Math.max(1.5, 6.0 / d);
    }

    property real animSpread: {
        if (!canHoverScale || dockContainer.hoveredItemIndex < 0) return 0.0;
        if (dockWindow.dockHoverEffectMode === "flat") return 0.0;
        let diff = itemIndex - dockContainer.hoveredItemIndex;
        if (diff === 0) return 0.0;
        let sign = diff > 0 ? 1.0 : -1.0;
        let d = Math.abs(diff);
        let maxAllowedShift = Math.min(dockWindow.s(dockWindow.dockHoverSpread), runningDockButton.btnSize * hoverScaleDelta * 0.65);
        if (dockWindow.dockCascadeScale) {
            let r = dockWindow.dockCascadeRadius;
            let shift = maxAllowedShift * Math.min(1.0, d / Math.max(1.0, r * 0.7));
            return sign * shift;
        } else {
            return (d === 1) ? (sign * maxAllowedShift * 0.45) : 0.0;
        }
    }

    property real animLift: {
        if (!canHoverScale || dockContainer.hoveredItemIndex < 0) return 0.0;
        if (dockWindow.dockHoverEffectMode === "flat") {
            return (runningDockButton.itemIndex === dockContainer.hoveredItemIndex) ? dockWindow.s(dockWindow.dockHoverLift) : 0.0;
        }
        return dockWindow.s(dockWindow.dockHoverLift) * hoverWeight;
    }

    property real targetOffsetX: {
        if (dockWindow.isVertical) {
            if (dockWindow.dockPosition === "left") return animLift;
            if (dockWindow.dockPosition === "right") return -animLift;
            return 0.0;
        }
        return animSpread;
    }

    property real targetOffsetY: {
        if (dockWindow.isVertical) return animSpread;
        if (dockWindow.dockPosition === "bottom") return -animLift;
        if (dockWindow.dockPosition === "top") return animLift;
        return 0.0;
    }

    property real currentOffsetX: targetOffsetX
    property real currentOffsetY: targetOffsetY

    Behavior on currentOffsetX {
        enabled: dockWindow.initialized && !dockWindow.positionChanging
        NumberAnimation { duration: dockWindow.dockHoverAnimDuration; easing.type: dockWindow.dockHoverEffectMode === "spring" ? Easing.OutBack : Easing.OutCubic; easing.overshoot: 1.3 }
    }
    Behavior on currentOffsetY {
        enabled: dockWindow.initialized && !dockWindow.positionChanging
        NumberAnimation { duration: dockWindow.dockHoverAnimDuration; easing.type: dockWindow.dockHoverEffectMode === "spring" ? Easing.OutBack : Easing.OutCubic; easing.overshoot: 1.3 }
    }

    Item {
        id: runningFloatWrapper
        anchors.fill: parent

        transform: Translate {
            x: runningDockButton.currentOffsetX
            y: runningDockButton.currentOffsetY
        }

        Rectangle {
            id: runningBtnShape
            anchors.fill: parent
            radius: runningDockButton.cornerRadius
            clip: true
            color: runningBtnGlass.active ? "transparent" : Qt.alpha(runningBtnMa.pressed ? Qt.darker(runningDockButton.btnColor, 1.12) : (runningBtnMa.containsMouse ? Qt.lighter(runningDockButton.btnColor, 1.12) : runningDockButton.btnColor), ThemeBackend.elementOpacity)

            GlassFill {
                id: runningBtnGlass
                anchors.fill: parent
                radius: parent.radius
                tintColor: runningDockButton.btnColor
                tintAmount: 0.3
                press: runningBtnMa.pressed ? 1 : Math.max(runningBtnMa.containsMouse ? 0.3 : 0, 0.3 * Math.max(0, Math.min(1, (runningDockButton.baseHoverScale - 1.0) / Math.max(0.01, runningDockButton.hoverScaleDelta))))
                Behavior on press { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
            }
            transformOrigin: Item.Center
            rotation: runningDockButton.targetTilt
            Behavior on rotation {
                NumberAnimation { duration: dockWindow.dockHoverAnimDuration; easing.type: Easing.OutCubic }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -dockWindow.s(5)
                radius: parent.radius + dockWindow.s(5)
                color: Qt.alpha(ThemeBackend.mauve, 0.28)
                z: -1
                opacity: (dockWindow.dockHoverGlow && dockContainer.hoveredItemIndex === runningDockButton.itemIndex) ? 1.0 : 0.0
                visible: opacity > 0.01
                Behavior on opacity { NumberAnimation { duration: dockWindow.dockHoverAnimDuration } }
            }

            scale: runningDockButton.targetScale * runningDockButton.popScale

            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on scale {
                NumberAnimation {
                    duration: dockWindow.dockHoverAnimDuration
                    easing.type: dockWindow.dockHoverEffectMode === "spring" ? Easing.OutBack : Easing.OutCubic
                    easing.overshoot: 1.35
                }
            }

            Image {
                id: runningAppIcon
                anchors.fill: parent
                anchors.margins: dockWindow.s(Math.round(dockWindow.dockElementSize * 0.14))
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
                mipmap: true
                property bool failedLoad: false
                visible: source !== "" && status === Image.Ready && !failedLoad

                source: {
                    let ic = model.icon || "";
                    if (!ic) return "";
                    if (ic.startsWith("file://") || ic.startsWith("image://") || ic.startsWith("http://") || ic.startsWith("https://")) return ic;
                    if (ic.startsWith("/")) return "file://" + ic;
                    let baseName = ic.replace(/\.(png|svg|xpm|ico)$/i, "");
                    if (typeof Quickshell !== "undefined" && typeof Quickshell.iconPath === "function") {
                        let resolved = Quickshell.iconPath(ic) || Quickshell.iconPath(baseName);
                        if (resolved && resolved.length > 0) {
                            return resolved.startsWith("/") ? ("file://" + resolved) : resolved;
                        }
                    }
                    return "image://icon/" + baseName;
                }
                onStatusChanged: {
                    if (status === Image.Error) failedLoad = true;
                }
            }

            Rectangle {
                id: notifBadge
                visible: runningDockButton.unreadNotifCount > 0 && dockWindow.dockShowNotifBadges && !dockWindow.editMode
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: dockWindow.s(2)
                anchors.rightMargin: dockWindow.s(2)
                height: dockWindow.dockNotifBadgeStyle === "dot" ? dockWindow.s(10) : dockWindow.s(16)
                width: dockWindow.dockNotifBadgeStyle === "dot" ? dockWindow.s(10) : Math.max(height, badgeText.implicitWidth + dockWindow.s(8))
                radius: height / 2
                color: dockWindow.dockNotifBadgeColor === "accent" ? ThemeBackend.mauve : ThemeBackend.red
                border.width: 1
                border.color: ThemeBackend.crust
                z: 10

                Text {
                    id: badgeText
                    anchors.centerIn: parent
                    visible: dockWindow.dockNotifBadgeStyle !== "dot"
                    text: runningDockButton.unreadNotifCount > 99 ? "99+" : String(runningDockButton.unreadNotifCount)
                    font.family: ThemeBackend.fontFamily
                    font.pixelSize: Math.max(8, dockWindow.s(10))
                    font.weight: Font.Bold
                    color: ThemeBackend.crust
                }
            }

            Text {
                anchors.centerIn: parent
                visible: runningAppIcon.source === "" || runningAppIcon.failedLoad || runningAppIcon.status === Image.Error
                text: model.name ? model.name.charAt(0).toUpperCase() : "?"
                font.family: ThemeBackend.fontFamily
                font.pixelSize: dockWindow.s(Math.round(dockWindow.dockElementSize * 0.42))
                font.weight: Font.Bold
                color: ThemeBackend.text
            }

            Rectangle {
                anchors.fill: parent
                radius: runningDockButton.cornerRadius
                color: "#ffffff"
                opacity: runningDockButton.flashOpacity
                PropertyAnimation on opacity {
                    id: runningBtnFlashAnim
                    to: 0
                    duration: 400
                    easing.type: Easing.OutExpo
                }
            }
        }

        Item {
            id: runningIndicatorContainer
            visible: dockWindow.showRunningIndicators && runningDockButton.isAppRunning
            opacity: (visible && dockContainer.revealProgress > 0.1) ? 1.0 : 0.0

            anchors.horizontalCenter: !dockWindow.isVertical ? parent.horizontalCenter : undefined
            anchors.verticalCenter: dockWindow.isVertical ? parent.verticalCenter : undefined

            anchors.bottom: dockWindow.dockPosition === "bottom" ? parent.bottom : undefined
            anchors.top: dockWindow.dockPosition === "top" ? parent.top : undefined
            anchors.left: dockWindow.dockPosition === "left" ? parent.left : undefined
            anchors.right: dockWindow.dockPosition === "right" ? parent.right : undefined

            anchors.bottomMargin: dockWindow.dockPosition === "bottom" ? dockWindow.s(2) : 0
            anchors.topMargin: dockWindow.dockPosition === "top" ? dockWindow.s(2) : 0
            anchors.leftMargin: dockWindow.dockPosition === "left" ? dockWindow.s(2) : 0
            anchors.rightMargin: dockWindow.dockPosition === "right" ? dockWindow.s(2) : 0

            width: dockWindow.isVertical ? dockWindow.s(4) : runningRow.implicitWidth
            height: dockWindow.isVertical ? runningCol.implicitHeight : dockWindow.s(4)

            Rectangle {
                visible: runningDockButton.isOnlyElsewhere
                anchors.centerIn: parent
                width: dockWindow.s(4)
                height: dockWindow.s(4)
                radius: width / 2
                color: "transparent"
            }

            Rectangle {
                id: runningSinglePill
                visible: !runningDockButton.isOnlyElsewhere && runningDockButton.appWindowCount === 1 && runningDockButton.isAppFocused
                anchors.centerIn: parent
                width: dockWindow.isVertical ? dockWindow.s(3.5) : dockWindow.s(14)
                height: dockWindow.isVertical ? dockWindow.s(14) : dockWindow.s(3.5)
                radius: dockWindow.s(2)
                color: ThemeBackend.mauve
            }

            Row {
                id: runningRow
                visible: !runningDockButton.isOnlyElsewhere && !runningSinglePill.visible && !dockWindow.isVertical
                anchors.centerIn: parent
                spacing: dockWindow.s(2.5)

                Repeater {
                    model: Math.min(3, Math.max(1, runningDockButton.appWindowCount))
                    delegate: Rectangle {
                        width: dockWindow.s(3.5)
                        height: dockWindow.s(3.5)
                        radius: width / 2
                        color: (index === 0 && runningDockButton.isAppFocused) ? ThemeBackend.mauve : (index === 0 ? ThemeBackend.subtext0 : ThemeBackend.surface2)
                    }
                }
            }

            Column {
                id: runningCol
                visible: !runningDockButton.isOnlyElsewhere && !runningSinglePill.visible && dockWindow.isVertical
                anchors.centerIn: parent
                spacing: dockWindow.s(2.5)

                Repeater {
                    model: Math.min(3, Math.max(1, runningDockButton.appWindowCount))
                    delegate: Rectangle {
                        width: dockWindow.s(3.5)
                        height: dockWindow.s(3.5)
                        radius: width / 2
                        color: (index === 0 && runningDockButton.isAppFocused) ? ThemeBackend.mauve : (index === 0 ? ThemeBackend.subtext0 : ThemeBackend.surface2)
                    }
                }
            }
        }

        MouseArea {
            id: runningBtnMa
            anchors.fill: parent
            anchors.margins: -Math.max(dockContainer.itemSpacing / 2, (runningBtnShape.scale - 1.0) * runningDockButton.btnSize / 2)
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor

            onEntered: {
                dockContainer.cancelHoverReset();
                if (runningDockButton.canHoverScale) {
                    dockContainer.hoveredItemIndex = runningDockButton.itemIndex;
                }
            }

            onExited: {
                if (dockContainer.hoveredItemIndex === runningDockButton.itemIndex) {
                    dockContainer.checkHoverReset();
                }
            }

            onClicked: function(mouse) {
                if (mouse.button === Qt.MiddleButton) {
                    dockWindow.launchApp(model.desktop_id);
                    return;
                }
                if (mouse.button === Qt.RightButton) {
                    let pt = runningDockButton.mapToItem(null, 0, 0);
                    let globX = pt.x + (runningDockButton.width / 2);
                    let globY = pt.y + (runningDockButton.height / 2);
                    let info = dockWindow.getRunningInfoForApp(model.desktop_id);
                    let winList = [];
                    if (info) {
                        if (info.here) winList = winList.concat(info.here);
                        if (info.elsewhere) winList = winList.concat(info.elsewhere);
                    }
                    DockAppMenuController.toggle(
                        dockWindow.screen,
                        globX,
                        globY,
                        dockWindow.dockPosition,
                        model.desktop_id,
                        model.name || (info ? info.appId : ""),
                        model.icon || "",
                        false,
                        winList,
                        runningDockButton.width
                    );
                    return;
                }
                if (mouse.button === Qt.LeftButton) {
                    if (typeof DockAppMenuController !== "undefined" && DockAppMenuController.isVisible && !DockAppMenuController.isSameApp(DockAppMenuController.desktopId, model.desktop_id)) {
                        let pt = runningDockButton.mapToItem(null, 0, 0);
                        let globX = pt.x + (runningDockButton.width / 2);
                        let globY = pt.y + (runningDockButton.height / 2);
                        let info = dockWindow.getRunningInfoForApp(model.desktop_id);
                        let winList = [];
                        if (info) {
                            if (info.here) winList = winList.concat(info.here);
                            if (info.elsewhere) winList = winList.concat(info.elsewhere);
                        }
                        DockAppMenuController.show(
                            dockWindow.screen,
                            globX,
                            globY,
                            dockWindow.dockPosition,
                            model.desktop_id,
                            model.name || (info ? info.appId : ""),
                            model.icon || "",
                            false,
                            winList,
                            runningDockButton.width
                        );
                        return;
                    }

                    if (typeof DockAppMenuController !== "undefined" && DockAppMenuController.isVisible && DockAppMenuController.isSameApp(DockAppMenuController.desktopId, model.desktop_id)) {
                        DockAppMenuController.hide();
                    }

                    runningDockButton.flashOpacity = 0.4;
                    runningBtnFlashAnim.start();
                    if (typeof Sounds !== "undefined") Sounds.playSfx("reusables/iconbutton/click.wav");
                    dockWindow.activateOrLaunch(model.desktop_id, mouse.modifiers);
                }
            }
        }
    }
}
