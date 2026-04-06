pragma ComponentBehavior: Bound

import qs
import qs.modules.common
import QtQuick
import QtQuick.Effects
import QtMultimedia
import Qt5Compat.GraphicalEffects as GE
import Quickshell
import Quickshell.Wayland

Variants {
    id: root
    // Only create backdrop windows if enabled
    model: (Config.options?.waffles?.background?.backdrop?.enable ?? true) ? Quickshell.screens : []

    PanelWindow {
        id: backdropWindow
        required property var modelData

        screen: modelData

        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.namespace: "quickshell:wBackdrop"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true

        color: "transparent"

        // Waffle backdrop config
        readonly property var wBackdrop: Config.options?.waffles?.background?.backdrop ?? {}
        
        readonly property int backdropBlurRadius: wBackdrop.blurRadius ?? 32
        readonly property int backdropDim: wBackdrop.dim ?? 35
        readonly property real backdropSaturation: (wBackdrop.saturation ?? 0) / 100.0
        readonly property real backdropContrast: (wBackdrop.contrast ?? 0) / 100.0
        readonly property bool vignetteEnabled: wBackdrop.vignetteEnabled ?? false
        readonly property real vignetteIntensity: wBackdrop.vignetteIntensity ?? 0.5
        readonly property real vignetteRadius: wBackdrop.vignetteRadius ?? 0.7
        readonly property bool enableAnimation: wBackdrop.enableAnimation ?? false

        // Raw wallpaper path (before thumbnail substitution)
        readonly property string wallpaperPathRaw: {
            const useBackdropOwn = !(wBackdrop.useMainWallpaper ?? true);
            if (useBackdropOwn && wBackdrop.wallpaperPath) {
                return wBackdrop.wallpaperPath;
            }
            const wBg = Config.options?.waffles?.background ?? {};
            if (wBg.useMainWallpaper ?? true) {
                return Config.options?.background?.wallpaperPath ?? "";
            }
            return wBg.wallpaperPath ?? "";
        }
        
        readonly property bool wallpaperIsVideo: {
            const lowerPath = wallpaperPathRaw.toLowerCase();
            return lowerPath.endsWith(".mp4") || lowerPath.endsWith(".webm") || lowerPath.endsWith(".mkv") || lowerPath.endsWith(".avi") || lowerPath.endsWith(".mov");
        }
        
        readonly property bool wallpaperIsGif: {
            return wallpaperPathRaw.toLowerCase().endsWith(".gif");
        }

        // Effective path: returns thumbnail if animation is disabled, otherwise raw path
        readonly property string effectiveWallpaperPath: {
            const selectedPath = wallpaperPathRaw;
            
            // If animation is enabled, use raw path for videos/GIFs
            if (backdropWindow.enableAnimation && (backdropWindow.wallpaperIsVideo || backdropWindow.wallpaperIsGif)) {
                return selectedPath;
            }
            
            // If animation is disabled, use thumbnail for videos/GIFs
            if (backdropWindow.wallpaperIsVideo || backdropWindow.wallpaperIsGif) {
                // Priority: material ii thumbnail (actual frame) > backdrop thumbnail > waffle background thumbnail > fallback to video
                const mainThumbnail = Config.options?.background?.thumbnailPath ?? "";
                if (mainThumbnail) return mainThumbnail;
                
                const backdropThumbnail = wBackdrop.thumbnailPath ?? "";
                if (backdropThumbnail) return backdropThumbnail;
                
                const wBg = Config.options?.waffles?.background ?? {};
                const waffleThumbnail = wBg.thumbnailPath ?? "";
                if (waffleThumbnail) return waffleThumbnail;
                
                // Fallback: return video path (will show as broken/icon)
                return selectedPath;
            }
            
            return selectedPath;
        }

        // Build proper file:// URL
        readonly property string wallpaperUrl: {
            const path = effectiveWallpaperPath;
            if (!path) return "";
            if (path.startsWith("file://")) return path;
            return "file://" + path;
        }

        Item {
            anchors.fill: parent

            // Static Image (for non-animated wallpapers)
            Image {
                id: wallpaper
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: backdropWindow.wallpaperUrl && !backdropWindow.wallpaperIsGif && !(backdropWindow.enableAnimation && backdropWindow.wallpaperIsVideo)
                    ? backdropWindow.wallpaperUrl
                    : ""
                asynchronous: true
                cache: true
                visible: !backdropWindow.wallpaperIsGif && !(backdropWindow.enableAnimation && backdropWindow.wallpaperIsVideo)
            }
            
            // Animated GIF support (when enableAnimation is true)
            AnimatedImage {
                id: gifWallpaper
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: backdropWindow.enableAnimation && backdropWindow.wallpaperIsGif ? backdropWindow.wallpaperUrl : ""
                asynchronous: true
                cache: true
                visible: backdropWindow.enableAnimation && backdropWindow.wallpaperIsGif
                playing: visible
            }

            // Video wallpaper support (when enableAnimation is true)
            Video {
                id: videoWallpaper
                anchors.fill: parent
                visible: backdropWindow.enableAnimation && backdropWindow.wallpaperIsVideo
                source: {
                    if (!backdropWindow.enableAnimation || !backdropWindow.wallpaperIsVideo) return "";
                    const url = backdropWindow.wallpaperUrl;
                    if (!url) return "";
                    return url.startsWith("file://") ? url : ("file://" + url);
                }
                fillMode: VideoOutput.PreserveAspectCrop
                loops: MediaPlayer.Infinite
                muted: true
                autoPlay: true
                
                onPlaybackStateChanged: {
                    if (playbackState === MediaPlayer.StoppedState && visible && backdropWindow.enableAnimation && backdropWindow.wallpaperIsVideo) {
                        play()
                    }
                }
                
                onVisibleChanged: {
                    if (visible && backdropWindow.enableAnimation && backdropWindow.wallpaperIsVideo) {
                        play()
                    } else {
                        pause()
                    }
                }
            }

            // Blur effect (disabled for videos and GIFs for performance)
            MultiEffect {
                anchors.fill: parent
                source: wallpaper
                visible: wallpaper.status === Image.Ready && !backdropWindow.wallpaperIsGif && !(backdropWindow.enableAnimation && backdropWindow.wallpaperIsVideo)
                blurEnabled: backdropWindow.backdropBlurRadius > 0
                blur: backdropWindow.backdropBlurRadius / 100.0
                blurMax: 64
                saturation: backdropWindow.backdropSaturation
                contrast: backdropWindow.backdropContrast
            }

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: backdropWindow.backdropDim / 100.0
            }

            // Vignette effect
            Rectangle {
                anchors.fill: parent
                visible: backdropWindow.vignetteEnabled
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: backdropWindow.vignetteRadius; color: "transparent" }
                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, backdropWindow.vignetteIntensity) }
                }
            }
        }
    }
}
