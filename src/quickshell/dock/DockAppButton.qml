import QtQuick
import QtQuick.Layouts
import "../"
import "../reusables"

Item {
    id: dockButton
    required property var dockWindow
    required property var dockContainer
    required property var model
    required property int index

    implicitWidth: dockWindow.s(dockWindow.dockElementSize)
    implicitHeight: dockWindow.s(dockWindow.dockElementSize)
    Layout.preferredWidth: dockWindow.s(dockWindow.dockElementSize)
    Layout.preferredHeight: dockWindow.s(dockWindow.dockElementSize)
    Layout.alignment: Qt.AlignCenter
    z: (dockButton.isBeingDragged || dockWindow.dragSourceIndex === index) ? 99999 : Math.round(btnShape.scale * 100)

    property int itemIndex: index
    property real popScale: 1.0
    property real flashOpacity: 0.0
    property color btnColor: ThemeBackend.surface0
    property int cornerRadius: Math.round(dockWindow.s(dockWindow.dockElementSize) * (dockWindow.dockIconRadius / 100.0))
    readonly property int unreadNotifCount: dockWindow.getUnreadNotifCount(model.desktop_id, model.name)
    property bool isDropTarget: dockWindow.dropTargetIndex === index && dockWindow.dragSourceIndex !== index
    property bool isBeingDragged: btnMa.drag.active
    property int btnSize: dockWindow.s(dockWindow.dockElementSize)

    readonly property var runningInfo: dockWindow.getRunningInfoForApp(model.desktop_id)
    readonly property bool isAppRunning: runningInfo !== null && runningInfo.hasWindows
    readonly property bool isAppHere: runningInfo !== null && runningInfo.count > 0
    readonly property bool isAppFocused: runningInfo !== null && runningInfo.isFocused
    readonly property int appWindowCount: runningInfo !== null ? runningInfo.count : 0
    readonly property bool isOnlyElsewhere: runningInfo !== null && runningInfo.count === 0 && runningInfo.elsewhere.length > 0

    readonly property bool canHoverScale: !dockWindow.editMode && dockWindow.dragSourceIndex === -1 && !btnMa.drag.active
    readonly property real maxHoverScale: dockWindow.dockHoverScaleMultiplier
    readonly property real hoverScaleDelta: Math.max(0.0, maxHoverScale - 1.0)

    property real bounceOffset: 0.0

    property real hoverWeight: {
        if (!canHoverScale || dockContainer.hoveredItemIndex < 0) return 0.0;
        let d = Math.abs(dockButton.itemIndex - dockContainer.hoveredItemIndex);
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
        if (btnMa.pressed && canHoverScale) {
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
        let maxAllowedShift = Math.min(dockWindow.s(dockWindow.dockHoverSpread), dockButton.btnSize * hoverScaleDelta * 0.65);
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
            return (dockButton.itemIndex === dockContainer.hoveredItemIndex) ? dockWindow.s(dockWindow.dockHoverLift) : 0.0;
        }
        return dockWindow.s(dockWindow.dockHoverLift) * hoverWeight;
    }

    property real targetOffsetX: {
        if (dockWindow.isVertical) {
            if (dockWindow.dockPosition === "left") return animLift;
            if (dockWindow.dockPosition === "right") return -animLift;
            return 0.0;
        } else {
            return animSpread;
        }
    }

    property real targetOffsetY: {
        if (dockWindow.isVertical) {
            if (dockWindow.dockPosition === "top") return animLift;
            if (dockWindow.dockPosition === "bottom") return -animLift;
            return 0.0;
        } else {
            if (dockWindow.dockPosition === "bottom") return -animLift;
            if (dockWindow.dockPosition === "top") return animLift;
            return 0.0;
        }
    }

    property real currentOffsetX: btnMa.drag.active ? 0 : targetOffsetX
    property real currentOffsetY: btnMa.drag.active ? 0 : targetOffsetY

    Behavior on currentOffsetX {
        enabled: dockWindow.initialized && !dockWindow.positionChanging
        NumberAnimation { duration: dockWindow.dockHoverAnimDuration; easing.type: dockWindow.dockHoverEffectMode === "spring" ? Easing.OutBack : Easing.OutCubic; easing.overshoot: 1.3 }
    }
    Behavior on currentOffsetY {
        enabled: dockWindow.initialized && !dockWindow.positionChanging
        NumberAnimation { duration: dockWindow.dockHoverAnimDuration; easing.type: dockWindow.dockHoverEffectMode === "spring" ? Easing.OutBack : Easing.OutCubic; easing.overshoot: 1.3 }
    }

    Rectangle {
        anchors.fill: parent
        visible: dockButton.isBeingDragged
        radius: dockButton.cornerRadius
        color: Qt.alpha(ThemeBackend.mauve, 0.18)
    }

    Rectangle {
        id: dropIndicator
        anchors.fill: parent
        anchors.margins: -dockWindow.s(3)
        radius: dockButton.cornerRadius + dockWindow.s(3)
        color: Qt.alpha(ThemeBackend.mauve, 0.35)
        visible: opacity > 0
        opacity: dockButton.isDropTarget ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    Item {
        id: floatWrapper
        anchors.fill: !btnMa.drag.active ? parent : undefined
        width: dockButton.btnSize
        height: dockButton.btnSize
        z: btnMa.drag.active ? 999999 : 1

        transform: Translate {
            id: buttonTransform
            x: dockButton.currentOffsetX + (dockWindow.isVertical ? (dockWindow.dockPosition === "left" ? dockButton.bounceOffset : -dockButton.bounceOffset) : 0)
            y: dockButton.currentOffsetY + (dockWindow.isVertical ? 0 : (dockWindow.dockPosition === "top" ? dockButton.bounceOffset : -dockButton.bounceOffset))
        }

        Drag.active: btnMa.drag.active
        Drag.source: dockButton
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        states: [
            State {
                when: btnMa.drag.active
                ParentChange { target: floatWrapper; parent: dockWindow.dragOverlay }
                PropertyChanges {
                    target: floatWrapper
                    width: dockButton.btnSize
                    height: dockButton.btnSize
                    scale: 1.15
                    opacity: 0.92
                    z: 999999
                }
            }
        ]

        Rectangle {
            id: btnShape
            anchors.fill: parent
            radius: dockButton.cornerRadius
            clip: true
            color: dockBtnGlass.active ? "transparent" : Qt.alpha(btnMa.pressed ? Qt.darker(dockButton.btnColor, 1.12) : (btnMa.containsMouse ? Qt.lighter(dockButton.btnColor, 1.12) : dockButton.btnColor), ThemeBackend.elementOpacity)

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            GlassFill {
                id: dockBtnGlass
                anchors.fill: parent
                radius: parent.radius
                tintColor: dockButton.btnColor
                tintAmount: 0.3
                press: btnMa.pressed ? 1 : Math.max(btnMa.containsMouse ? 0.3 : 0, 0.3 * Math.max(0, Math.min(1, (dockButton.baseHoverScale - 1.0) / Math.max(0.01, dockButton.hoverScaleDelta))))
                Behavior on press { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
            }

            transformOrigin: Item.Center

            rotation: dockButton.targetTilt
            Behavior on rotation {
                NumberAnimation { duration: dockWindow.dockHoverAnimDuration; easing.type: Easing.OutCubic }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -dockWindow.s(5)
                radius: parent.radius + dockWindow.s(5)
                color: Qt.alpha(ThemeBackend.mauve, 0.28)
                z: -1
                opacity: (dockWindow.dockHoverGlow && dockContainer.hoveredItemIndex === dockButton.itemIndex) ? 1.0 : 0.0
                visible: opacity > 0.01
                Behavior on opacity { NumberAnimation { duration: dockWindow.dockHoverAnimDuration } }
            }

            scale: dockButton.targetScale * dockButton.popScale
            Behavior on scale {
                NumberAnimation {
                    duration: dockWindow.dockHoverAnimDuration
                    easing.type: dockWindow.dockHoverEffectMode === "spring" ? Easing.OutBack : Easing.OutCubic
                    easing.overshoot: 1.35
                }
            }

            ParallelAnimation {
                id: btnPopAnim
                SequentialAnimation {
                    NumberAnimation { target: dockButton; property: "popScale"; to: 1.12; duration: 110; easing.type: Easing.OutQuad }
                    NumberAnimation { target: dockButton; property: "popScale"; to: 1.0; duration: 380; easing.type: Easing.OutQuint }
                }
                SequentialAnimation {
                    running: false
                    NumberAnimation { target: dockButton; property: "bounceOffset"; to: dockWindow.dockLaunchBounce ? dockWindow.s(14) : 0; duration: 160; easing.type: Easing.OutQuad }
                    NumberAnimation { target: dockButton; property: "bounceOffset"; to: 0; duration: 260; easing.type: Easing.OutBounce }
                }
            }

            Image {
                id: appIcon
                anchors.fill: parent
                anchors.margins: dockWindow.s(Math.round(dockWindow.dockElementSize * 0.14))
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
                mipmap: true
                property bool failedLoad: false

                visible: source !== "" && status === Image.Ready && !failedLoad

                source: {
                    let candidates = [];
                    if (model.icon) candidates.push(model.icon);
                    if (model.canonical_id && candidates.indexOf(model.canonical_id) === -1) candidates.push(model.canonical_id);
                    if (model.desktop_id) {
                        let didClean = String(model.desktop_id).replace(/\.(desktop)$/i, "");
                        if (candidates.indexOf(didClean) === -1) candidates.push(didClean);
                    }

                    for (let i = 0; i < candidates.length; i++) {
                        let c = candidates[i];
                        if (!c) continue;
                        if (c.startsWith("file://") || c.startsWith("image://") || c.startsWith("http://") || c.startsWith("https://")) return c;
                        if (c.startsWith("/")) return "file://" + c;
                        let base = c.replace(/\.(png|svg|xpm|ico)$/i, "");
                        if (typeof Quickshell !== "undefined" && typeof Quickshell.iconPath === "function") {
                            let resolved = Quickshell.iconPath(c) || Quickshell.iconPath(base);
                            if (resolved && resolved.length > 0) {
                                return resolved.startsWith("/") ? ("file://" + resolved) : resolved;
                            }
                        }
                    }

                    if (candidates.length > 0) {
                        let fallbackBase = candidates[0].replace(/\.(png|svg|xpm|ico)$/i, "");
                        return "image://icon/" + fallbackBase;
                    }
                    return "";
                }

                onStatusChanged: {
                    if (status === Image.Error) {
                        failedLoad = true;
                    }
                }
            }

            Rectangle {
                id: notifBadge
                visible: dockButton.unreadNotifCount > 0 && dockWindow.dockShowNotifBadges && !dockWindow.editMode
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
                    text: dockButton.unreadNotifCount > 99 ? "99+" : String(dockButton.unreadNotifCount)
                    font.family: ThemeBackend.fontFamily
                    font.pixelSize: Math.max(8, dockWindow.s(10))
                    font.weight: Font.Bold
                    color: ThemeBackend.crust
                }
            }

            Text {
                anchors.centerIn: parent
                visible: appIcon.source === "" || appIcon.failedLoad || appIcon.status === Image.Error
                text: model.name ? model.name.charAt(0).toUpperCase() : "?"
                font.family: ThemeBackend.fontFamily
                font.pixelSize: dockWindow.s(Math.round(dockWindow.dockElementSize * 0.42))
                font.weight: Font.Bold
                color: ThemeBackend.text
            }

            Rectangle {
                anchors.fill: parent
                radius: dockButton.cornerRadius
                color: "#ffffff"
                opacity: dockButton.flashOpacity
                PropertyAnimation on opacity {
                    id: btnFlashAnim
                    to: 0
                    duration: 400
                    easing.type: Easing.OutExpo
                }
            }
        }

        Item {
            id: indicatorContainer
            visible: dockWindow.showRunningIndicators && dockButton.isAppRunning && !dockWindow.editMode
            opacity: (visible && dockContainer.revealProgress > 0.1) ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }

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

            width: dockWindow.isVertical ? dockWindow.s(4) : contentRow.implicitWidth
            height: dockWindow.isVertical ? contentCol.implicitHeight : dockWindow.s(4)

            Rectangle {
                id: elsewhereRing
                visible: dockButton.isOnlyElsewhere
                anchors.centerIn: parent
                width: dockWindow.s(4)
                height: dockWindow.s(4)
                radius: width / 2
                color: "transparent"
            }

            Rectangle {
                id: singlePill
                visible: !dockButton.isOnlyElsewhere && dockButton.appWindowCount === 1 && dockButton.isAppFocused
                anchors.centerIn: parent
                width: dockWindow.isVertical ? dockWindow.s(3.5) : dockWindow.s(14)
                height: dockWindow.isVertical ? dockWindow.s(14) : dockWindow.s(3.5)
                radius: dockWindow.s(2)
                color: ThemeBackend.mauve

                Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                Behavior on height { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
            }

            Row {
                id: contentRow
                visible: !dockButton.isOnlyElsewhere && !singlePill.visible && !dockWindow.isVertical
                anchors.centerIn: parent
                spacing: dockWindow.s(2.5)

                Repeater {
                    model: Math.min(3, Math.max(1, dockButton.appWindowCount))
                    delegate: Rectangle {
                        width: dockWindow.s(3.5)
                        height: dockWindow.s(3.5)
                        radius: width / 2
                        color: (index === 0 && dockButton.isAppFocused) ? ThemeBackend.mauve : (index === 0 ? ThemeBackend.subtext0 : ThemeBackend.surface2)
                    }
                }
            }

            Column {
                id: contentCol
                visible: !dockButton.isOnlyElsewhere && !singlePill.visible && dockWindow.isVertical
                anchors.centerIn: parent
                spacing: dockWindow.s(2.5)

                Repeater {
                    model: Math.min(3, Math.max(1, dockButton.appWindowCount))
                    delegate: Rectangle {
                        width: dockWindow.s(3.5)
                        height: dockWindow.s(3.5)
                        radius: width / 2
                        color: (index === 0 && dockButton.isAppFocused) ? ThemeBackend.mauve : (index === 0 ? ThemeBackend.subtext0 : ThemeBackend.surface2)
                    }
                }
            }
        }

        MouseArea {
            id: btnMa
            anchors.fill: parent
            anchors.margins: -Math.max(dockContainer.itemSpacing / 2, (btnShape.scale - 1.0) * dockButton.btnSize / 2)
            hoverEnabled: true
            cursorShape: (dockWindow.editMode || inDragHold)
                ? (drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
                : Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

            property bool inDragHold: false

            pressAndHoldInterval: 350

            drag.target: floatWrapper
            drag.axis: Drag.XAndYAxis
            drag.threshold: (dockWindow.editMode || inDragHold) ? 5 : 99999

            onEntered: {
                dockContainer.cancelHoverReset();
                if (dockButton.canHoverScale) {
                    dockContainer.hoveredItemIndex = dockButton.itemIndex;
                }
            }

            onExited: {
                if (dockContainer.hoveredItemIndex === dockButton.itemIndex) {
                    dockContainer.checkHoverReset();
                }
            }

            onPressed: function(mouse) {
                if (mouse.button !== Qt.LeftButton) return;
                inDragHold = false;
                if (dockWindow.editMode) {
                    dockWindow.dragSourceIndex = dockButton.itemIndex;
                    dockWindow.dropTargetIndex = dockButton.itemIndex;
                    if (typeof Sounds !== "undefined") {
                        Sounds.playSfx("guide/barconfig/out.wav");
                    }
                }
            }

            onPressAndHold: {
                inDragHold = true;
                if (!dockWindow.editMode) {
                    dockWindow.setEditMode(true);
                }
                dockWindow.dragSourceIndex = dockButton.itemIndex;
                dockWindow.dropTargetIndex = dockButton.itemIndex;
                if (typeof Sounds !== "undefined") {
                    Sounds.playSfx("guide/barconfig/out.wav");
                }
            }

            onPositionChanged: function(mouse) {
                if ((dockWindow.editMode || inDragHold) && drag.active) {
                    let pt = mapToItem(dockContainer, mouse.x, mouse.y);
                    dockWindow.dropTargetIndex = dockContainer.calculateDropIndex(pt.x, pt.y);
                }
            }

            onReleased: {
                let wasHold = inDragHold;
                inDragHold = false;
                if (dockWindow.editMode || wasHold) {
                    let wasDragging = drag.active;
                    floatWrapper.Drag.drop();
                    if (wasDragging) {
                        let pt = btnMa.mapToItem(dockContainer, btnMa.mouseX, btnMa.mouseY);
                        let fwPos = floatWrapper.mapToItem(dockContainer, 0, 0);
                        let completelyOutside = (fwPos.x + floatWrapper.width <= 0 || fwPos.x >= dockContainer.width ||
                                                 fwPos.y + floatWrapper.height <= 0 || fwPos.y >= dockContainer.height) ||
                                                (pt.x < -dockWindow.s(16) || pt.x > dockContainer.width + dockWindow.s(16) ||
                                                 pt.y < -dockWindow.s(16) || pt.y > dockContainer.height + dockWindow.s(16));
                        if (completelyOutside) {
                            if (typeof Sounds !== "undefined") {
                                Sounds.playSfx("guide/barconfig/in.wav");
                            }
                            if (model.desktop_id && model.desktop_id !== "") {
                                dockWindow.removeAppByDesktopId(model.desktop_id);
                            } else if (dockWindow.dragSourceIndex >= 0 && dockWindow.dragSourceIndex < dockWindow.dockAppsModel.count) {
                                dockWindow.dockAppsModel.remove(dockWindow.dragSourceIndex, 1);
                                dockWindow.saveApps();
                                dockWindow._syncRunningApps();
                            }
                        } else if (dockWindow.dragSourceIndex !== -1 && dockWindow.dropTargetIndex !== -1 && dockWindow.dragSourceIndex !== dockWindow.dropTargetIndex) {
                            if (typeof Sounds !== "undefined") {
                                Sounds.playSfx("guide/barconfig/in.wav");
                            }
                            dockWindow.dockAppsModel.move(dockWindow.dragSourceIndex, dockWindow.dropTargetIndex, 1);
                            dockWindow.saveApps();
                        } else if (typeof Sounds !== "undefined") {
                            Sounds.playSfx("guide/barconfig/in.wav");
                        }
                    }
                    dockWindow.dragSourceIndex = -1;
                    dockWindow.dropTargetIndex = -1;
                    floatWrapper.x = 0;
                    floatWrapper.y = 0;
                }
            }

            onClicked: function(mouse) {
                if (dockWindow.editMode || inDragHold || drag.active) return;

                if (mouse.button === Qt.MiddleButton) {
                    btnPopAnim.start();
                    dockButton.flashOpacity = 0.4;
                    btnFlashAnim.start();
                    if (typeof Sounds !== "undefined") Sounds.playSfx("reusables/iconbutton/click.wav");
                    dockWindow.launchApp(model.desktop_id);
                    return;
                }

                if (mouse.button === Qt.RightButton) {
                    let pt = dockButton.mapToItem(null, 0, 0);
                    let globX = pt.x + (dockButton.width / 2);
                    let globY = pt.y + (dockButton.height / 2);
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
                        true,
                        winList,
                        dockButton.width
                    );
                    return;
                }

                if (mouse.button === Qt.LeftButton) {
                    if (typeof DockAppMenuController !== "undefined" && DockAppMenuController.isVisible && !DockAppMenuController.isSameApp(DockAppMenuController.desktopId, model.desktop_id)) {
                        let pt = dockButton.mapToItem(null, 0, 0);
                        let globX = pt.x + (dockButton.width / 2);
                        let globY = pt.y + (dockButton.height / 2);
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
                            true,
                            winList,
                            dockButton.width
                        );
                        return;
                    }

                    if (typeof DockAppMenuController !== "undefined" && DockAppMenuController.isVisible && DockAppMenuController.isSameApp(DockAppMenuController.desktopId, model.desktop_id)) {
                        DockAppMenuController.hide();
                    }

                    btnPopAnim.start();
                    dockButton.flashOpacity = 0.4;
                    btnFlashAnim.start();
                    if (typeof Sounds !== "undefined") Sounds.playSfx("reusables/iconbutton/click.wav");
                    dockWindow.activateOrLaunch(model.desktop_id, mouse.modifiers);
                }
            }
        }
    }
}
