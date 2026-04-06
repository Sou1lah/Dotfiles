import QtQuick
import QtMultimedia
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Wayland

Scope {
  id: root
  property var pluginApi
  
  readonly property bool enabled: pluginApi.pluginSettings?.enabled ?? false
  readonly property string videoPath: pluginApi.pluginSettings?.videoPath ?? ""
  readonly property string folderPath: pluginApi.pluginSettings?.folderPath ?? ""
  readonly property string changeMode: pluginApi.pluginSettings?.changeMode ?? "manual"
  readonly property int changeInterval: pluginApi.pluginSettings?.changeInterval ?? 10
  readonly property string fillMode: pluginApi.pluginSettings?.fillMode ?? "PreserveAspectCrop"
  readonly property real volume: pluginApi.pluginSettings?.volume ?? 0
  readonly property bool loop: pluginApi.pluginSettings?.loop ?? true
  
  property string currentVideo: ""
  property var videoList: []
  
  // Forzar actualización cuando cambia fillMode
  onFillModeChanged: {
    console.log("Fill mode changed to:", fillMode)
  }
  
  readonly property string videoUrl: {
    if (changeMode === "auto") {
      if (!currentVideo) return ""
      if (currentVideo.startsWith("file://")) return currentVideo
      if (currentVideo.startsWith("/")) return "file://" + currentVideo
      return currentVideo
    } else {
      if (!videoPath) return ""
      if (videoPath.startsWith("file://")) return videoPath
      if (videoPath.startsWith("/")) return "file://" + videoPath
      return videoPath
    }
  }
  
  // FolderListModel para cargar videos
  FolderListModel {
    id: folderModel
    folder: root.folderPath && root.changeMode === "auto" ? ("file://" + root.folderPath) : ""
    nameFilters: ["*.mp4", "*.MP4", "*.webm", "*.WebM", "*.mkv", "*.MKV", "*.mov", "*.MOV", "*.gif", "*.GIF"]
    showDirs: false
    showDotAndDotDot: false
    showHidden: false
    
    onCountChanged: {
      if (root.changeMode === "auto") {
        loadVideoList()
      }
    }
  }
  
  // Timer para cambio automático
  Timer {
    id: changeTimer
    interval: root.changeInterval * 1000
    running: root.enabled && root.changeMode === "auto" && root.videoList.length > 0
    repeat: true
    
    onTriggered: {
      loadRandomVideo()
    }
  }
  
  // Cargar lista de videos desde FolderListModel
  function loadVideoList() {
    if (!folderPath || changeMode !== "auto") {
      videoList = []
      return
    }
    
    var videos = []
    for (var i = 0; i < folderModel.count; i++) {
      var filePath = folderModel.get(i, "filePath")
      if (filePath) {
        videos.push(filePath)
      }
    }
    
    videoList = videos
    console.log("Loaded", videoList.length, "videos from", folderPath)
    
    // Cargar primer video automáticamente si no hay uno actual
    if (videoList.length > 0 && !currentVideo) {
      loadRandomVideo()
    }
  }
  
  function loadRandomVideo() {
    if (videoList.length === 0) {
      console.log("No videos in list")
      return
    }
    
    var randomIndex = Math.floor(Math.random() * videoList.length)
    currentVideo = videoList[randomIndex]
    console.log("Loading random video:", currentVideo)
  }
  
  // Recargar lista cuando cambia la carpeta
  onFolderPathChanged: {
    if (changeMode === "auto") {
      loadVideoList()
    }
  }
  
  onChangeModeChanged: {
    if (changeMode === "auto") {
      loadVideoList()
    } else {
      videoList = []
      currentVideo = ""
    }
  }
  
  Component.onCompleted: {
    if (changeMode === "auto" && folderPath) {
      loadVideoList()
    }
  }
  
  Variants {
    model: Quickshell.screens
    PanelWindow {
      required property var modelData
      screen: modelData
      implicitWidth: modelData.width
      implicitHeight: modelData.height
      visible: root.enabled && root.videoUrl
      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.exclusiveZone: -1
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      anchors { top: true; bottom: true; left: true; right: true }
      color: "transparent"
      
      Rectangle {
        anchors.fill: parent
        color: "black"
        
        // AudioOutput
        AudioOutput {
          id: audioOutput
          volume: root.volume
        }
        
        // MediaPlayer
        MediaPlayer {
          id: mediaPlayer
          videoOutput: videoOutput
          audioOutput: audioOutput
          source: root.videoUrl
          loops: root.loop ? MediaPlayer.Infinite : 1
          playbackRate: 1.0
          
          Component.onCompleted: {
            if (source && root.enabled) {
              console.log("MediaPlayer initialized with fillMode:", root.fillMode)
              play()
            }
          }
          
          onSourceChanged: {
            if (source && root.enabled) {
              stop()
              play()
            }
          }
          
          onErrorOccurred: function(error, errorString) {
            console.error("Video playback error:", errorString)
            console.error("Error code:", error)
            if (source) {
              console.log("Attempting to reload video...")
              Qt.callLater(function() {
                stop()
                play()
              })
            }
          }
          
          onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState && source && root.enabled && root.loop) {
              Qt.callLater(function() {
                play()
              })
            }
          }
        }
        
        // VideoOutput - DESPUÉS de MediaPlayer
        VideoOutput {
          id: videoOutput
          anchors.fill: parent
          
          // Binding directo sin switch para forzar actualización
          property int currentFillMode: {
            if (root.fillMode === "Stretch") return VideoOutput.Stretch
            if (root.fillMode === "PreserveAspectFit") return VideoOutput.PreserveAspectFit
            if (root.fillMode === "PreserveAspectCrop") return VideoOutput.PreserveAspectCrop
            return VideoOutput.PreserveAspectCrop
          }
          
          fillMode: currentFillMode
          
          onCurrentFillModeChanged: {
            console.log("✅ FillMode CHANGED:", root.fillMode, "->", currentFillMode)
          }
        }
        
        // Área de click para cambiar wallpaper en modo auto
        MouseArea {
          anchors.fill: parent
          enabled: root.changeMode === "auto" && root.videoList.length > 0
          onClicked: {
            root.loadRandomVideo()
          }
        }
      }
    }
  }
}
