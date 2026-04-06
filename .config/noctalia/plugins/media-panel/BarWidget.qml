import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.Media
import qs.Widgets

Item {
  id: root
  
  property var pluginApi: null
  property var screen: null
  property bool isBarVertical: false
  property int barLineSize: 0
  
  readonly property bool hasPlayer: MediaService.currentPlayer !== null
  readonly property bool isPlaying: MediaService.isPlaying
  readonly property string trackTitle: hasPlayer && MediaService.trackTitle ? MediaService.trackTitle : "No hay música"
  
  property bool hovering: false
  
  readonly property real barFontSize: Math.max(
    Math.min(
      Style.fontSizeM * Style.uiScaleRatio,
      barLineSize > 0 ? barLineSize * 0.5 : 11
    ),
    9
  )
  
  readonly property real buttonSize: Math.max((barLineSize > 0 ? barLineSize - 8 : 22), 18) * Style.uiScaleRatio
  
  Layout.fillWidth: !isBarVertical
  Layout.fillHeight: isBarVertical
  implicitWidth: isBarVertical ? (barLineSize > 0 ? barLineSize : 32) : visualCapsule.implicitWidth
  implicitHeight: isBarVertical ? visualCapsule.implicitHeight : (barLineSize > 0 ? barLineSize : 32)
  
  // Medir el ancho real del texto
  TextMetrics {
    id: textMetrics
    font.pointSize: root.barFontSize
    font.weight: Font.Medium
    text: trackTitle
  }
  
  Item {
    id: visualCapsule
    anchors.fill: parent
    
    implicitWidth: {
      if (isBarVertical) return barLineSize > 0 ? barLineSize : 32
      const spacing = 6 * Style.uiScaleRatio
      const minTextWidth = 60 * Style.uiScaleRatio
      const maxTextWidth = 220 * Style.uiScaleRatio
      
      if (!hasPlayer) {
        return minTextWidth
      }
      
      // Ancho real del texto, limitado por min y max
      const textWidth = Math.max(minTextWidth, Math.min(textMetrics.width + 8 * Style.uiScaleRatio, maxTextWidth))
      
      if (!hovering) {
        return textWidth
      }
      
      // Con hover: texto + espacio + botones
      const controlsWidth = buttonSize * 3.3 + spacing * 2
      return textWidth + spacing + controlsWidth
    }
    
    implicitHeight: {
      if (!isBarVertical) return barLineSize > 0 ? barLineSize : 32
      return 32 * Style.uiScaleRatio
    }
    
    Behavior on implicitWidth {
      NumberAnimation { 
        duration: 200
        easing.type: Easing.OutCubic
      }
    }
    
    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 4 * Style.uiScaleRatio
      anchors.rightMargin: 2 * Style.uiScaleRatio
      anchors.topMargin: 2 * Style.uiScaleRatio
      anchors.bottomMargin: 2 * Style.uiScaleRatio
      spacing: 6 * Style.uiScaleRatio
      
      // Título de la canción (clickeable para abrir panel)
      Item {
        id: trackInfoArea
        Layout.fillHeight: true
        Layout.preferredWidth: Math.max(60 * Style.uiScaleRatio, Math.min(textMetrics.width + 8 * Style.uiScaleRatio, 220 * Style.uiScaleRatio))
        
        NText {
          anchors.fill: parent
          text: trackTitle
          font.pointSize: root.barFontSize
          font.weight: Font.Medium
          color: Color.mOnSurface
          elide: Text.ElideRight
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignLeft
        }
        
        MouseArea {
          id: textMouseArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          
          onClicked: {
            if (pluginApi) {
              pluginApi.openPanel(root.screen, visualCapsule)
            }
          }
        }
      }
      
      // Controles de reproducción (pegados al texto)
      RowLayout {
        Layout.alignment: Qt.AlignVCenter
        spacing: 3 * Style.uiScaleRatio
        visible: hovering && hasPlayer
        opacity: hovering && hasPlayer ? 1 : 0
        
        Behavior on opacity {
          NumberAnimation { duration: 150 }
        }
        
        // Botón anterior
        Item {
          Layout.preferredWidth: buttonSize
          Layout.preferredHeight: buttonSize
          
          Rectangle {
            anchors.fill: parent
            radius: Style.radiusM
            color: prevMouseArea.containsMouse ? Color.mSurfaceVariant : Color.mSurface
            border.color: Color.mOutline
            border.width: 1
            
            Behavior on color { ColorAnimation { duration: 100 } }
            
            NIcon {
              anchors.centerIn: parent
              icon: "media-prev"
              pointSize: buttonSize * 0.55
              color: MediaService.canGoPrevious ? Color.mOnSurface : Color.mOnSurfaceVariant
              opacity: MediaService.canGoPrevious ? 1 : 0.4
            }
          }
          
          MouseArea {
            id: prevMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            enabled: MediaService.canGoPrevious
            
            onClicked: MediaService.previous()
          }
        }
        
        // Botón play/pause
        Item {
          Layout.preferredWidth: buttonSize * 1.15
          Layout.preferredHeight: buttonSize * 1.15
          
          Rectangle {
            anchors.fill: parent
            radius: Style.radiusM
            color: isPlaying ? Color.mPrimary : Color.mSurfaceVariant
            border.color: isPlaying ? Qt.lighter(Color.mPrimary, 1.2) : Color.mOutline
            border.width: 1
            
            Behavior on color { ColorAnimation { duration: 150 } }
            
            NIcon {
              anchors.centerIn: parent
              icon: isPlaying ? "media-pause" : "media-play"
              pointSize: parent.width * 0.5
              color: isPlaying ? Color.mOnPrimary : Color.mOnSurfaceVariant
            }
          }
          
          MouseArea {
            id: playPauseMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            enabled: MediaService.canPlay || MediaService.canPause
            
            onClicked: MediaService.playPause()
          }
        }
        
        // Botón siguiente
        Item {
          Layout.preferredWidth: buttonSize
          Layout.preferredHeight: buttonSize
          
          Rectangle {
            anchors.fill: parent
            radius: Style.radiusM
            color: nextMouseArea.containsMouse ? Color.mSurfaceVariant : Color.mSurface
            border.color: Color.mOutline
            border.width: 1
            
            Behavior on color { ColorAnimation { duration: 100 } }
            
            NIcon {
              anchors.centerIn: parent
              icon: "media-next"
              pointSize: buttonSize * 0.55
              color: MediaService.canGoNext ? Color.mOnSurface : Color.mOnSurfaceVariant
              opacity: MediaService.canGoNext ? 1 : 0.4
            }
          }
          
          MouseArea {
            id: nextMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            enabled: MediaService.canGoNext
            
            onClicked: MediaService.next()
          }
        }
      }
    }
  }
  
  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.MiddleButton
    propagateComposedEvents: true
    
    onEntered: root.hovering = true
    onExited: root.hovering = false
    
    onClicked: function(mouse) {
      if (mouse.button === Qt.MiddleButton && hasPlayer) {
        MediaService.playPause()
      }
    }
  }
}
