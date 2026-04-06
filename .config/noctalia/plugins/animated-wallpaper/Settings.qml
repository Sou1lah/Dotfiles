import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  property var pluginApi
  property bool removeMode: false
  spacing: Style.marginM || 16
  
  // Función para agregar intervalo personalizado
  function addCustomInterval() {
    var input = customTimeInput.text.trim().toLowerCase()
    if (!input) return
    
    var totalSeconds = 0
    
    // Parsear el formato (5s, 10m, 2h)
    if (input.endsWith('s')) {
      totalSeconds = parseInt(input.slice(0, -1))
    } else if (input.endsWith('m')) {
      totalSeconds = parseInt(input.slice(0, -1)) * 60
    } else if (input.endsWith('h')) {
      totalSeconds = parseInt(input.slice(0, -1)) * 3600
    } else {
      // Si no tiene sufijo, asumir segundos
      totalSeconds = parseInt(input)
    }
    
    if (totalSeconds > 0 && !isNaN(totalSeconds)) {
      // Agregar a intervalos personalizados si no existe
      var intervals = pluginApi.pluginSettings.customIntervals || []
      if (intervals.indexOf(totalSeconds) === -1) {
        intervals.push(totalSeconds)
        pluginApi.pluginSettings.customIntervals = intervals
      }
      
      // Seleccionar el nuevo intervalo
      pluginApi.pluginSettings.changeInterval = totalSeconds
      pluginApi.saveSettings()
      
      customTimeDialog.close()
      customTimeInput.text = ""
    }
  }
  
  Component.onCompleted: {
    if (!pluginApi.pluginSettings.enabled) {
      pluginApi.pluginSettings.enabled = false
    }
    if (!pluginApi.pluginSettings.videoPath) {
      pluginApi.pluginSettings.videoPath = ""
    }
    if (!pluginApi.pluginSettings.folderPath) {
      pluginApi.pluginSettings.folderPath = ""
    }
    if (!pluginApi.pluginSettings.changeMode) {
      pluginApi.pluginSettings.changeMode = "manual"
    }
    if (!pluginApi.pluginSettings.changeInterval) {
      pluginApi.pluginSettings.changeInterval = 10
    }
    if (!pluginApi.pluginSettings.customIntervals) {
      pluginApi.pluginSettings.customIntervals = []
    }
    if (!pluginApi.pluginSettings.fillMode) {
      pluginApi.pluginSettings.fillMode = "PreserveAspectCrop"
    }
    if (pluginApi.pluginSettings.volume === undefined) {
      pluginApi.pluginSettings.volume = 0
    }
    if (pluginApi.pluginSettings.loop === undefined) {
      pluginApi.pluginSettings.loop = true
    }
    pluginApi.saveSettings()
  }
  
  NLabel {
    label: "Animated Wallpaper"
    description: "Play videos as desktop background"
  }
  
  NToggle {
    Layout.fillWidth: true
    label: "Enable wallpaper"
    checked: pluginApi.pluginSettings.enabled
    onToggled: function(checked) {
      pluginApi.pluginSettings.enabled = checked
      pluginApi.saveSettings()
    }
  }
  
  // Modo de cambio
  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS || 12
    
    NLabel {
      label: "Wallpaper change mode"
      description: "Change wallpapers automatically at regular intervals"
    }
    
    NComboBox {
      Layout.fillWidth: true
      label: "Change mode"
      model: ListModel {
        ListElement { name: "Manual"; key: "manual" }
        ListElement { name: "Automatic (Random)"; key: "auto" }
      }
      currentKey: pluginApi.pluginSettings.changeMode || "manual"
      
      // CORREGIDO: Declaración explícita del parámetro
      onSelected: function(selectedKey) {
        pluginApi.pluginSettings.changeMode = selectedKey
        pluginApi.saveSettings()
      }
    }
    
    // Intervalo de cambio (visible solo en modo auto, justo debajo del selector)
    ColumnLayout {
      Layout.fillWidth: true
      Layout.topMargin: Style.marginS || 8
      spacing: Style.marginS || 8
      visible: pluginApi.pluginSettings.changeMode === "auto"
      
      NLabel {
        label: "Wallpaper change interval"
        description: "How often to change wallpapers automatically"
      }
      
      // Grid de botones predefinidos + personalizados
      Flow {
        Layout.fillWidth: true
        spacing: 6
        
        // Botones predefinidos
        Repeater {
          model: [
            { label: "5s", value: 5 },
            { label: "10s", value: 10 },
            { label: "15s", value: 15 },
            { label: "30s", value: 30 },
            { label: "45s", value: 45 },
            { label: "1m", value: 60 },
            { label: "1h 30m", value: 5400 },
            { label: "2h", value: 7200 }
          ]
          
          Button {
            width: 58
            height: 28
            
            property bool isSelected: modelData.value === pluginApi.pluginSettings.changeInterval
            
            onClicked: {
              pluginApi.pluginSettings.changeInterval = modelData.value
              pluginApi.saveSettings()
            }
            
            background: Rectangle {
              color: parent.isSelected 
                ? (Color.mPrimary || "#4a9eff")
                : (parent.hovered ? (Color.mSurfaceVariant || "#2a2a2a") : "transparent")
              radius: 4
              border.width: 1
              border.color: parent.isSelected
                ? (Color.mPrimary || "#4a9eff")
                : (Color.mOutline || "#3a3a3a")
              
              Behavior on color { ColorAnimation { duration: 150 } }
              Behavior on border.color { ColorAnimation { duration: 150 } }
            }
            
            contentItem: Text {
              text: modelData.label
              color: parent.isSelected
                ? (Color.mOnPrimary || "#ffffff")
                : (Color.mOnSurface || "#e0e0e0")
              font.family: Style.fontFamily || "sans-serif"
              font.pixelSize: 11
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              
              Behavior on color { ColorAnimation { duration: 150 } }
            }
          }
        }
        
        // Botones personalizados
        Repeater {
          model: pluginApi.pluginSettings.customIntervals || []
          
          Rectangle {
            width: 58
            height: 28
            
            property bool isSelected: modelData === pluginApi.pluginSettings.changeInterval
            property int customValue: modelData
            
            color: isSelected 
              ? (Color.mPrimary || "#4a9eff")
              : (customMouse.containsMouse ? (Color.mSurfaceVariant || "#2a2a2a") : "transparent")
            radius: 4
            border.width: 1
            border.color: isSelected
              ? (Color.mPrimary || "#4a9eff")
              : (Color.mOutline || "#3a3a3a")
            
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }
            
            // Texto del intervalo
            Text {
              anchors.centerIn: parent
              text: {
                var secs = customValue
                if (secs < 60) return secs + "s"
                else if (secs < 3600) return Math.floor(secs / 60) + "m"
                else {
                  var h = Math.floor(secs / 3600)
                  var m = Math.floor((secs % 3600) / 60)
                  return m > 0 ? h + "h " + m + "m" : h + "h"
                }
              }
              color: parent.isSelected
                ? (Color.mOnPrimary || "#ffffff")
                : (Color.mOnSurface || "#e0e0e0")
              font.family: Style.fontFamily || "sans-serif"
              font.pixelSize: 11
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              visible: !removeMode
              
              Behavior on color { ColorAnimation { duration: 150 } }
            }
            
            // Botón X para eliminar (visible solo en modo remove)
            Text {
              anchors.centerIn: parent
              text: "×"
              color: Color.mError || "#dc3545"
              font.family: Style.fontFamily || "sans-serif"
              font.pixelSize: 18
              font.weight: Font.Bold
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              visible: removeMode
              
              Behavior on color { ColorAnimation { duration: 150 } }
            }
            
            MouseArea {
              id: customMouse
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              
              onClicked: {
                if (removeMode) {
                  // Eliminar el intervalo
                  var intervals = pluginApi.pluginSettings.customIntervals || []
                  var idx = intervals.indexOf(customValue)
                  if (idx !== -1) {
                    intervals.splice(idx, 1)
                    pluginApi.pluginSettings.customIntervals = intervals
                    
                    // Si era el seleccionado, volver a default
                    if (pluginApi.pluginSettings.changeInterval === customValue) {
                      pluginApi.pluginSettings.changeInterval = 10
                    }
                    
                    pluginApi.saveSettings()
                  }
                } else {
                  // Seleccionar este intervalo
                  pluginApi.pluginSettings.changeInterval = customValue
                  pluginApi.saveSettings()
                }
              }
            }
          }
        }
        
        // Botón "+" para agregar personalizado
        Button {
          width: 58
          height: 28
          visible: true  // Fix: siempre visible
          
          onClicked: customTimeDialog.open()
          
          background: Rectangle {
            color: parent.hovered ? (Color.mPrimary || "#4a9eff") : "transparent"
            radius: 4
            border.width: 1
            border.color: parent.hovered
              ? (Color.mPrimary || "#4a9eff")
              : (Color.mOutline || "#3a3a3a")
            
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }
          }
          
          contentItem: Text {
            text: "+"
            color: parent.hovered
              ? (Color.mOnPrimary || "#ffffff")
              : (Color.mOnSurface || "#e0e0e0")
            font.family: Style.fontFamily || "sans-serif"
            font.pixelSize: 18
            font.weight: Font.Bold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            
            Behavior on color { ColorAnimation { duration: 150 } }
          }
        }
        
        // Botón toggle para modo remove (solo visible si hay custom intervals)
        Button {
          width: 58
          height: 28
          visible: (pluginApi.pluginSettings.customIntervals || []).length > 0
          
          onClicked: removeMode = !removeMode
          
          background: Rectangle {
            color: removeMode 
              ? (Color.mError || "#dc3545")
              : (parent.hovered ? (Color.mSurfaceVariant || "#2a2a2a") : "transparent")
            radius: 4
            border.width: 1
            border.color: removeMode
              ? (Color.mError || "#dc3545")
              : (Color.mOutline || "#3a3a3a")
            
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }
          }
          
          contentItem: Text {
            text: removeMode ? "✓" : "−"
            color: removeMode
              ? "#ffffff"
              : (parent.hovered ? (Color.mOnSurface || "#e0e0e0") : (Color.mOnSurfaceVariant || "#888888"))
            font.family: Style.fontFamily || "sans-serif"
            font.pixelSize: removeMode ? 14 : 18
            font.weight: Font.Bold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            
            Behavior on color { ColorAnimation { duration: 150 } }
          }
        }
      }
    }
  }
  
  // SELECTOR DE VIDEO - SIEMPRE VISIBLE
  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS || 8
    
    NLabel {
      label: "Video selection"
      description: "Browse and manually change current video"
    }
    
    Button {
      Layout.fillWidth: true
      Layout.preferredHeight: 42
      
      onClicked: {
        // Si hay carpeta configurada, usarla como inicio
        if (pluginApi.pluginSettings.folderPath) {
          videoPickerPanel.currentPath = pluginApi.pluginSettings.folderPath
          videoPickerPanel.pathHistory = [pluginApi.pluginSettings.folderPath]
        }
        videoPickerPanel.show()
      }
      
      background: Rectangle {
        color: parent.hovered ? (Color.mPrimary || "#4a9eff") : (Color.mSurfaceVariant || "#2a2a2a")
        radius: 6
        border.width: 1
        border.color: Color.mOutline || "#3a3a3a"
        
        Behavior on color { ColorAnimation { duration: 150 } }
      }
      
      contentItem: RowLayout {
        spacing: 12
        
        Text {
          text: (pluginApi.pluginSettings.videoPath && pluginApi.pluginSettings.videoPath !== "")
            ? pluginApi.pluginSettings.videoPath.split('/').pop()
            : "Select video"
          color: parent.parent.hovered ? (Color.mOnPrimary || "#ffffff") : (Color.mOnSurface || "#e0e0e0")
          font.family: Style.fontFamily || "sans-serif"
          font.pixelSize: Style.fontSizeS || 13
          font.weight: Font.Medium
          elide: Text.ElideMiddle
          Layout.fillWidth: true
          
          Behavior on color { ColorAnimation { duration: 150 } }
        }
        
        Text {
          text: "›"
          color: parent.parent.hovered ? (Color.mOnPrimary || "#ffffff") : (Color.mOnSurfaceVariant || "#888888")
          font.pixelSize: 18
          font.weight: Font.Bold
          
          Behavior on color { ColorAnimation { duration: 150 } }
        }
      }
    }
  }
  
  // SELECTOR DE CARPETA - SIEMPRE VISIBLE
  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS || 8
    
    NLabel {
      label: "Folder selection"
      description: "Choose a folder with videos for random playback"
    }
    
    Button {
      Layout.fillWidth: true
      Layout.preferredHeight: 42
      
      onClicked: {
        folderPickerPanel.show()
      }
      
      background: Rectangle {
        color: parent.hovered ? (Color.mPrimary || "#4a9eff") : (Color.mSurfaceVariant || "#2a2a2a")
        radius: 6
        border.width: 1
        border.color: Color.mOutline || "#3a3a3a"
        
        Behavior on color { ColorAnimation { duration: 150 } }
      }
      
      contentItem: RowLayout {
        spacing: 12
        
        Text {
          text: (pluginApi.pluginSettings.folderPath && pluginApi.pluginSettings.folderPath !== "")
            ? pluginApi.pluginSettings.folderPath.split('/').pop()
            : "Select folder"
          color: parent.parent.hovered ? (Color.mOnPrimary || "#ffffff") : (Color.mOnSurface || "#e0e0e0")
          font.family: Style.fontFamily || "sans-serif"
          font.pixelSize: Style.fontSizeS || 13
          font.weight: Font.Medium
          elide: Text.ElideMiddle
          Layout.fillWidth: true
          
          Behavior on color { ColorAnimation { duration: 150 } }
        }
        
        Text {
          text: "›"
          color: parent.parent.hovered ? (Color.mOnPrimary || "#ffffff") : (Color.mOnSurfaceVariant || "#888888")
          font.pixelSize: 18
          font.weight: Font.Bold
          
          Behavior on color { ColorAnimation { duration: 150 } }
        }
      }
    }
  }
  
  NComboBox {
    Layout.fillWidth: true
    label: "Fill mode"
    model: ListModel {
      ListElement { name: "Crop (Recommended)"; key: "PreserveAspectCrop" }
      ListElement { name: "Fit"; key: "PreserveAspectFit" }
      ListElement { name: "Stretch"; key: "Stretch" }
    }
    currentKey: pluginApi.pluginSettings.fillMode || "PreserveAspectCrop"
    
    // CORREGIDO: Declaración explícita del parámetro
    onSelected: function(selectedKey) {
      pluginApi.pluginSettings.fillMode = selectedKey
      pluginApi.saveSettings()
    }
  }
  
  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS || 8
    
    RowLayout {
      Layout.fillWidth: true
      
      NLabel {
        Layout.fillWidth: true
        label: "Volume"
        description: "Video audio level"
      }
      
      Text {
        text: Math.round((pluginApi.pluginSettings.volume || 0) * 100) + "%"
        color: Color.mPrimary || "#4a9eff"
        font.family: Style.fontFamily || "sans-serif"
        font.pixelSize: Style.fontSizeM || 14
        font.weight: Font.Medium
      }
    }
    
    NSlider {
      Layout.fillWidth: true
      from: 0
      to: 100
      value: (pluginApi.pluginSettings.volume || 0) * 100
      
      onMoved: {
        pluginApi.pluginSettings.volume = value / 100
        pluginApi.saveSettings()
      }
    }
  }
  
  NToggle {
    Layout.fillWidth: true
    label: "Loop playback"
    description: "Repeat video continuously"
    checked: pluginApi.pluginSettings.loop !== undefined ? pluginApi.pluginSettings.loop : true
    
    onToggled: function(checked) {
      pluginApi.pluginSettings.loop = checked
      pluginApi.saveSettings()
    }
  }
  
  // Popup para ingresar tiempo personalizado
  Popup {
    id: customTimeDialog
    anchors.centerIn: Overlay.overlay
    width: 280
    height: 120
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    background: Rectangle {
      color: Color.mSurface || "#1e1e1e"
      radius: 8
      border.width: 1
      border.color: Color.mOutline || "#3a3a3a"
    }
    
    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 10
      
      TextField {
        id: customTimeInput
        Layout.fillWidth: true
        Layout.preferredHeight: 34
        placeholderText: "e.g., 5s, 10m, 2h"
        color: Color.mOnSurface || "#e0e0e0"
        font.family: Style.fontFamily || "sans-serif"
        font.pixelSize: 12
        
        background: Rectangle {
          color: Color.mSurfaceVariant || "#2a2a2a"
          radius: 4
          border.width: parent.activeFocus ? 2 : 1
          border.color: parent.activeFocus 
            ? (Color.mPrimary || "#4a9eff")
            : (Color.mOutline || "#3a3a3a")
          
          Behavior on border.color { ColorAnimation { duration: 150 } }
        }
        
        Keys.onReturnPressed: {
          addCustomInterval()
          customTimeDialog.close()
        }
        Keys.onEnterPressed: {
          addCustomInterval()
          customTimeDialog.close()
        }
      }
      
      RowLayout {
        Layout.fillWidth: true
        spacing: 8
        
        Button {
          Layout.fillWidth: true
          Layout.preferredHeight: 34
          
          onClicked: customTimeDialog.close()
          
          background: Rectangle {
            color: parent.hovered ? (Color.mSurfaceVariant || "#3a3a3a") : "transparent"
            radius: 4
            border.width: 1
            border.color: Color.mOutline || "#3a3a3a"
          }
          
          contentItem: Text {
            text: "Cancel"
            color: Color.mOnSurface || "#e0e0e0"
            font.family: Style.fontFamily || "sans-serif"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
          }
        }
        
        Button {
          Layout.fillWidth: true
          Layout.preferredHeight: 34
          
          onClicked: {
            addCustomInterval()
            customTimeDialog.close()
          }
          
          background: Rectangle {
            color: parent.hovered 
              ? Qt.lighter(Color.mPrimary || "#4a9eff", 1.1)
              : (Color.mPrimary || "#4a9eff")
            radius: 4
          }
          
          contentItem: Text {
            text: "Add"
            color: Color.mOnPrimary || "#ffffff"
            font.family: Style.fontFamily || "sans-serif"
            font.pixelSize: 12
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
          }
        }
      }
    }
  }
  
  VideoPickerPanel {
    id: videoPickerPanel
    
    onVideoSelected: function(path) {
      pluginApi.pluginSettings.videoPath = path
      pluginApi.saveSettings()
    }
  }
  
  FolderPickerPanel {
    id: folderPickerPanel
    
    onFolderSelected: function(path) {
      pluginApi.pluginSettings.folderPath = path
      videoPickerPanel.setFolderPath(path)
      pluginApi.saveSettings()
    }
  }
}
