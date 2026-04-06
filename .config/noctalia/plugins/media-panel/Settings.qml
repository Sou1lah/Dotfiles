import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  
  property var pluginApi: null
  
  property string valueGifUrl: pluginApi?.pluginSettings?.gifUrl || "https://media.tenor.com/JtofR661NDIAAAAi/honkai-star-rail-hsr.gif"
  property bool isDownloading: false
  property string statusText: ""
  property bool statusError: false
  
  readonly property string gifStoragePath: {
    const urlStr = Qt.resolvedUrl(".").toString()
    const dir = urlStr.replace("file://", "")
    return dir + "custom-media-gif.gif"
  }
  
  spacing: Style.marginM
  
  Timer {
    id: clearTimer
    interval: 3000
    onTriggered: {
      root.statusText = ""
      root.statusError = false
    }
  }

  NLabel {
    label: "Media Panel"
    description: "Personaliza el GIF animado del reproductor"
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS

    NLabel {
      label: "URL del GIF"
      description: "URL directa del GIF animado"
    }

    NTextInput {
      id: gifInput
      Layout.fillWidth: true
      text: root.valueGifUrl
      placeholderText: "https://..."
      Keys.onReturnPressed: saveBtnArea.clicked()
      onTextChanged: root.valueGifUrl = text
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: Style.marginS

      Rectangle {
        id: saveBtn
        Layout.fillWidth: true
        Layout.preferredHeight: 36
        radius: Style.radiusM
        color: saveBtnArea.containsMouse 
          ? Qt.lighter(Color.mPrimary, 1.1)
          : Color.mPrimary
        enabled: !root.isDownloading
        opacity: enabled ? 1.0 : 0.5
        
        Behavior on color { ColorAnimation { duration: 150 } }
        
        Text {
          anchors.centerIn: parent
          text: root.isDownloading ? "Descargando..." : "Guardar GIF"
          font.pointSize: Style.fontSizeM
          color: Color.mOnPrimary
        }
        
        MouseArea {
          id: saveBtnArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          enabled: parent.enabled
          
          onClicked: {
            const url = root.valueGifUrl.trim()
            if (url && !root.isDownloading) {
              root.isDownloading = true
              root.statusText = "Descargando GIF..."
              root.statusError = false
              
              downloadProc.command = ["curl", "-L", "-s", "-o", root.gifStoragePath, url]
              downloadProc.running = true
            }
          }
        }
      }

      Rectangle {
        Layout.preferredWidth: 36
        Layout.preferredHeight: 36
        radius: Style.radiusM
        color: reloadArea.containsMouse ? Color.mHover : Color.mSurfaceVariant
        border.color: Color.mOutline
        border.width: 1
        
        Behavior on color { ColorAnimation { duration: 150 } }
        
        Canvas {
          anchors.fill: parent
          anchors.margins: 6
          
          onPaint: {
            const ctx = getContext("2d")
            if (!ctx) return
            
            ctx.clearRect(0, 0, width, height)
            
            const centerX = width / 2
            const centerY = height / 2
            const radius = Math.min(width, height) / 2 - 2
            
            ctx.strokeStyle = Color.mPrimary || "#6200EE"
            ctx.lineWidth = 2
            ctx.lineCap = "round"
            
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, 0.3, 2 * Math.PI - 0.3)
            ctx.stroke()
            
            const arrowSize = 4
            const arrowAngle = -0.3
            const arrowX = centerX + Math.cos(arrowAngle) * radius
            const arrowY = centerY + Math.sin(arrowAngle) * radius
            
            ctx.beginPath()
            ctx.moveTo(arrowX, arrowY)
            ctx.lineTo(arrowX + arrowSize, arrowY - arrowSize)
            ctx.moveTo(arrowX, arrowY)
            ctx.lineTo(arrowX + arrowSize, arrowY + arrowSize)
            ctx.stroke()
          }
        }
        
        MouseArea {
          id: reloadArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          
          onClicked: {
            root.statusText = "⟳ Recargando GIF..."
            root.statusError = false
            clearTimer.start()
            triggerReload()
          }
        }
      }
    }

    NText {
      visible: root.statusText !== ""
      Layout.fillWidth: true
      text: root.statusText
      font.pointSize: Style.fontSizeS
      color: root.statusError ? Color.mError : Color.mPrimary
      horizontalAlignment: Text.AlignHCenter
    }
  }

  Item { Layout.fillHeight: true }
  
  Process {
    id: downloadProc
    onExited: (code) => {
      root.isDownloading = false
      if (code === 0) {
        root.statusText = "✓ GIF guardado y recargado"
        root.statusError = false
        saveSettings()
        
        Qt.callLater(triggerReload)
      } else {
        root.statusText = "⚠️ Error al descargar"
        root.statusError = true
      }
      clearTimer.start()
    }
  }
  
  function saveSettings() {
    if (!pluginApi) return
    pluginApi.pluginSettings.gifUrl = root.valueGifUrl
    pluginApi.saveSettings()
  }
  
  function triggerReload() {
    if (!pluginApi) return
    const currentTrigger = pluginApi.pluginSettings.gifReloadTrigger || 0
    pluginApi.pluginSettings.gifReloadTrigger = currentTrigger + 1
    pluginApi.saveSettings()
  }
}
