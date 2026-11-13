import QtQuick
import QtQuick.Layouts
import "../"

Rectangle {
    id: root

    property string keyText: ""
    readonly property bool isModifier: keyText === "SUPER" || keyText === "CTRL" || keyText === "SHIFT" || keyText === "ALT" || keyText === "Fn"

    implicitWidth: Math.max(Scaler.s(24), label.implicitWidth + Scaler.s(14))
    implicitHeight: Scaler.s(26)
    radius: Scaler.s(6)

    color: isModifier 
        ? Qt.alpha(ThemeBackend.surface1, 0.75) 
        : Qt.alpha(ThemeBackend.mantle, 0.90)

    border.color: isModifier 
        ? Qt.alpha(ThemeBackend.primary, 0.45) 
        : Qt.alpha(ThemeBackend.surface2, 0.55)
    border.width: 1

    // 3D tactile keycap shadow/highlight
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: Scaler.s(1)
        anchors.rightMargin: Scaler.s(1)
        height: Scaler.s(2)
        radius: Scaler.s(5)
        color: Qt.alpha(ThemeBackend.crust, 0.5)
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: root.keyText
        color: isModifier ? ThemeBackend.primary : ThemeBackend.text
        font.family: ThemeBackend.fontFamily || "monospace"
        font.pixelSize: Scaler.s(11)
        font.weight: isModifier ? Font.Bold : Font.DemiBold
    }
}
