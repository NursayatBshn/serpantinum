import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import "../"
import "../reusables"
import "KeybindsModel.js" as Model

Item {
    id: window
    visible: false
    focus: true

    function s(val) {
        return Scaler.s(val);
    }

    property var allKeybinds: Model.getKeybinds()
    property var categories: Model.getCategories()
    property string activeCategory: "all"
    property string searchQuery: ""

    property var exitCallback: null

    function closeWindow() {
        if (typeof masterWindow !== "undefined" && masterWindow.switchWidget) {
            masterWindow.switchWidget("hidden", "");
        } else if (typeof Quickshell !== "undefined" && Quickshell.execDetached) {
            Quickshell.execDetached(["serpantinum", "msg", "close"]);
        }
    }

    function startExit(onFinished) {
        introAnim.stop();
        exitCallback = onFinished;
        exitAnim.restart();
    }

    function resetAndPlayIntro() {
        exitAnim.stop();
        introMain = 0;
        introHeader = 0;
        introContent = 0;
        introAnim.restart();
    }

    Timer {
        id: focusTimer
        interval: 60
        repeat: false
        onTriggered: {
            window.forceActiveFocus();
            searchInput.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if (visible) {
            searchQuery = "";
            activeCategory = "all";
            searchInput.text = "";
            focusTimer.restart();
            resetAndPlayIntro();
        } else {
            introAnim.stop();
            exitAnim.stop();
            introMain = 0;
            introHeader = 0;
            introContent = 0;
        }
    }

    Component.onCompleted: {
        if (visible) {
            focusTimer.restart();
            resetAndPlayIntro();
        }
    }

    // Keyboard shortcuts inside cheatsheet
    Shortcut {
        sequence: "Ctrl+F"
        enabled: window.visible
        onActivated: searchInput.forceActiveFocus()
    }

    Shortcut {
        sequence: "Escape"
        enabled: window.visible
        onActivated: window.closeWindow()
    }

    Shortcut {
        sequence: "Tab"
        enabled: window.visible && !searchInput.activeFocus
        onActivated: {
            let idx = 0;
            for (let i = 0; i < categories.length; i++) {
                if (categories[i].id === activeCategory) {
                    idx = (i + 1) % categories.length;
                    break;
                }
            }
            activeCategory = categories[idx].id;
        }
    }

    property real introMain: 0
    property real introHeader: 0
    property real introContent: 0

    ParallelAnimation {
        id: introAnim
        running: false
        NumberAnimation { target: window; property: "introMain"; from: 0; to: 1.0; duration: 380; easing.type: Easing.OutExpo }
        SequentialAnimation {
            PauseAnimation { duration: 40 }
            NumberAnimation { target: window; property: "introHeader"; from: 0; to: 1.0; duration: 320; easing.type: Easing.OutBack; easing.overshoot: 1.1 }
        }
        SequentialAnimation {
            PauseAnimation { duration: 80 }
            NumberAnimation { target: window; property: "introContent"; from: 0; to: 1.0; duration: 380; easing.type: Easing.OutExpo }
        }
    }

    SequentialAnimation {
        id: exitAnim
        running: false
        ParallelAnimation {
            NumberAnimation { target: window; property: "introContent"; to: 0.0; duration: 120; easing.type: Easing.InCubic }
            SequentialAnimation {
                PauseAnimation { duration: 20 }
                NumberAnimation { target: window; property: "introHeader"; to: 0.0; duration: 130; easing.type: Easing.InBack }
            }
            SequentialAnimation {
                PauseAnimation { duration: 40 }
                NumberAnimation { target: window; property: "introMain"; to: 0.0; duration: 130; easing.type: Easing.InQuart }
            }
        }
        ScriptAction {
            script: {
                if (window.exitCallback) {
                    let cb = window.exitCallback;
                    window.exitCallback = null;
                    cb();
                }
            }
        }
    }

    function filteredKeybinds() {
        let q = searchQuery.trim().toLowerCase();
        let cat = activeCategory;

        return allKeybinds.filter(item => {
            if (cat !== "all" && item.category !== cat) return false;
            if (!q) return true;

            if (item.title && item.title.toLowerCase().indexOf(q) !== -1) return true;
            if (item.desc && item.desc.toLowerCase().indexOf(q) !== -1) return true;
            if (item.categoryName && item.categoryName.toLowerCase().indexOf(q) !== -1) return true;

            for (let i = 0; i < item.keys.length; i++) {
                let combo = item.keys[i].join(" ").toLowerCase();
                if (combo.indexOf(q) !== -1) return true;
            }
            return false;
        });
    }

    readonly property var currentItems: filteredKeybinds()

    // Main visual frame
    Item {
        anchors.fill: parent
        scale: 0.96 + (0.04 * introMain)
        opacity: introMain
        transform: Translate { y: window.s(15) * (1 - introMain) }

        Rectangle {
            anchors.fill: parent
            radius: ThemeBackend.clampedBorderRadius
            color: Qt.alpha(ThemeBackend.base, Math.min(ThemeBackend.elementOpacity, 0.92))
            border.color: Qt.alpha(ThemeBackend.surface1, 0.6)
            border.width: 1
            clip: true

            WallpaperBlur {
                z: -1
                anchors.fill: parent
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: window.s(20)
                spacing: window.s(16)

                // Header Row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: window.s(14)
                    opacity: introHeader
                    transform: Translate { y: window.s(15) * (1.0 - introHeader) }

                    // Title & Icon badge
                    RowLayout {
                        spacing: window.s(12)

                        Rectangle {
                            width: window.s(42)
                            height: window.s(42)
                            radius: window.s(10)
                            color: Qt.alpha(ThemeBackend.primary, 0.15)
                            border.color: Qt.alpha(ThemeBackend.primary, 0.3)
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "󰌌"
                                color: ThemeBackend.primary
                                font.pixelSize: window.s(22)
                            }
                        }

                        ColumnLayout {
                            spacing: window.s(2)

                            RowLayout {
                                spacing: window.s(8)
                                Text {
                                    text: "Горячие клавиши"
                                    color: ThemeBackend.text
                                    font.family: ThemeBackend.fontFamily
                                    font.pixelSize: window.s(18)
                                    font.weight: Font.Bold
                                }

                                Rectangle {
                                    radius: window.s(4)
                                    color: Qt.alpha(ThemeBackend.primary, 0.18)
                                    implicitWidth: badgeText.implicitWidth + window.s(10)
                                    implicitHeight: window.s(20)

                                    Text {
                                        id: badgeText
                                        anchors.centerIn: parent
                                        text: "Super + /"
                                        color: ThemeBackend.primary
                                        font.pixelSize: window.s(11)
                                        font.weight: Font.DemiBold
                                    }
                                }
                            }

                            Text {
                                text: "Шпаргалка быстрых действий Hyprland & Serpantinum"
                                color: ThemeBackend.subtext0
                                font.family: ThemeBackend.fontFamily
                                font.pixelSize: window.s(11)
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Search input bar
                    Rectangle {
                        implicitWidth: window.s(320)
                        implicitHeight: window.s(38)
                        radius: window.s(10)
                        color: Qt.alpha(ThemeBackend.mantle, 0.85)
                        border.color: searchInput.activeFocus 
                            ? ThemeBackend.primary 
                            : Qt.alpha(ThemeBackend.surface1, 0.7)
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: window.s(12)
                            anchors.rightMargin: window.s(10)
                            spacing: window.s(8)

                            Text {
                                text: "󰍉"
                                color: searchInput.activeFocus ? ThemeBackend.primary : ThemeBackend.subtext0
                                font.pixelSize: window.s(15)
                            }

                            TextInput {
                                id: searchInput
                                Layout.fillWidth: true
                                color: ThemeBackend.text
                                font.family: ThemeBackend.fontFamily
                                font.pixelSize: window.s(13)
                                clip: true

                                onTextChanged: window.searchQuery = text

                                Text {
                                    anchors.fill: parent
                                    visible: !searchInput.text && !searchInput.activeFocus
                                    text: "Поиск клавиш или действия..."
                                    color: Qt.alpha(ThemeBackend.subtext0, 0.6)
                                    font: searchInput.font
                                }
                            }

                            // Clear button
                            Text {
                                visible: !!searchInput.text
                                text: "󰅖"
                                color: ThemeBackend.subtext0
                                font.pixelSize: window.s(14)
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        searchInput.text = "";
                                        searchInput.forceActiveFocus();
                                    }
                                }
                            }
                        }
                    }

                    // Close Button
                    Rectangle {
                        width: window.s(34)
                        height: window.s(34)
                        radius: window.s(8)
                        color: closeMouse.containsMouse ? Qt.alpha(ThemeBackend.red, 0.2) : Qt.alpha(ThemeBackend.surface0, 0.5)
                        border.color: closeMouse.containsMouse ? ThemeBackend.red : Qt.alpha(ThemeBackend.surface1, 0.5)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "󰅖"
                            color: closeMouse.containsMouse ? ThemeBackend.red : ThemeBackend.subtext0
                            font.pixelSize: window.s(15)
                        }

                        MouseArea {
                            id: closeMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: window.closeWindow()
                        }
                    }
                }

                // Category Filter Pills
                RowLayout {
                    Layout.fillWidth: true
                    spacing: window.s(8)
                    opacity: introHeader

                    Repeater {
                        model: window.categories

                        Rectangle {
                            id: tabPill
                            readonly property bool isSelected: window.activeCategory === modelData.id
                            implicitHeight: window.s(30)
                            implicitWidth: pillContent.implicitWidth + window.s(22)
                            radius: window.s(8)

                            color: isSelected 
                                ? Qt.alpha(ThemeBackend.primary, 0.2) 
                                : (tabMouse.containsMouse ? Qt.alpha(ThemeBackend.surface1, 0.5) : Qt.alpha(ThemeBackend.mantle, 0.6))
                            border.color: isSelected 
                                ? ThemeBackend.primary 
                                : Qt.alpha(ThemeBackend.surface1, 0.4)
                            border.width: 1

                            RowLayout {
                                id: pillContent
                                anchors.centerIn: parent
                                spacing: window.s(6)

                                Text {
                                    text: modelData.icon
                                    color: tabPill.isSelected ? ThemeBackend.primary : ThemeBackend.subtext0
                                    font.pixelSize: window.s(13)
                                }

                                Text {
                                    text: modelData.name
                                    color: tabPill.isSelected ? ThemeBackend.primary : ThemeBackend.text
                                    font.family: ThemeBackend.fontFamily
                                    font.pixelSize: window.s(12)
                                    font.weight: tabPill.isSelected ? Font.Bold : Font.Normal
                                }
                            }

                            MouseArea {
                                id: tabMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: window.activeCategory = modelData.id
                            }
                        }
                    }
                }

                // Divider line
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Qt.alpha(ThemeBackend.surface0, 0.8)
                }

                // Keybinds Content Area
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    opacity: introContent

                    // Empty state when search produces 0 matches
                    ColumnLayout {
                        anchors.centerIn: parent
                        visible: window.currentItems.length === 0
                        spacing: window.s(12)

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "󰍉"
                            color: Qt.alpha(ThemeBackend.subtext0, 0.5)
                            font.pixelSize: window.s(48)
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Ничего не найдено"
                            color: ThemeBackend.text
                            font.family: ThemeBackend.fontFamily
                            font.pixelSize: window.s(16)
                            font.weight: Font.Bold
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Попробуйте изменить запрос или выберите другую категорию"
                            color: ThemeBackend.subtext0
                            font.family: ThemeBackend.fontFamily
                            font.pixelSize: window.s(12)
                        }
                    }

                    // Keybinds Scrollable Grid
                    ScrollView {
                        id: keybindsScroll
                        anchors.fill: parent
                        clip: true
                        visible: window.currentItems.length > 0

                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                        GridLayout {
                            id: keybindsGrid
                            width: keybindsScroll.availableWidth
                            columns: 2
                            columnSpacing: window.s(12)
                            rowSpacing: window.s(10)

                            Repeater {
                                model: window.currentItems

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: (keybindsGrid.width - keybindsGrid.columnSpacing) / 2
                                    implicitHeight: cardContent.implicitHeight + window.s(18)
                                    radius: window.s(10)
                                    color: cardHover.containsMouse 
                                        ? Qt.alpha(ThemeBackend.surface0, 0.8) 
                                        : Qt.alpha(ThemeBackend.surface0, 0.45)
                                    border.color: cardHover.containsMouse 
                                        ? Qt.alpha(ThemeBackend.primary, 0.4) 
                                        : Qt.alpha(ThemeBackend.surface1, 0.3)
                                    border.width: 1

                                    MouseArea {
                                        id: cardHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                    }

                                    RowLayout {
                                        id: cardContent
                                        anchors.fill: parent
                                        anchors.leftMargin: window.s(14)
                                        anchors.rightMargin: window.s(14)
                                        spacing: window.s(12)

                                        // Left: Action & Description
                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: window.s(3)

                                            RowLayout {
                                                Layout.fillWidth: true
                                                spacing: window.s(6)
                                                Text {
                                                    text: modelData.categoryIcon
                                                    color: ThemeBackend.primary
                                                    font.pixelSize: window.s(12)
                                                }
                                                Text {
                                                    Layout.fillWidth: true
                                                    text: modelData.title
                                                    color: ThemeBackend.text
                                                    font.family: ThemeBackend.fontFamily
                                                    font.pixelSize: window.s(13)
                                                    font.weight: Font.Bold
                                                    elide: Text.ElideRight
                                                }
                                            }

                                            Text {
                                                Layout.fillWidth: true
                                                text: modelData.desc
                                                color: ThemeBackend.subtext0
                                                font.family: ThemeBackend.fontFamily
                                                font.pixelSize: window.s(11)
                                                elide: Text.ElideRight
                                            }
                                        }

                                        // Right: Key Badges
                                        RowLayout {
                                            spacing: window.s(4)

                                            Repeater {
                                                model: modelData.keys

                                                RowLayout {
                                                    spacing: window.s(4)

                                                    // Separator between alternative combinations
                                                    Text {
                                                        visible: index > 0
                                                        text: "/"
                                                        color: ThemeBackend.subtext0
                                                        font.pixelSize: window.s(11)
                                                    }

                                                    Repeater {
                                                        id: innerKeyRepeater
                                                        model: modelData

                                                        RowLayout {
                                                            spacing: window.s(3)

                                                            KeyBadge {
                                                                keyText: modelData
                                                            }

                                                            Text {
                                                                visible: index < (innerKeyRepeater.count - 1)
                                                                text: "+"
                                                                color: ThemeBackend.subtext1
                                                                font.family: ThemeBackend.fontFamily
                                                                font.pixelSize: window.s(11)
                                                                font.weight: Font.Bold
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

                // Footer Bar
                RowLayout {
                    Layout.fillWidth: true
                    spacing: window.s(12)
                    opacity: introContent

                    RowLayout {
                        spacing: window.s(8)

                        Text {
                            text: "󰌌"
                            color: ThemeBackend.subtext0
                            font.pixelSize: window.s(13)
                        }

                        Text {
                            text: "Подсказка: нажмите [ Esc ] или [ Super + / ] чтобы закрыть окно"
                            color: ThemeBackend.subtext0
                            font.family: ThemeBackend.fontFamily
                            font.pixelSize: window.s(11)
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Показано: " + window.currentItems.length + " из " + window.allKeybinds.length
                        color: ThemeBackend.subtext0
                        font.family: ThemeBackend.fontFamily
                        font.pixelSize: window.s(11)
                        font.weight: Font.DemiBold
                    }
                }
            }
        }
    }
}
