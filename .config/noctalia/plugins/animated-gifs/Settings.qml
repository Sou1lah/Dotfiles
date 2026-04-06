import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets
import qs.Services.UI

ColumnLayout {
    id: root
    spacing: Style.marginL

    property var pluginApi: null
    property var gifs: []
    
    property string inputName: ""
    property string inputUrl: ""
    property bool downloading: false
    property string statusMsg: ""

    // Reload GIFs from settings
    function reloadGifs() {
        var raw = pluginApi?.pluginSettings?.gifs
        if (raw) {
            gifs = JSON.parse(JSON.stringify(raw))
        } else {
            gifs = []
        }
    }

    // Save settings
    function saveSettings() {
        if (!pluginApi) return
        pluginApi.pluginSettings.gifs = gifs
        pluginApi.saveSettings()
    }

    // Add new GIF
    function addGif() {
        var name = inputName.trim()
        var url = inputUrl.trim()
        
        if (!name || !url) {
            statusMsg = "Ingresa nombre y URL"
            return
        }
        
        var id = Date.now().toString()
        var filename = id + ".gif"
        var path = pluginApi.pluginDir + "/gifs/" + filename
        
        var newGif = {
            id: id,
            name: name,
            url: url,
            filename: filename,
            active: false,
            downloaded: false
        }
        
        gifs.push(newGif)
        saveSettings()
        reloadGifs()
        
        inputName = ""
        inputUrl = ""
        downloading = true
        statusMsg = "Descargando..."
        
        downloadProc.gifId = id
        downloadProc.command = ["curl", "-L", "-o", path, url]
        downloadProc.running = true
    }

    // Toggle active state
    function toggleActive(index) {
        if (index < 0 || index >= gifs.length) return
        gifs[index].active = !gifs[index].active
        saveSettings()
        reloadGifs()
        
        var name = gifs[index].name
        if (gifs[index].active) {
            ToastService.showNotice(name + " activado")
        } else {
            ToastService.showNotice(name + " desactivado")
        }
    }

    // Delete GIF
    function deleteGif(index) {
        if (index < 0 || index >= gifs.length) return
        
        var gif = gifs[index]
        var path = pluginApi.pluginDir + "/gifs/" + gif.filename
        
        gifs.splice(index, 1)
        saveSettings()
        reloadGifs()
        
        deleteProc.command = ["rm", "-f", path]
        deleteProc.running = true
        
        ToastService.showNotice(gif.name + " eliminado")
    }

    // Processes
    Process {
        id: mkdirProc
        running: false
    }

    Process {
        id: downloadProc
        property string gifId: ""
        running: false
        onExited: function(code) {
            downloading = false
            
            if (code === 0) {
                // Mark as downloaded
                for (var i = 0; i < gifs.length; i++) {
                    if (gifs[i].id === gifId) {
                        gifs[i].downloaded = true
                        break
                    }
                }
                saveSettings()
                reloadGifs()
                statusMsg = "✓ Descargado"
                ToastService.showNotice("GIF agregado")
            } else {
                // Remove failed download
                for (var i = 0; i < gifs.length; i++) {
                    if (gifs[i].id === gifId) {
                        gifs.splice(i, 1)
                        break
                    }
                }
                saveSettings()
                reloadGifs()
                statusMsg = "✗ Error al descargar"
            }
        }
    }

    Process {
        id: deleteProc
        running: false
    }

    Component.onCompleted: {
        if (!pluginApi.pluginSettings.gifs) {
            pluginApi.pluginSettings.gifs = []
        }
        mkdirProc.command = ["mkdir", "-p", pluginApi.pluginDir + "/gifs"]
        mkdirProc.running = true
        reloadGifs()
    }

    // ══════════════════════════════════════════════════════════════════════
    // UI
    // ══════════════════════════════════════════════════════════════════════

    NText {
        text: "GIF Widget"
        pointSize: Style.fontSizeL
        font.weight: Font.Bold
        color: Color.mOnSurface
    }

    NText {
        text: "Agrega GIFs, actívalos con el checkbox, luego agrega widgets al escritorio"
        pointSize: Style.fontSizeS
        color: Color.mOnSurface
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    NDivider { Layout.fillWidth: true }

    // Add GIF
    NText {
        text: "Agregar GIF"
        pointSize: Style.fontSizeM
        font.weight: Font.DemiBold
        color: Color.mOnSurface
    }

    NTextInput {
        Layout.fillWidth: true
        label: "Nombre"
        placeholderText: "Ej. Gato bailando"
        text: root.inputName
        onTextChanged: root.inputName = text
        enabled: !root.downloading
    }

    NTextInput {
        Layout.fillWidth: true
        label: "URL del GIF"
        description: "URL directa terminada en .gif"
        placeholderText: "https://..."
        text: root.inputUrl
        onTextChanged: root.inputUrl = text
        enabled: !root.downloading
    }

    RowLayout {
        Layout.fillWidth: true
        
        NText {
            text: root.statusMsg
            pointSize: Style.fontSizeS
            color: Color.mOnSurface
            Layout.fillWidth: true
            visible: root.statusMsg !== ""
        }
        
        Item { Layout.fillWidth: true; visible: root.statusMsg === "" }
        
        NButton {
            text: root.downloading ? "Descargando..." : "Agregar"
            enabled: !root.downloading && root.inputName !== "" && root.inputUrl !== ""
            onClicked: root.addGif()
        }
    }

    NDivider { Layout.fillWidth: true }

    // GIF List
    NText {
        text: "GIFs (" + root.gifs.length + ")"
        pointSize: Style.fontSizeM
        font.weight: Font.DemiBold
        color: Color.mOnSurface
    }

    NText {
        visible: root.gifs.length === 0
        text: "No hay GIFs todavía"
        pointSize: Style.fontSizeS
        color: Color.mOnSurface
        opacity: 0.4
    }

    Repeater {
        model: root.gifs

        RowLayout {
            required property int index
            property var gif: root.gifs[index]

            Layout.fillWidth: true
            spacing: Style.marginM

            // Checkbox
            CheckBox {
                checked: gif.active || false
                enabled: gif.downloaded || false
                onToggled: root.toggleActive(index)
                
                indicator: Rectangle {
                    width: 20
                    height: 20
                    radius: 4
                    border.color: Color.mPrimary
                    border.width: 2
                    color: "transparent"
                    
                    Rectangle {
                        width: 12
                        height: 12
                        anchors.centerIn: parent
                        radius: 2
                        color: Color.mPrimary
                        visible: parent.parent.checked
                    }
                }
            }

            // Preview thumbnail
            Rectangle {
                width: 64
                height: 48
                radius: Style.radiusS
                color: Qt.rgba(0, 0, 0, 0.25)
                clip: true
                
                AnimatedImage {
                    anchors.fill: parent
                    source: gif.downloaded 
                            ? Qt.resolvedUrl("file://" + pluginApi.pluginDir + "/gifs/" + gif.filename)
                            : ""
                    fillMode: Image.PreserveAspectCrop
                    playing: true
                    smooth: true
                    cache: false
                    visible: gif.downloaded && status === AnimatedImage.Ready
                }
                
                NIcon {
                    anchors.centerIn: parent
                    icon: gif.downloaded ? "photo" : "clock"
                    color: Color.mOnSurface
                    opacity: 0.35
                    visible: !gif.downloaded || parent.children[0].status !== AnimatedImage.Ready
                }
            }

            // Name + status
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                NText {
                    Layout.fillWidth: true
                    text: gif.name
                    pointSize: Style.fontSizeS
                    color: Color.mOnSurface
                    font.weight: gif.active ? Font.DemiBold : Font.Normal
                    elide: Text.ElideRight
                }

                RowLayout {
                    spacing: Style.marginS
                    
                    Rectangle {
                        visible: gif.active && gif.downloaded
                        width: lblActive.implicitWidth + 8
                        height: lblActive.implicitHeight + 4
                        radius: height / 2
                        color: Color.mPrimary
                        
                        NText {
                            id: lblActive
                            anchors.centerIn: parent
                            text: "ACTIVO"
                            color: "#fff"
                            pointSize: Style.fontSizeXS
                            font.weight: Font.Bold
                        }
                    }
                    
                    Rectangle {
                        visible: !gif.downloaded
                        width: lblDl.implicitWidth + 8
                        height: lblDl.implicitHeight + 4
                        radius: height / 2
                        color: Qt.rgba(1, 1, 1, 0.1)
                        
                        NText {
                            id: lblDl
                            anchors.centerIn: parent
                            text: "DESCARGANDO..."
                            color: Color.mOnSurface
                            opacity: 0.55
                            pointSize: Style.fontSizeXS
                        }
                    }
                }
            }

            // Delete
            NButton {
                text: "Eliminar"
                onClicked: root.deleteGif(index)
            }
        }
    }

    Item { Layout.fillHeight: true }
}
