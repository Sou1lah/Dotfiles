pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

Rectangle {
    id: root
    Layout.fillWidth: true
    implicitHeight: visible ? weatherRow.implicitHeight + 16 : 0
    visible: Weather.enabled && Weather.data.temp && !Weather.data.temp.startsWith("--")
    
    readonly property bool inirEverywhere: Appearance.inirEverywhere
    readonly property bool auroraEverywhere: Appearance.auroraEverywhere

    radius: inirEverywhere ? Appearance.inir.roundingNormal : Appearance.rounding.normal
    color: inirEverywhere ? Appearance.inir.colLayer1
         : auroraEverywhere ? Appearance.aurora.colSubSurface
         : Appearance.colors.colLayer1
    border.width: inirEverywhere ? 1 : 0
    border.color: inirEverywhere ? Appearance.inir.colBorder : "transparent"

    RowLayout {
        id: weatherRow
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10

        MaterialSymbol {
            text: Icons.getWeatherIcon(Weather.data.wCode, Weather.isNightNow()) ?? "cloud"
            iconSize: 32
            color: root.inirEverywhere ? Appearance.inir.colPrimary
                 : root.auroraEverywhere ? Appearance.m3colors.m3primary
                 : Appearance.colors.colPrimary
        }

        StyledText {
            text: Weather.data.temp
            font.pixelSize: Appearance.font.pixelSize.huge
            font.weight: Font.Medium
            font.family: Appearance.font.family.numbers
            color: root.inirEverywhere ? Appearance.inir.colText
                 : root.auroraEverywhere ? Appearance.m3colors.m3onSurface
                 : Appearance.colors.colOnLayer1
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                text: Weather.data.description || ""
                font.pixelSize: Appearance.font.pixelSize.small
                color: root.inirEverywhere ? Appearance.inir.colText
                     : root.auroraEverywhere ? Appearance.m3colors.m3onSurface
                     : Appearance.colors.colOnLayer1
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            StyledText {
                text: Weather.data.city
                font.pixelSize: Appearance.font.pixelSize.smallest
                color: root.inirEverywhere ? Appearance.inir.colTextSecondary
                     : root.auroraEverywhere ? Appearance.m3colors.m3onSurfaceVariant
                     : Appearance.colors.colSubtext
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        RippleButton {
            implicitWidth: 28
            implicitHeight: 28
            buttonRadius: root.inirEverywhere ? Appearance.inir.roundingSmall : Appearance.rounding.full
            colBackground: "transparent"
            colBackgroundHover: root.inirEverywhere ? Appearance.inir.colLayer2Hover 
                : root.auroraEverywhere ? Appearance.aurora.colSubSurfaceHover
                : Appearance.colors.colLayer2Hover
            onClicked: Weather.fetchWeather()
            contentItem: MaterialSymbol {
                anchors.centerIn: parent
                text: "refresh"
                iconSize: 16
                color: root.inirEverywhere ? Appearance.inir.colTextSecondary
                     : root.auroraEverywhere ? Appearance.m3colors.m3onSurfaceVariant
                     : Appearance.colors.colSubtext
            }
            StyledToolTip { text: Translation.tr("Refresh") }
        }
    }
}
