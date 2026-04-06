pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Qt5Compat.GraphicalEffects as GE
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.modules.common.models

Item {
    id: root
    property int screenWidth: 1920
    property int screenHeight: 1080
    
    implicitHeight: background.implicitHeight
    
    readonly property bool inirEverywhere: Appearance.inirEverywhere
    readonly property bool auroraEverywhere: Appearance.auroraEverywhere
    
    readonly property string wallpaperUrl: Wallpapers.effectiveWallpaperUrl
    
    ColorQuantizer {
        id: wallpaperColorQuantizer
        source: root.wallpaperUrl
        depth: 0
        rescaleSize: 10
    }
    
    readonly property color wallpaperDominantColor: (wallpaperColorQuantizer?.colors?.[0] ?? Appearance.colors.colPrimary)
    readonly property QtObject blendedColors: AdaptedMaterialScheme {
        color: ColorUtils.mix(root.wallpaperDominantColor, Appearance.colors.colPrimaryContainer, 0.8) || Appearance.m3colors.m3secondaryContainer
    }

    // Shadow
    StyledRectangularShadow {
        target: background
        visible: !root.inirEverywhere && !root.auroraEverywhere && !Appearance.gameModeMinimal
    }

    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        implicitHeight: flickable.contentHeight + 24
        
        color: root.inirEverywhere ? Appearance.inir.colLayer0
             : root.auroraEverywhere ? ColorUtils.applyAlpha((root.blendedColors?.colLayer0 ?? Appearance.colors.colLayer0), 1)
             : Appearance.colors.colLayer0
        
        radius: root.inirEverywhere ? Appearance.inir.roundingLarge : Appearance.rounding.large
        
        border.width: root.inirEverywhere ? 1 : (root.auroraEverywhere ? 1 : 1)
        border.color: root.inirEverywhere ? Appearance.inir.colBorder 
                    : root.auroraEverywhere ? Appearance.aurora.colTooltipBorder 
                    : Appearance.colors.colLayer0Border
        
        clip: true

        layer.enabled: root.auroraEverywhere && !root.inirEverywhere && !Appearance.gameModeMinimal
        layer.effect: GE.OpacityMask {
            maskSource: Rectangle {
                width: background.width
                height: background.height
                radius: background.radius
            }
        }

        // Aurora blurred wallpaper
        Image {
            id: blurredWallpaper
            anchors.centerIn: parent
            width: root.screenWidth
            height: root.screenHeight
            visible: root.auroraEverywhere && !root.inirEverywhere && !Appearance.gameModeMinimal
            source: root.wallpaperUrl
            fillMode: Image.PreserveAspectCrop
            cache: true
            asynchronous: true

            layer.enabled: Appearance.effectsEnabled
            layer.effect: StyledBlurEffect {
                source: blurredWallpaper
            }

            Rectangle {
                anchors.fill: parent
                color: ColorUtils.transparentize((root.blendedColors?.colLayer0 ?? Appearance.colors.colLayer0Base), Appearance.aurora.overlayTransparentize)
            }
        }

        // Content
        Flickable {
            id: flickable
            anchors.fill: parent
            anchors.margins: 12
            clip: true
            contentWidth: width
            contentHeight: contentLayout.implicitHeight
            boundsBehavior: Flickable.StopAtBounds
            flickDeceleration: 3000

            ColumnLayout {
                id: contentLayout
                width: flickable.width
                spacing: 10

                // Header with User Profile
                ProfileHeader {}

                // Date/Time header
                DateTimeHeader {}

                // Weather Section
                WeatherSection {}

                // Media Section
                MediaSection {}

                // Wallpaper Section
                WallpaperSection {}

                // System Info Section  
                SystemSection {}

                // Volume & Brightness Sliders
                SlidersSection {}

                // Quick actions
                QuickActionsSection {}

                Item { Layout.preferredHeight: 8 }
            }

            WheelHandler {
                onWheel: (event) => {
                    const delta = event.angleDelta.y / 3
                    flickable.contentY = Math.max(0, Math.min(
                        flickable.contentHeight - flickable.height,
                        flickable.contentY - delta
                    ))
                }
            }
        }
    }
}
