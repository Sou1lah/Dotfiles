import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Services.Media
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  readonly property var geometryPlaceholder: panelContainer

  property real contentPreferredWidth: 700 * Style.uiScaleRatio
  property real contentPreferredHeight: 280 * Style.uiScaleRatio
  readonly property bool allowAttach: true

  readonly property bool hasPlayer: MediaService.currentPlayer !== null
  readonly property bool isPlaying: MediaService.isPlaying
  
  property string localGifPath: ""
  
  property int gifReloadTrigger: pluginApi?.pluginSettings?.gifReloadTrigger ?? 0
  
  readonly property string gifStoragePath: {
    const pluginDir = Qt.resolvedUrl(".").toString().replace("file://", "")
    return pluginDir + "custom-media-gif.gif"
  }

  anchors.fill: parent

  function lengthStr(lengthSeconds) {
      if (!lengthSeconds || lengthSeconds <= 0) return "0:00";
      const length = Math.floor(lengthSeconds);
      const hours = Math.floor(length / 3600);
      const mins = Math.floor((length % 3600) / 60);
      const secs = Math.floor(length % 60).toString().padStart(2, "0");
      if (hours > 0)
          return `${hours}:${mins.toString().padStart(2, "0")}:${secs}`;
      return `${mins}:${secs}`;
  }

  function reloadGif() {
    console.log("Recargando GIF...")
    gifImage.cache = false
    gifImage.source = ""
    
    // Delay para asegurar que se limpia
    Qt.callLater(function() {
      checkFileProcess.running = true
    })
  }
  
  Process {
    id: checkFileProcess
    command: ["test", "-f", root.gifStoragePath]
    running: false
    
    onExited: (exitCode) => {
      if (exitCode === 0) {
        console.log("GIF encontrado en:", root.gifStoragePath)
        root.localGifPath = "file://" + root.gifStoragePath
        gifImage.source = root.localGifPath
        gifImage.cache = true
      } else {
        console.log("No hay GIF descargado")
        root.localGifPath = ""
      }
    }
  }

  Component.onCompleted: {
    checkFileProcess.running = true
  }
  
  onGifReloadTriggerChanged: {
    if (gifReloadTrigger > 0) {
      console.log("Trigger de recarga:", gifReloadTrigger)
      reloadGif()
    }
  }

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    Rectangle {
      anchors.fill: parent
      anchors.margins: Style.marginL
      color: Color.mSurface
      radius: Style.radiusL
      border.color: Color.mOutline
      border.width: Style.borderS

      RowLayout {
        anchors.fill: parent
        anchors.margins: Style.marginL
        spacing: Style.marginXL

        // Artwork rectangular
        Item {
          Layout.preferredWidth: 140 * Style.uiScaleRatio
          Layout.preferredHeight: 140 * Style.uiScaleRatio
          Layout.alignment: Qt.AlignVCenter

          Rectangle {
            id: artworkBackground
            anchors.centerIn: parent
            width: 130 * Style.uiScaleRatio
            height: 130 * Style.uiScaleRatio
            radius: Style.radiusL
            color: Color.mSurfaceVariant || "#2B2930"
            border.color: isPlaying ? (Color.mPrimary || "#6200EE") : (Color.mOutline || "#938F99")
            border.width: 3
            
            Behavior on border.color { ColorAnimation { duration: 300 } }
            
            NIcon {
              anchors.centerIn: parent
              icon: "disc"
              pointSize: 48 * Style.uiScaleRatio
              color: Color.mOnSurfaceVariant || "#CAC4D0"
            }
          }

          Rectangle {
            visible: hasPlayer && MediaService.trackArtUrl !== ""
            anchors.centerIn: parent
            width: 130 * Style.uiScaleRatio
            height: 130 * Style.uiScaleRatio
            radius: Style.radiusL
            color: "transparent"
            border.color: isPlaying ? (Color.mPrimary || "#6200EE") : (Color.mOutline || "#938F99")
            border.width: 3
            clip: true
            
            Behavior on border.color { ColorAnimation { duration: 300 } }
            
            Image {
              id: artworkImage
              anchors.fill: parent
              anchors.margins: 3
              source: MediaService.trackArtUrl
              fillMode: Image.PreserveAspectCrop
              sourceSize.width: 256
              sourceSize.height: 256
              smooth: true
              asynchronous: true
              cache: true
            }
          }
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: Style.marginM

          NText {
            Layout.fillWidth: true
            text: hasPlayer ? MediaService.trackTitle : "No hay música"
            font.pointSize: Style.fontSizeL * Style.uiScaleRatio
            font.weight: Font.DemiBold
            color: Color.mPrimary || "#6200EE"
            elide: Text.ElideRight
            maximumLineCount: 1
            horizontalAlignment: Text.AlignHCenter
          }

          NText {
            visible: hasPlayer
            Layout.fillWidth: true
            text: MediaService.trackArtist || "Artista desconocido"
            font.pointSize: Style.fontSizeM * Style.uiScaleRatio
            color: Color.mOnSurfaceVariant || "#CAC4D0"
            elide: Text.ElideRight
            maximumLineCount: 1
            horizontalAlignment: Text.AlignHCenter
          }

          RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Style.marginM
            
            NIconButton { 
               icon: "media-prev"
               baseSize: 32
               enabled: MediaService.canGoPrevious
               onClicked: MediaService.previous()
            }
            
            NIconButton { 
              icon: isPlaying ? "media-pause" : "media-play"
              baseSize: 44
              colorBg: Color.mPrimary || "#6200EE"
              colorFg: Color.mOnPrimary || "#FFFFFF"
              enabled: MediaService.canPlay || MediaService.canPause
              onClicked: MediaService.playPause()
            }
            
            NIconButton { 
               icon: "media-next"
               baseSize: 32
               enabled: MediaService.canGoNext
               onClicked: MediaService.next()
            }
          }

          ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 320 * Style.uiScaleRatio
            spacing: 6

            RowLayout {
              Layout.fillWidth: true
              Layout.preferredHeight: 16
              spacing: 0
              
              NText {
                text: lengthStr(MediaService.currentPosition)
                font.pointSize: 10 * Style.uiScaleRatio
                color: Color.mOnSurfaceVariant || "#CAC4D0"
              }
              
              Item { Layout.fillWidth: true }
              
              NText {
                text: lengthStr(MediaService.trackLength)
                font.pointSize: 10 * Style.uiScaleRatio
                color: Color.mOnSurfaceVariant || "#CAC4D0"
              }
            }

            Item {
              Layout.fillWidth: true
              Layout.preferredHeight: 8 * Style.uiScaleRatio
              
              Rectangle {
                id: bgBar
                width: parent.width
                height: 6
                color: Color.mSurfaceVariant || "#2B2930"
                radius: 3
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                  id: fillBar
                  height: parent.height
                  color: Color.mPrimary || "#6200EE"
                  radius: 3
                  width: (hasPlayer && MediaService.trackLength > 0) 
                         ? parent.width * (MediaService.currentPosition / MediaService.trackLength) 
                         : 0
                  
                  Behavior on width { 
                    enabled: !seekMouseArea.pressed
                    NumberAnimation { duration: 200; easing.type: Easing.Linear }
                  }
                }
                
                Rectangle {
                  id: previewIndicator
                  visible: seekMouseArea.containsMouse && !seekMouseArea.pressed && hasPlayer
                  height: parent.height
                  color: Color.mPrimary || "#6200EE"
                  opacity: 0.3
                  radius: 3
                  width: seekMouseArea.containsMouse ? seekMouseArea.mouseX : 0
                }
              }
              
              Rectangle {
                id: seekKnob
                width: 14 * Style.uiScaleRatio
                height: 14 * Style.uiScaleRatio
                radius: width / 2
                color: Color.mPrimary || "#6200EE"
                border.color: Color.mOnPrimary || "#FFFFFF"
                border.width: 2
                visible: hasPlayer && (seekMouseArea.containsMouse || seekMouseArea.pressed)
                
                anchors.verticalCenter: bgBar.verticalCenter
                x: {
                  if (seekMouseArea.pressed) {
                    return Math.max(0, Math.min(seekMouseArea.mouseX - width/2, bgBar.width - width))
                  } else {
                    return (fillBar.width - width/2)
                  }
                }
                
                Behavior on x {
                  enabled: !seekMouseArea.pressed
                  NumberAnimation { duration: 200; easing.type: Easing.Linear }
                }
                
                scale: seekMouseArea.pressed ? 1.2 : (seekMouseArea.containsMouse ? 1.1 : 1.0)
                Behavior on scale { NumberAnimation { duration: 100 } }
              }
              
              Rectangle {
                id: timeTooltip
                visible: seekMouseArea.containsMouse && hasPlayer
                width: tooltipText.width + 12 * Style.uiScaleRatio
                height: tooltipText.height + 6 * Style.uiScaleRatio
                color: Color.mSurface || "#1C1B1F"
                border.color: Color.mPrimary || "#6200EE"
                border.width: 1
                radius: 4 * Style.uiScaleRatio
                
                x: {
                  let centerX = seekMouseArea.mouseX - width / 2
                  return Math.max(0, Math.min(centerX, parent.width - width))
                }
                y: -height - 8 * Style.uiScaleRatio
                
                NText {
                  id: tooltipText
                  anchors.centerIn: parent
                  text: {
                    if (hasPlayer && MediaService.trackLength > 0) {
                      let ratio = Math.max(0, Math.min(seekMouseArea.mouseX / bgBar.width, 1))
                      let seekTime = ratio * MediaService.trackLength
                      return lengthStr(seekTime)
                    }
                    return "0:00"
                  }
                  font.pointSize: 10 * Style.uiScaleRatio
                  font.weight: Font.DemiBold
                  color: Color.mPrimary || "#6200EE"
                }
                
                Canvas {
                  width: 8 * Style.uiScaleRatio
                  height: 4 * Style.uiScaleRatio
                  anchors.horizontalCenter: parent.horizontalCenter
                  anchors.top: parent.bottom
                  anchors.topMargin: -1
                  
                  property color surfaceColor: Color.mSurface || "#1C1B1F"
                  property color primaryColor: Color.mPrimary || "#6200EE"
                  
                  onSurfaceColorChanged: requestPaint()
                  onPrimaryColorChanged: requestPaint()
                  
                  onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    ctx.fillStyle = surfaceColor
                    ctx.strokeStyle = primaryColor
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    ctx.moveTo(0, 0)
                    ctx.lineTo(width / 2, height)
                    ctx.lineTo(width, 0)
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke()
                  }
                }
              }

              MouseArea {
                id: seekMouseArea
                anchors.fill: parent
                enabled: MediaService.canSeek
                hoverEnabled: true
                
                property bool isSeeking: false
                
                onPressed: (mouse) => {
                  isSeeking = true
                  MediaService.isSeeking = true
                  if (hasPlayer && MediaService.trackLength > 0) {
                    MediaService.seekByRatio(mouse.x / width)
                  }
                }
                
                onPositionChanged: (mouse) => {
                  if (isSeeking && hasPlayer && MediaService.trackLength > 0) {
                    MediaService.seekByRatio(mouse.x / width)
                  }
                }
                
                onReleased: (mouse) => {
                  if (hasPlayer && MediaService.trackLength > 0) {
                    MediaService.seekByRatio(mouse.x / width)
                  }
                  isSeeking = false
                  MediaService.isSeeking = false
                }
                
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
              }
            }
          }
        }

        Item {
          Layout.preferredWidth: 150 * Style.uiScaleRatio
          Layout.preferredHeight: 180 * Style.uiScaleRatio
          Layout.alignment: Qt.AlignVCenter

          Item {
            anchors.centerIn: parent
            width: 130 * Style.uiScaleRatio
            height: 130 * Style.uiScaleRatio

            NIcon {
              anchors.centerIn: parent
              icon: "photo"
              pointSize: 48 * Style.uiScaleRatio
              color: Color.mOnSurfaceVariant || "#CAC4D0"
              visible: root.localGifPath === ""
            }

            AnimatedImage {
              id: gifImage
              anchors.fill: parent
              source: root.localGifPath
              fillMode: Image.PreserveAspectFit
              playing: isPlaying
              opacity: isPlaying ? 1.0 : 0.4
              cache: true
              visible: root.localGifPath !== ""
              
              Behavior on opacity { NumberAnimation { duration: 300 } }
            }
          }
        }
      }
    }
  }
}
