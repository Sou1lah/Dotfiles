import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.Commons
import qs.Widgets

Scope {
  id: root
  
  property string currentPath: Qt.platform.os === "linux" ? 
    (Qt.application.arguments[0] ? Qt.application.arguments[0].replace(/\/[^\/]*$/, "") : "/home") : "/home"
  property var pathHistory: []
  property bool panelVisible: false
  
  signal videoSelected(string path)
  
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
  }
  
  function hide() {
    panelVisible = false
  }
  
  function goBack() {
    if (pathHistory.length > 1) {
      pathHistory.pop()
      currentPath = pathHistory[pathHistory.length - 1]
      pathHistory = pathHistory.slice()
    }
  }
  
  function goToPath(path) {
    pathHistory.push(path)
    currentPath = path
    pathHistory = pathHistory.slice()
  }
  
  function goHome() {
    currentPath = pathHistory[0]
    pathHistory = [currentPath]
  }
  
  function setFolderPath(path) {
    if (path) {
      currentPath = path
      pathHistory = [path]
    }
  }
  
  // Función para generar PNG solo cuando se escoge el video
  function generateThumbnailForVideo(videoPath, folderPath) {
    var videoName = videoPath.split('/').pop().replace(/\.[^/.]+$/, "")
    var thumbPath = folderPath + "/" + videoName + ".png"
    
    // Generar PNG con software decoder (evita errores AV1)
    var cmd = "ffmpeg -hwaccel none -i '" + videoPath + 
              "' -vframes 1 -vf 'scale=160:-1' '" + thumbPath + "' -y 2>/dev/null"
    
    thumbnailProcess.command = ["sh", "-c", cmd]
    thumbnailProcess.running = true
  }
  
  // Process para generar thumbnail cuando se escoge
  Process {
    id: thumbnailProcess
    running: false
    
    onExited: function(exitCode) {
      if (exitCode === 0) {
        console.log("Thumbnail generated successfully")
      } else {
        console.log("Failed to generate thumbnail")
      }
      running = false
    }
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
        
        // Header con navegación
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
        
        // Área de contenido con scroll
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
                
                width: {
                  var cols = Math.floor((parent.width - 48) / 200)
                  if (cols < 1) cols = 1
                  return cols * 200
                }
                
                spacing: 20
                
                Repeater {
                  model: folderModel
                  
                  delegate: Item {
                    width: 180
                    height: 200
                    
                    Rectangle {
                      anchors.fill: parent
                      color: "transparent"
                      
                      ColumnLayout {
                        anchors.fill: parent
                        spacing: 8
                        
                        // Miniatura o icono
                        Rectangle {
                          Layout.preferredWidth: 180
                          Layout.preferredHeight: 140
                          color: Color.mSurfaceVariant || "#2a2a2a"
                          radius: 8
                          clip: true
                          
                          // Icono de carpeta (solo para directorios)
                          Canvas {
                            anchors.centerIn: parent
                            width: 64
                            height: 64
                            visible: model.fileIsDir
                            
                            property color folderColor: Color.mPrimary || "#c9a461"
                            
                            onPaint: {
                              var ctx = getContext("2d");
                              ctx.reset();
                              ctx.fillStyle = folderColor;
                              
                              var scale = 4;
                              ctx.scale(scale, scale);
                              
                              ctx.beginPath();
                              ctx.moveTo(2, 2);
                              ctx.bezierCurveTo(0.892, 2, 0, 2.892, 0, 4);
                              ctx.lineTo(0, 13);
                              ctx.bezierCurveTo(0, 14.108, 0.892, 15, 2, 15);
                              ctx.lineTo(14, 15);
                              ctx.bezierCurveTo(15.108, 15, 16, 14.108, 16, 13);
                              ctx.lineTo(16, 5);
                              ctx.bezierCurveTo(16, 3.892, 15.108, 3, 14, 3);
                              ctx.lineTo(8, 3);
                              ctx.lineTo(6.37, 3);
                              ctx.bezierCurveTo(5.79, 2.977, 5.765, 3.077, 5.33, 2.643);
                              ctx.bezierCurveTo(4.897, 2.209, 4.718, 2.001, 4, 2);
                              ctx.lineTo(2, 2);
                              ctx.closePath();
                              ctx.fill();
                              
                              ctx.beginPath();
                              ctx.moveTo(2, 3);
                              ctx.lineTo(4, 3);
                              ctx.bezierCurveTo(4.311, 3, 4.52, 3, 4.998, 3.471);
                              ctx.bezierCurveTo(5.477, 3.942, 5.637, 4, 5.998, 4);
                              ctx.lineTo(12, 4);
                              ctx.lineTo(14, 4);
                              ctx.bezierCurveTo(14.554, 4, 15, 4.446, 15, 5);
                              ctx.lineTo(15, 6);
                              ctx.lineTo(1, 6);
                              ctx.lineTo(1, 4);
                              ctx.bezierCurveTo(1, 3.446, 1.446, 3, 2, 3);
                              ctx.closePath();
                              ctx.fill();
                              
                              ctx.beginPath();
                              ctx.moveTo(1, 7);
                              ctx.lineTo(15, 7);
                              ctx.lineTo(15, 13);
                              ctx.bezierCurveTo(15, 13.554, 14.554, 14, 14, 14);
                              ctx.lineTo(2, 14);
                              ctx.bezierCurveTo(1.446, 14, 1, 13.554, 1, 13);
                              ctx.lineTo(1, 7);
                              ctx.closePath();
                              ctx.fill();
                            }
                            
                            onFolderColorChanged: requestPaint()
                          }
                          
                          // Loader para video thumbnails
                          Loader {
                            anchors.fill: parent
                            visible: !model.fileIsDir
                            active: !model.fileIsDir && root.panelVisible
                            
                            property string videoPath: model.filePath
                            property int loadKey: root.currentPath + "-" + model.index
                            
                            sourceComponent: Component {
                              Item {
                                anchors.fill: parent
                                
                                VideoOutput {
                                  id: videoOutput
                                  anchors.fill: parent
                                  fillMode: VideoOutput.PreserveAspectCrop
                                }
                                
                                AudioOutput {
                                  id: audioOutput
                                  muted: true
                                }
                                
                                MediaPlayer {
                                  id: mediaPlayer
                                  videoOutput: videoOutput
                                  audioOutput: audioOutput
                                  source: "file://" + videoPath
                                  
                                  Component.onCompleted: {
                                    loadTimer.start()
                                  }
                                  
                                  onErrorOccurred: function(error, errorString) {
                                    console.log("Preview error for", videoPath, ":", errorString)
                                  }
                                }
                                
                                Timer {
                                  id: loadTimer
                                  interval: 50 + (model.index * 20)
                                  repeat: false
                                  onTriggered: {
                                    if (mediaPlayer && mediaPlayer.source) {
                                      mediaPlayer.pause()
                                      mediaPlayer.setPosition(1000)
                                    }
                                  }
                                }
                                
                                Rectangle {
                                  anchors.centerIn: parent
                                  width: 40
                                  height: 40
                                  radius: 20
                                  color: "#40000000"
                                  visible: mediaPlayer.playbackState === MediaPlayer.StoppedState
                                  
                                  Text {
                                    anchors.centerIn: parent
                                    text: "⏸"
                                    color: "#ffffff"
                                    font.pixelSize: 20
                                  }
                                }
                              }
                            }
                          }
                          
                          // Badge de formato
                          Rectangle {
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 6
                            width: fileTypeText.width + 12
                            height: 20
                            color: "#cc000000"
                            radius: 4
                            visible: !model.fileIsDir
                            
                            Text {
                              id: fileTypeText
                              anchors.centerIn: parent
                              text: {
                                const fileName = model.fileName || ""
                                const ext = fileName.split('.').pop().toUpperCase()
                                return ext || "VIDEO"
                              }
                              color: "#ffffff"
                              font.family: "monospace"
                              font.pixelSize: 10
                              font.weight: Font.Bold
                            }
                          }
                        }
                        
                        // Nombre
                        Text {
                          Layout.preferredWidth: 180
                          Layout.preferredHeight: 40
                          text: model.fileName || ""
                          color: Color.mOnSurface || "#e0e0e0"
                          font.family: "sans-serif"
                          font.pixelSize: 12
                          font.weight: model.fileIsDir ? Font.Medium : Font.Normal
                          elide: Text.ElideMiddle
                          wrapMode: Text.Wrap
                          maximumLineCount: 2
                          horizontalAlignment: Text.AlignHCenter
                          verticalAlignment: Text.AlignTop
                        }
                      }
                      
                      MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        
                        onClicked: {
                          if (model.fileIsDir) {
                            root.goToPath(model.filePath)
                          } else {
                            root.generateThumbnailForVideo(model.filePath, root.currentPath)
                            root.videoSelected(model.filePath)
                            root.panelVisible = false
                          }
                        }
                      }
                      
                      scale: itemMouse.pressed ? 0.96 : 1.0
                      Behavior on scale { NumberAnimation { duration: 80 } }
                    }
                  }
                }
              }
            }
          }
        }
        
        // Footer
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 40
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
              text: {
                let videos = 0
                let dirs = 0
                for (let i = 0; i < folderModel.count; i++) {
                  if (folderModel.get(i, "fileIsDir")) {
                    dirs++
                  } else {
                    videos++
                  }
                }
                return videos + " videos · " + dirs + " folders"
              }
              color: Color.mOnSurfaceVariant || "#888888"
              font.family: "sans-serif"
              font.pixelSize: 12
              Layout.fillWidth: true
            }
            
            Text {
              text: "Click to select video"
              color: Color.mOnSurfaceVariant || "#666666"
              font.family: "sans-serif"
              font.pixelSize: 11
              opacity: 0.7
            }
          }
        }
      }
    }
  }
  
  FolderListModel {
    id: folderModel
    folder: root.currentPath ? ("file://" + root.currentPath) : ""
    nameFilters: ["*.mp4", "*.MP4", "*.webm", "*.WebM", "*.mkv", "*.MKV", "*.mov", "*.MOV", "*.avi", "*.AVI", "*.gif", "*.GIF"]
    showDirs: true
    showDotAndDotDot: false
    showHidden: false
    sortField: FolderListModel.Name
  }
}
