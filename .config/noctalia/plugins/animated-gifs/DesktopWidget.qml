import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.Commons
import qs.Widgets
import qs.Modules.DesktopWidgets

DraggableDesktopWidget {
    id: root

    // Injected by Noctalia
    property var pluginApi: null

    // Default size - user can resize
    implicitWidth: Math.round(300 * widgetScale)
    implicitHeight: Math.round(300 * widgetScale)

    // No background
    showBackground: false

    // Initialize widgetData
    Component.onCompleted: {
        if (!widgetData) {
            widgetData = {}
        }
    }

    // All GIFs from settings
    property var allGifs: {
        try {
            return pluginApi?.pluginSettings?.gifs ?? []
        } catch (e) {
            return []
        }
    }

    // Active GIFs only
    property var activeGifs: {
        var active = []
        try {
            for (var i = 0; i < allGifs.length; i++) {
                var g = allGifs[i]
                if (g && g.active && g.downloaded) {
                    active.push(g)
                }
            }
        } catch (e) {
            console.log("GIF Widget: Error getting active GIFs:", e)
        }
        return active
    }

    // Current GIF based on widgetIndex
    property var currentGif: {
        try {
            if (activeGifs.length === 0) return null
            
            // Use widgetIndex to pick a GIF
            var index = widgetIndex % activeGifs.length
            console.log("GIF Widget [" + widgetIndex + "]: Using GIF", index, "→", activeGifs[index]?.name || "")
            
            return activeGifs[index]
        } catch (e) {
            console.log("GIF Widget: Error getting current GIF:", e)
            return null
        }
    }

    // GIF file path
    property string gifPath: {
        try {
            if (!currentGif) return ""
            if (!pluginApi || !pluginApi.pluginDir) return ""
            if (!currentGif.filename) return ""
            return pluginApi.pluginDir + "/gifs/" + currentGif.filename
        } catch (e) {
            console.log("GIF Widget: Error getting path:", e)
            return ""
        }
    }

    // Encoded URL
    property string gifUrl: {
        try {
            if (!gifPath || gifPath === "") return ""
            return Qt.resolvedUrl("file://" + gifPath)
        } catch (e) {
            console.log("GIF Widget: Error encoding URL:", e)
            return ""
        }
    }

    // Check if GIF is ready to show
    property bool gifReady: gifDisplay.status === AnimatedImage.Ready && !root.isEditing && currentGif !== null

    // Scaled values
    readonly property int scaledRadius: Math.round(Style.radiusM * widgetScale)
    readonly property int scaledMargin: Math.round(16 * widgetScale)
    readonly property int scaledIconSize: Math.round(48 * widgetScale)

    // ══════════════════════════════════════════════════════════════════════
    // Display
    // ══════════════════════════════════════════════════════════════════════

    // GIF Display - SOLO visible cuando está listo
    AnimatedImage {
        id: gifDisplay
        anchors.fill: parent
        source: root.gifUrl
        fillMode: AnimatedImage.PreserveAspectFit
        playing: true
        smooth: true
        cache: false
        asynchronous: true
        visible: root.gifReady
        
        onStatusChanged: {
            if (status === AnimatedImage.Ready) {
                console.log("GIF Widget [" + widgetIndex + "]: ✓ Loaded:", currentGif?.name || "")
            } else if (status === AnimatedImage.Error) {
                console.log("GIF Widget [" + widgetIndex + "]: ✗ Failed to load")
            }
        }
    }

    // Overlay - SOLO visible cuando el GIF NO está listo
    Rectangle {
        anchors.fill: parent
        visible: !root.gifReady
        color: Qt.rgba(0.1, 0.1, 0.15, 0.95)
        radius: scaledRadius

        ColumnLayout {
            anchors.centerIn: parent
            anchors.margins: scaledMargin
            spacing: Math.round(12 * widgetScale)
            width: Math.min(parent.width - scaledMargin * 2, Math.round(300 * widgetScale))

            // Icon
            NIcon {
                icon: "photo"
                color: Color.mPrimary
                Layout.alignment: Qt.AlignHCenter
                width: scaledIconSize
                height: scaledIconSize
            }

            // Widget info (only in edit mode)
            NText {
                visible: root.isEditing && currentGif !== null
                Layout.fillWidth: true
                text: "Widget #" + (widgetIndex + 1) + "\n" + (currentGif?.name || "")
                color: Color.mOnSurface
                opacity: 0.9
                pointSize: Math.round(Style.fontSizeS * widgetScale)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.weight: Font.DemiBold
            }

            // No active GIFs message
            NText {
                visible: root.activeGifs.length === 0
                Layout.fillWidth: true
                text: "No hay GIFs activos\nActiva GIFs en Configuración"
                color: Color.mOnSurface
                opacity: 0.7
                pointSize: Math.round(Style.fontSizeS * widgetScale)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            // Loading message
            NText {
                visible: !root.isEditing && currentGif !== null && gifDisplay.status === AnimatedImage.Loading
                Layout.fillWidth: true
                text: "Cargando GIF..."
                color: Color.mOnSurface
                opacity: 0.6
                pointSize: Math.round(Style.fontSizeS * widgetScale)
                horizontalAlignment: Text.AlignHCenter
            }

            // Error message
            NText {
                visible: !root.isEditing && currentGif !== null && gifDisplay.status === AnimatedImage.Error
                Layout.fillWidth: true
                text: "Error al cargar\nVerifica el archivo"
                color: "#e05555"
                opacity: 0.9
                pointSize: Math.round(Style.fontSizeS * widgetScale)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
        }
    }
}
