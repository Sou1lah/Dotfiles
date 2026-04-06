import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Widgets

Scope {
  id: root
  
  property string currentPath: Qt.platform.os === "linux" ? 
    (Qt.application.arguments[0] ? Qt.application.arguments[0].replace(/\/[^\/]*$/, "") : "/home") : "/home"
  property var pathHistory: []
  property string selectedFolder: ""
  property bool panelVisible: false
  
  signal folderSelected(string path)
  
  Component.onCompleted: {
    const homeVar = Qt.application.arguments.find(arg => arg.startsWith("HOME="))
    if (homeVar) {
      currentPath = homeVar.replace("HOME=", "")
    } else {
      currentPath = "/home"
    }
    pathHistory = [currentPath]
  }
  
  function show() {
    panelVisible = true
    selectedFolder = ""
  }
  
  function hide() {
    panelVisible = false
  }
  
  function goBack() {
    if (pathHistory.length > 1) {
      pathHistory.pop()
      currentPath = pathHistory[pathHistory.length - 1]
      pathHistory = pathHistory.slice()
      selectedFolder = ""
    }
  }
  
  function goToPath(path) {
    pathHistory.push(path)
    currentPath = path
    pathHistory = pathHistory.slice()
    selectedFolder = ""
  }
  
  function goHome() {
    currentPath = pathHistory[0]
    pathHistory = [currentPath]
    selectedFolder = ""
  }
  
  PanelWindow {
    id: floatingPanel
    
    visible: root.panelVisible
    implicitWidth: 900
    implicitHeight: 620
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    
    color: "transparent"
    
    Shortcut {
      sequence: "Escape"
      onActivated: root.panelVisible = false
    }
    
    Rectangle {
      anchors.fill: parent
      anchors.margins: 16
      color: Color.mSurface || "#1e1e1e"
      radius: 12
      border.width: 1
      border.color: Color.mOutline || "#3a3a3a"
      
      ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 56
          color: Color.mSurfaceVariant || "#2a2a2a"
          
          Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Color.mOutlineVariant || "#3a3a3a"
          }
          
          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 8
            
            // Botón atrás
            Button {
              Layout.preferredWidth: 36
              Layout.preferredHeight: 36
              enabled: root.pathHistory.length > 1
              opacity: enabled ? 1.0 : 0.3
              
              onClicked: root.goBack()
              
              background: Rectangle {
                color: parent.enabled && parent.hovered ? (Color.mSurfaceVariant || "#3a3a3a") : "transparent"
                radius: 6
              }
              
              contentItem: Text {
                text: "←"
                color: Color.mOnSurface || "#e0e0e0"
                font.pixelSize: 18
                font.family: "monospace"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
              }
            }
            
            // Separador
            Rectangle {
              Layout.preferredWidth: 1
              Layout.preferredHeight: 24
              color: Color.mOutlineVariant || "#3a3a3a"
            }
            
            // Ruta actual
            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: 36
              color: Color.mSurface || "#252525"
              radius: 6
              border.width: 1
              border.color: Color.mOutlineVariant || "#3a3a3a"
              
              Text {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                text: root.currentPath || ""
                color: Color.mOnSurface || "#e0e0e0"
                font.family: "monospace"
                font.pixelSize: 13
                elide: Text.ElideMiddle
                verticalAlignment: Text.AlignVCenter
              }
            }
            
            // Separador
            Rectangle {
              Layout.preferredWidth: 1
              Layout.preferredHeight: 24
              color: Color.mOutlineVariant || "#3a3a3a"
            }
            
            // Botón home
            Button {
              Layout.preferredWidth: 36
              Layout.preferredHeight: 36
              
              onClicked: root.goHome()
              
              background: Rectangle {
                color: parent.hovered ? (Color.mSurfaceVariant || "#3a3a3a") : "transparent"
                radius: 6
              }
              
              contentItem: Text {
                text: "~"
                color: Color.mOnSurface || "#e0e0e0"
                font.pixelSize: 18
                font.family: "monospace"
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
              }
            }
            
            // Botón cerrar
            Button {
              Layout.preferredWidth: 36
              Layout.preferredHeight: 36
              
              onClicked: root.panelVisible = false
              
              background: Rectangle {
                color: parent.hovered ? (Color.mError || "#dc3545") : "transparent"
                radius: 6
              }
              
              contentItem: Text {
                text: "×"
                color: parent.parent.hovered ? "#ffffff" : (Color.mOnSurface || "#e0e0e0")
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
              }
            }
          }
        }
        
        // Content - CARPETAS MÁS PEQUEÑAS Y CENTRADAS
        ScrollView {
          Layout.fillWidth: true
          Layout.fillHeight: true
          clip: true
          
          ScrollBar.vertical.policy: ScrollBar.AsNeeded
          
          Flickable {
            contentWidth: gridContainer.width
            contentHeight: gridContainer.height
            
            Item {
              id: gridContainer
              width: Math.max(parent.parent.width, gridFlow.width)
              height: gridFlow.height + 48
              
              Flow {
                id: gridFlow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 24
                
                // Carpetas más pequeñas: 90x90
                width: {
                  var cols = Math.floor((parent.width - 48) / 106)
                  if (cols < 1) cols = 1
                  return cols * 106
                }
                
                spacing: 16
                
                Repeater {
                  model: folderModel
                  
                  delegate: Item {
                    width: 90
                    height: 90
                    
                    Rectangle {
                      anchors.fill: parent
                      color: "transparent"
                      
                      ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 2
                        spacing: 6
                        
                        // Icono de carpeta - MÁS PEQUEÑO (48x48)
                        Rectangle {
                          Layout.preferredWidth: 48
                          Layout.preferredHeight: 48
                          Layout.alignment: Qt.AlignHCenter
                          color: "transparent"
                          
                          // SVG con color primario de Noctalia
                          Canvas {
                            anchors.fill: parent
                            
                            property color folderColor: Color.mPrimary || "#c9a461"
                            
                            onPaint: {
                              var ctx = getContext("2d")
                              ctx.reset()
                              ctx.fillStyle = folderColor
                              
                              var scale = 3
                              ctx.scale(scale, scale)
                              
                              // Dibujar icono de carpeta
                              ctx.beginPath()
                              ctx.moveTo(2, 2)
                              ctx.bezierCurveTo(0.892, 2, 0, 2.892, 0, 4)
                              ctx.lineTo(0, 13)
                              ctx.bezierCurveTo(0, 14.108, 0.892, 15, 2, 15)
                              ctx.lineTo(14, 15)
                              ctx.bezierCurveTo(15.108, 15, 16, 14.108, 16, 13)
                              ctx.lineTo(16, 5)
                              ctx.bezierCurveTo(16, 3.892, 15.108, 3, 14, 3)
                              ctx.lineTo(8, 3)
                              ctx.lineTo(6.37, 3)
                              ctx.bezierCurveTo(5.79, 2.977, 5.765, 3.077, 5.33, 2.643)
                              ctx.bezierCurveTo(4.897, 2.209, 4.718, 2.001, 4, 2)
                              ctx.lineTo(2, 2)
                              ctx.closePath()
                              ctx.fill()
                              
                              ctx.beginPath()
                              ctx.moveTo(2, 3)
                              ctx.lineTo(4, 3)
                              ctx.bezierCurveTo(4.311, 3, 4.52, 3, 4.998, 3.471)
                              ctx.bezierCurveTo(5.477, 3.942, 5.637, 4, 5.998, 4)
                              ctx.lineTo(12, 4)
                              ctx.lineTo(14, 4)
                              ctx.bezierCurveTo(14.554, 4, 15, 4.446, 15, 5)
                              ctx.lineTo(15, 6)
                              ctx.lineTo(1, 6)
                              ctx.lineTo(1, 4)
                              ctx.bezierCurveTo(1, 3.446, 1.446, 3, 2, 3)
                              ctx.closePath()
                              ctx.fill()
                              
                              ctx.beginPath()
                              ctx.moveTo(1, 7)
                              ctx.lineTo(15, 7)
                              ctx.lineTo(15, 13)
                              ctx.bezierCurveTo(15, 13.554, 14.554, 14, 14, 14)
                              ctx.lineTo(2, 14)
                              ctx.bezierCurveTo(1.446, 14, 1, 13.554, 1, 13)
                              ctx.lineTo(1, 7)
                              ctx.closePath()
                              ctx.fill()
                            }
                            
                            onFolderColorChanged: requestPaint()
                            Component.onCompleted: requestPaint()
                          }
                        }
                        
                        // Nombre - MÁS PEQUEÑO
                        Text {
                          Layout.preferredWidth: 90
                          Layout.preferredHeight: 28
                          Layout.alignment: Qt.AlignHCenter
                          text: model.fileName || ""
                          color: Color.mOnSurface || "#e0e0e0"
                          font.family: "sans-serif"
                          font.pixelSize: 10
                          elide: Text.ElideMiddle
                          horizontalAlignment: Text.AlignHCenter
                          verticalAlignment: Text.AlignTop
                          wrapMode: Text.Wrap
                          maximumLineCount: 2
                        }
                      }
                      
                      MouseArea {
                        id: folderMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onClicked: {
                          root.selectedFolder = model.filePath
                        }
                        
                        onDoubleClicked: {
                          root.goToPath(model.filePath)
                          root.selectedFolder = ""
                        }
                      }
                      
                      // Indicador de selección
                      Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.width: 2
                        border.color: Color.mPrimary || "#c9a461"
                        radius: 8
                        visible: root.selectedFolder === model.filePath
                      }
                      
                      // Efecto hover
                      Rectangle {
                        anchors.fill: parent
                        color: Color.mPrimary || "#c9a461"
                        opacity: folderMouse.containsMouse ? 0.1 : 0
                        radius: 8
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                      }
                      
                      scale: folderMouse.pressed ? 0.95 : 1.0
                      Behavior on scale { NumberAnimation { duration: 80 } }
                    }
                  }
                }
              }
            }
          }
        }
        
        // Footer con botón de confirmar
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 56
          color: Color.mSurfaceVariant || "#2a2a2a"
          
          Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Color.mOutlineVariant || "#3a3a3a"
          }
          
          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 16
            
            Text {
              text: folderModel.count + " folders"
              color: Color.mOnSurfaceVariant || "#888888"
              font.family: "sans-serif"
              font.pixelSize: 12
            }
            
            Item { Layout.fillWidth: true }
            
            Text {
              text: root.selectedFolder ? "Selected: " + root.selectedFolder.split('/').pop() : "Select a folder"
              color: root.selectedFolder ? (Color.mPrimary || "#c9a461") : (Color.mOnSurfaceVariant || "#666666")
              font.family: "sans-serif"
              font.pixelSize: 11
              elide: Text.ElideMiddle
              Layout.maximumWidth: 300
            }
            
            Button {
              Layout.preferredWidth: 100
              Layout.preferredHeight: 36
              enabled: root.selectedFolder !== ""
              
              onClicked: {
                if (root.selectedFolder) {
                  root.folderSelected(root.selectedFolder)
                  root.panelVisible = false
                }
              }
              
              background: Rectangle {
                color: parent.enabled ? (parent.hovered ? Qt.lighter(Color.mPrimary || "#c9a461", 1.2) : (Color.mPrimary || "#c9a461")) : "#555555"
                radius: 6
                
                Behavior on color { ColorAnimation { duration: 150 } }
              }
              
              contentItem: Text {
                text: "Select"
                color: parent.enabled ? "#1e1e1e" : "#888888"
                font.family: "sans-serif"
                font.pixelSize: 13
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
              }
            }
          }
        }
      }
    }
  }
  
  FolderListModel {
    id: folderModel
    folder: root.currentPath ? ("file://" + root.currentPath) : ""
    showFiles: false
    showDirs: true
    showDotAndDotDot: false
    showHidden: false
    sortField: FolderListModel.Name
  }
}
