import QtQuick
import QtQuick.Effects
import qs.modules.common

RectangularShadow {
    required property var target
    visible: Appearance.effectsEnabled
    anchors.fill: target
    radius: (target && target.radius !== undefined) ? Number(target.radius) : 0
    blur: (Appearance.sizes && Appearance.sizes.elevationMargin !== undefined) ? (0.9 * Number(Appearance.sizes.elevationMargin)) : 0
    offset: Qt.vector2d(0.0, 1.0)
    spread: 1
    color: Appearance.colors.colShadow
    cached: true
}
