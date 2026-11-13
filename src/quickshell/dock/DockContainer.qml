import QtQuick
import QtQuick.Layouts
import "../"
import "../reusables"

Item {
    id: containerRoot
    required property var dockWindow
    property alias dockHover: dockHover
    property alias dockTransform: dockTransform

    readonly property bool isAttached: !dockWindow.dockFloating && !dockWindow.editMode && !(dockWindow.sameSideAsBar && !dockWindow.isBarSolid)
    property real outerCornerProgress: isAttached ? 1.0 : 0.0

    Behavior on outerCornerProgress {
        enabled: dockWindow.initialized && !dockWindow.positionChanging
        NumberAnimation {
            duration: containerRoot.isAttached ? 240 : 320
            easing.type: containerRoot.isAttached ? Easing.OutQuad : Easing.InQuad
        }
    }

    property real dynamicCornerRadius: {
        let baseR = (dockWindow.dockCornerRadius >= 0) ? dockWindow.s(dockWindow.dockCornerRadius) : ((dockWindow.dockFloating || dockWindow.editMode) ? ThemeBackend.borderRadius : dockWindow.outerCornerRadius);
        return Math.max(0, Math.min(baseR, (dockWindow.isVertical ? width : height) * 0.5));
    }

    readonly property real dockSideRadius: dynamicCornerRadius * (1.0 - outerCornerProgress)
    readonly property real topLeftCorner: (dockWindow.dockPosition === "top" || dockWindow.dockPosition === "left") ? dockSideRadius : dynamicCornerRadius
    readonly property real topRightCorner: (dockWindow.dockPosition === "top" || dockWindow.dockPosition === "right") ? dockSideRadius : dynamicCornerRadius
    readonly property real bottomLeftCorner: (dockWindow.dockPosition === "bottom" || dockWindow.dockPosition === "left") ? dockSideRadius : dynamicCornerRadius
    readonly property real bottomRightCorner: (dockWindow.dockPosition === "bottom" || dockWindow.dockPosition === "right") ? dockSideRadius : dynamicCornerRadius
    readonly property bool fanFillets: dockWindow.outerCornerRadius > 0.5 && (!dockWindow.sameSideAsBar || (dockWindow.isVertical ? width : height) >= dockWindow.outerCornerRadius)

    Behavior on dynamicCornerRadius {
        enabled: dockWindow.initialized && !dockWindow.positionChanging
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    readonly property int placeholderCount: 6
    property int totalItemCount: {
        if (dockWindow.editMode) {
            return dockWindow.dockAppsModel.count > 0 ? dockWindow.dockAppsModel.count : placeholderCount;
        }
        let pinned = dockWindow.dockAppsModel.count;
        let running = dockWindow.showRunningApps ? dockWindow.runningAppsModel.count : 0;
        let hasSep = (pinned > 0 && running > 0);
        return pinned + (hasSep ? 1 : 0) + running;
    }
    property int effectiveItemCount: {
        if (dockWindow.enableScrolling && totalItemCount > 0) {
            return Math.min(totalItemCount, Math.max(1, dockWindow.dockVisibleElements));
        }
        return totalItemCount;
    }

    property int scrollIndex: 0
    readonly property int maxScrollIndex: Math.max(0, totalItemCount - effectiveItemCount)

    property int hoveredItemIndex: -1

    Timer {
        id: hoverResetTimer
        interval: 80
        repeat: false
        onTriggered: containerRoot.hoveredItemIndex = -1
    }

    function checkHoverReset() {
        hoverResetTimer.restart();
    }

    function cancelHoverReset() {
        hoverResetTimer.stop();
    }

    onTotalItemCountChanged: {
        if (scrollIndex > maxScrollIndex) scrollIndex = maxScrollIndex;
    }
    onEffectiveItemCountChanged: {
        if (scrollIndex > maxScrollIndex) scrollIndex = maxScrollIndex;
    }

    function scrollNext() {
        if (scrollIndex < maxScrollIndex) scrollIndex++;
    }

    function scrollPrev() {
        if (scrollIndex > 0) scrollIndex--;
    }

    WheelHandler {
        id: dockWheelHandler
        target: null
        orientation: Qt.Vertical | Qt.Horizontal
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: function(event) {
            if (!dockWindow.enableScrolling) return;
            let dy = (event.angleDelta && event.angleDelta.y !== 0) ? event.angleDelta.y : (event.pixelDelta ? event.pixelDelta.y : 0);
            let dx = (event.angleDelta && event.angleDelta.x !== 0) ? event.angleDelta.x : (event.pixelDelta ? event.pixelDelta.x : 0);
            let delta = Math.abs(dy) >= Math.abs(dx) ? dy : dx;
            if (delta < 0) {
                containerRoot.scrollNext();
            } else if (delta > 0) {
                containerRoot.scrollPrev();
            }
            event.accepted = true;
        }
    }

    property real itemSpacing: dockWindow.editMode ? dockWindow.s(10) : dockWindow.s(dockWindow.dockItemSpacing)
    property real itemSize: dockWindow.s(dockWindow.dockElementSize)
    property real itemStep: itemSize + itemSpacing

    property real dockContentLength: {
        if (dockWindow.editMode) {
            let cnt = dockWindow.dockAppsModel.count > 0 ? dockWindow.dockAppsModel.count : placeholderCount;
            return cnt * itemSize + Math.max(0, cnt - 1) * itemSpacing;
        }
        let pinned = dockWindow.dockAppsModel.count;
        let running = (dockWindow.showRunningApps && !dockWindow.editMode) ? dockWindow.runningAppsModel.count : 0;
        let hasSep = (pinned > 0 && running > 0);
        let totalCount = pinned + running + (hasSep ? 1 : 0);
        if (dockWindow.enableScrolling && totalCount > 0) {
            let vis = Math.min(totalCount, Math.max(1, dockWindow.dockVisibleElements));
            return vis * itemSize + Math.max(0, vis - 1) * itemSpacing;
        }
        let sepThickness = dockWindow.s(1);
        let appCount = pinned + running;
        if (appCount === 0) return 0;
        let appsLen = appCount * itemSize;
        let sepLen = hasSep ? sepThickness : 0;
        let spacingsLen = Math.max(0, totalCount - 1) * itemSpacing;
        return appsLen + sepLen + spacingsLen;
    }
    property real dockThickness: itemSize

    readonly property bool hoverScaleActive: hoveredItemIndex >= 0 && !dockWindow.editMode && dockWindow.dragSourceIndex === -1 && dockWindow.dockHoverScaleMultiplier > 1.0
    readonly property real hoverDelta: Math.max(0.0, dockWindow.dockHoverScaleMultiplier - 1.0)
    property int lastHoveredIndex: 0
    onHoveredItemIndexChanged: {
        if (hoveredItemIndex >= 0) lastHoveredIndex = hoveredItemIndex;
    }

    property real hoverBulgeProgress: hoverScaleActive ? 1.0 : 0.0
    Behavior on hoverBulgeProgress {
        enabled: dockWindow.initialized && !dockWindow.positionChanging
        NumberAnimation { duration: dockWindow.dockHoverAnimDuration; easing.type: dockWindow.dockHoverEffectMode === "spring" ? Easing.OutBack : Easing.OutCubic; easing.overshoot: 1.25 }
    }

    readonly property real targetBulgeCenter: {
        let idx = Math.max(0, lastHoveredIndex);
        let pinned = dockWindow.dockAppsModel.count;
        let offsetInLayout = 0;
        if (idx < pinned) {
            offsetInLayout = idx * itemStep + itemSize * 0.5;
        } else {
            offsetInLayout = pinned * itemStep + dockWindow.s(1) + itemSpacing + (idx - pinned - 1) * itemStep + itemSize * 0.5;
        }
        return (dockWindow.isVertical ? (dockViewport.y + dockLayout.y) : (dockViewport.x + dockLayout.x)) + offsetInLayout;
    }

    property real animatedBulgeCenter: targetBulgeCenter
    Behavior on animatedBulgeCenter {
        enabled: dockWindow.initialized && !dockWindow.positionChanging && hoverBulgeProgress > 0.01
        NumberAnimation { duration: Math.max(80, Math.round(dockWindow.dockHoverAnimDuration * 0.65)); easing.type: Easing.OutCubic }
    }

    readonly property real hoverMaxShift: Math.min(dockWindow.s(dockWindow.dockHoverSpread), itemSize * hoverDelta * 0.65)
    readonly property real hoverEdgeStretch: (hoverScaleActive && dockWindow.dockHoverStretchEdges) ? (2 * hoverMaxShift + hoverDelta * itemSize * 0.5) : 0
    readonly property real bulgeOutset: dockWindow.dockHoverBulge ? ((hoverDelta * itemSize * 0.5 + dockWindow.s(dockWindow.dockHoverBulgeHeight)) * hoverBulgeProgress) : 0
    readonly property real bulgeSpan: Math.min(
        Math.max(itemSize, (dockWindow.isVertical ? containerRoot.height : containerRoot.width) - dockWindow.s(12)),
        dockWindow.s(dockWindow.dockHoverBulgeWidth) + (dockWindow.dockCascadeScale ? itemSize * 0.45 : 0)
    )

    property real fullThickness: dockThickness + dockWindow.s(dockWindow.dockPadding * 2)
    property real fullContentLength: dockContentLength + dockWindow.s(dockWindow.dockPadding * 2 + 4) + hoverEdgeStretch

    property real baseWidth: Math.round(dockWindow.isVertical ? fullThickness : fullContentLength)
    property real baseHeight: Math.round(dockWindow.isVertical ? fullContentLength : fullThickness)

    Behavior on baseWidth {
        enabled: dockWindow.initialized && !dockWindow.positionChanging
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }
    Behavior on baseHeight {
        enabled: dockWindow.initialized && !dockWindow.positionChanging
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    SpringProgress {
        id: dockReveal
        open: dockWindow.isRevealed
        animated: dockWindow.initialized && !dockWindow.positionChanging
    }

    readonly property real revealProgress: dockReveal.value

    width: (dockWindow.sameSideAsBar && dockWindow.isVertical)
        ? Math.round(baseWidth * revealProgress)
        : baseWidth

    height: (dockWindow.sameSideAsBar && !dockWindow.isVertical)
        ? Math.round(baseHeight * revealProgress)
        : baseHeight

    x: {
        if (!dockWindow.isVertical) return Math.round((dockWindow.effectiveWindowWidth - width) / 2);
        if (dockWindow.dockPosition === "left") {
            return Math.round(dockWindow.barOffset + dockWindow.effectiveMargin);
        }
        if (dockWindow.dockPosition === "right") {
            return Math.round(dockWindow.effectiveWindowWidth - width - dockWindow.barOffset - dockWindow.effectiveMargin);
        }
        return Math.round((dockWindow.effectiveWindowWidth - width) / 2);
    }

    y: {
        if (dockWindow.isVertical) return Math.round((dockWindow.effectiveWindowHeight - height) / 2);
        if (dockWindow.dockPosition === "top") {
            return Math.round(dockWindow.barOffset + dockWindow.effectiveMargin);
        }
        if (dockWindow.dockPosition === "bottom") {
            return Math.round(dockWindow.effectiveWindowHeight - height - dockWindow.barOffset - dockWindow.effectiveMargin);
        }
        return Math.round((dockWindow.effectiveWindowHeight - height) / 2);
    }

    property real hideOffset: {
        if (dockWindow.isVertical) {
            let dist = width + dockWindow.barOffset + dockWindow.effectiveMargin + dockWindow.s(20);
            return dockWindow.dockPosition === "left" ? -dist : dist;
        } else {
            let dist = height + dockWindow.barOffset + dockWindow.effectiveMargin + dockWindow.s(20);
            return dockWindow.dockPosition === "top" ? -dist : dist;
        }
    }

    transform: Translate {
        id: dockTransform
        x: (!dockWindow.sameSideAsBar && dockWindow.isVertical) ? containerRoot.hideOffset * (1.0 - containerRoot.revealProgress) : 0
        y: (!dockWindow.sameSideAsBar && !dockWindow.isVertical) ? containerRoot.hideOffset * (1.0 - containerRoot.revealProgress) : 0
    }

    HoverHandler {
        id: dockHover
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        margin: dockWindow.hoverExpansion
        onHoveredChanged: {
            if (!hovered) {
                containerRoot.hoveredItemIndex = -1;
                containerRoot.cancelHoverReset();
            }
        }
    }

    function calculateDropIndex(mx, my) {
        if (dockWindow.dockAppsModel.count <= 1) return 0;
        let spacing = itemSpacing;
        let size = itemSize;
        let step = size + spacing;
        if (dockWindow.isVertical) {
            let layoutY = dockViewport.y + dockLayout.y;
            let relY = my - layoutY;
            let idx = Math.floor((relY + spacing / 2) / step);
            return Math.max(0, Math.min(dockWindow.dockAppsModel.count - 1, idx));
        } else {
            let layoutX = dockViewport.x + dockLayout.x;
            let relX = mx - layoutX;
            let idx = Math.floor((relX + spacing / 2) / step);
            return Math.max(0, Math.min(dockWindow.dockAppsModel.count - 1, idx));
        }
    }

    AttachedSurface {
        kind: "dock"
        blur: dockWindow.dockBackground
        offset: Qt.point(containerRoot.x + dockTransform.x, containerRoot.y + dockTransform.y)
        visible: containerRoot.visible && containerRoot.width > 0 && containerRoot.height > 0
        color: ThemeBackend.liquidGlass ? "transparent" : Qt.alpha(ThemeBackend.base, dockWindow.dockOpacity)
        rects: {
            let baseRect = {
                x: 0, y: 0,
                w: containerRoot.width, h: containerRoot.height,
                r: [containerRoot.topLeftCorner, containerRoot.topRightCorner, containerRoot.bottomRightCorner, containerRoot.bottomLeftCorner]
            };
            if (containerRoot.bulgeOutset <= 0.5) return [baseRect];
            let b = containerRoot.bulgeOutset;
            let span = containerRoot.bulgeSpan;
            let c = containerRoot.animatedBulgeCenter;
            let overlap = dockWindow.s(36);
            let depth = b + overlap;
            let br = Math.min(span * 0.5, depth * 0.5);
            let edgePad = dockWindow.s(6);
            let bulgeRect;
            if (dockWindow.dockPosition === "bottom") {
                let bx = Math.max(edgePad, Math.min(containerRoot.width - span - edgePad, c - span * 0.5));
                bulgeRect = { x: bx, y: -b, w: span, h: depth, r: [br, br, br, br] };
            } else if (dockWindow.dockPosition === "top") {
                let bx = Math.max(edgePad, Math.min(containerRoot.width - span - edgePad, c - span * 0.5));
                bulgeRect = { x: bx, y: containerRoot.height - overlap, w: span, h: depth, r: [br, br, br, br] };
            } else if (dockWindow.dockPosition === "left") {
                let by = Math.max(edgePad, Math.min(containerRoot.height - span - edgePad, c - span * 0.5));
                bulgeRect = { x: containerRoot.width - overlap, y: by, w: depth, h: span, r: [br, br, br, br] };
            } else {
                let by = Math.max(edgePad, Math.min(containerRoot.height - span - edgePad, c - span * 0.5));
                bulgeRect = { x: -b, y: by, w: depth, h: span, r: [br, br, br, br] };
            }
            return [baseRect, bulgeRect];
        }
        filletRadius: {
            let baseFillet = (containerRoot.isAttached && containerRoot.fanFillets) ? (dockWindow.outerCornerRadius * containerRoot.outerCornerProgress) : 0;
            return containerRoot.bulgeOutset > 0.5 ? Math.max(baseFillet, dockWindow.s(dockWindow.dockHoverBulgeSmoothness) * containerRoot.hoverBulgeProgress) : baseFillet;
        }
        attachTo: containerRoot.isAttached && dockWindow.sameSideAsBar ? ["bar"] : []
        publishShape: containerRoot.isAttached && dockWindow.sameSideAsBar
        edges: containerRoot.isAttached && !dockWindow.sameSideAsBar ? [dockWindow.dockPosition] : []
    }

    Item {
        id: dockBgWrapper
        anchors.fill: parent
        opacity: dockWindow.dockOpacity
        layer.enabled: dockWindow.dockOpacity < 1.0

        MouseArea {
            anchors.fill: parent
            z: -1
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if (typeof DockAppMenuController !== "undefined" && DockAppMenuController.isVisible) {
                    DockAppMenuController.hide();
                }
            }
        }

        Rectangle {
            id: dockBg
            anchors.fill: parent
            radius: containerRoot.dynamicCornerRadius
            topLeftRadius: containerRoot.topLeftCorner
            topRightRadius: containerRoot.topRightCorner
            bottomLeftRadius: containerRoot.bottomLeftCorner
            bottomRightRadius: containerRoot.bottomRightCorner
            color: "transparent"
            clip: true

        }
    }

    Item {
        id: dockContentClipper
        anchors.fill: parent
        clip: dockWindow.sameSideAsBar && containerRoot.revealProgress < 0.999
        opacity: dockWindow.sameSideAsBar ? containerRoot.revealProgress : 1.0
        visible: !dockWindow.sameSideAsBar || containerRoot.revealProgress > 0.001

        Item {
            id: dockViewport
            x: Math.round((containerRoot.width - width) / 2)
            y: Math.round((containerRoot.height - height) / 2)

            width: dockWindow.isVertical ? Math.round(containerRoot.dockThickness + dockWindow.s(16) + dockWindow.hoverExpansion * 2) : containerRoot.dockContentLength
            height: dockWindow.isVertical ? containerRoot.dockContentLength : Math.round(containerRoot.dockThickness + dockWindow.s(16) + dockWindow.hoverExpansion * 2)
            clip: dockWindow.enableScrolling && (containerRoot.totalItemCount > containerRoot.effectiveItemCount)
            visible: width > 0 && height > 0

            GridLayout {
                id: dockLayout
                columns: dockWindow.isVertical ? 1 : Math.max(1, containerRoot.totalItemCount)
                rows: dockWindow.isVertical ? Math.max(1, containerRoot.totalItemCount) : 1
                columnSpacing: containerRoot.itemSpacing
                rowSpacing: containerRoot.itemSpacing
                width: implicitWidth
                height: implicitHeight

                Behavior on columnSpacing {
                    enabled: dockWindow.initialized && !dockWindow.positionChanging
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }
                Behavior on rowSpacing {
                    enabled: dockWindow.initialized && !dockWindow.positionChanging
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }

                x: {
                    if (dockWindow.isVertical) {
                        return Math.round((dockViewport.width - width) / 2);
                    }
                    if (!dockWindow.enableScrolling || containerRoot.totalItemCount <= containerRoot.effectiveItemCount) {
                        return Math.round((dockViewport.width - width) / 2);
                    }
                    return Math.round(-containerRoot.scrollIndex * containerRoot.itemStep);
                }

                y: {
                    if (!dockWindow.isVertical) {
                        return Math.round((dockViewport.height - height) / 2);
                    }
                    if (!dockWindow.enableScrolling || containerRoot.totalItemCount <= containerRoot.effectiveItemCount) {
                        return Math.round((dockViewport.height - height) / 2);
                    }
                    return Math.round(-containerRoot.scrollIndex * containerRoot.itemStep);
                }

                Behavior on x {
                    enabled: dockWindow.initialized && dockWindow.enableScrolling && containerRoot.revealProgress >= 0.99 && !dockWindow.positionChanging
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }
                Behavior on y {
                    enabled: dockWindow.initialized && dockWindow.enableScrolling && containerRoot.revealProgress >= 0.99 && !dockWindow.positionChanging
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }

                Repeater {
                    model: dockWindow.dockAppsModel

                    delegate: DockAppButton {
                        dockWindow: containerRoot.dockWindow
                        dockContainer: containerRoot
                    }
                }

                Item {
                    id: dockSeparator
                    visible: dockWindow.showRunningApps && dockWindow.runningAppsModel.count > 0 && dockWindow.dockAppsModel.count > 0 && !dockWindow.editMode
                    Layout.preferredWidth: visible ? (dockWindow.isVertical ? dockWindow.s(dockWindow.dockElementSize) : dockWindow.s(1)) : 0
                    Layout.preferredHeight: visible ? (dockWindow.isVertical ? dockWindow.s(1) : dockWindow.s(dockWindow.dockElementSize)) : 0
                    Layout.maximumWidth: visible ? -1 : 0
                    Layout.maximumHeight: visible ? -1 : 0
                    Layout.alignment: Qt.AlignCenter

                    Rectangle {
                        anchors.centerIn: parent
                        width: dockWindow.isVertical ? Math.round(dockWindow.s(dockWindow.dockElementSize) * 0.5) : 1
                        height: dockWindow.isVertical ? 1 : Math.round(dockWindow.s(dockWindow.dockElementSize) * 0.5)
                        radius: 1
                        color: Qt.alpha(ThemeBackend.surface2, 0.7)
                    }
                }

                Repeater {
                    id: runningAppsRepeater
                    model: (dockWindow.showRunningApps && !dockWindow.editMode) ? dockWindow.runningAppsModel : null

                    delegate: DockRunningButton {
                        dockWindow: containerRoot.dockWindow
                        dockContainer: containerRoot
                    }
                }

            }
        }
    }
}