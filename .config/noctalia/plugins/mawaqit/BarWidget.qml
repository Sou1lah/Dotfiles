import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null

  property ShellScreen screen
  property string widgetId: ""
  property string section: ""
  property int sectionWidgetIndex: -1
  property int sectionWidgetsCount: 0

  readonly property string screenName:   screen?.name ?? ""
  readonly property string barPosition:  Settings.getBarPositionForScreen(screenName)
  readonly property bool   isVertical:   barPosition === "left" || barPosition === "right"
  readonly property real   capsuleHeight: Style.getCapsuleHeightForScreen(screenName)
  readonly property real   barFontSize:  Style.getBarFontSizeForScreen(screenName)

  property var cfg:      pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  readonly property bool showCountdown:  cfg.showCountdown  ?? defaults.showCountdown  ?? true
  readonly property bool showElapsed:    cfg.showElapsed    ?? defaults.showElapsed    ?? false
  readonly property bool hidePrayerName: cfg.hidePrayerName ?? defaults.hidePrayerName ?? false

  readonly property string widgetIcon:   cfg.widgetIcon     ?? defaults.widgetIcon     ?? "building-mosque"
  readonly property bool   dynamicIcon:  cfg.dynamicIcon    ?? defaults.dynamicIcon    ?? false
  readonly property string textColor:    cfg.textColor      ?? defaults.textColor      ?? "none"
  readonly property string iconColor:    cfg.iconColor      ?? defaults.iconColor      ?? "none"
  readonly property string activeColor:  cfg.activeColor    ?? defaults.activeColor    ?? "primary"

  readonly property bool use12h:   Settings.data.location.use12hourFormat

  readonly property var    mainInstance:   pluginApi?.mainInstance
  readonly property var    prayerTimings:  mainInstance?.prayerTimings  ?? null
  readonly property bool   isRamadan:      mainInstance?.isRamadan      ?? false
  readonly property bool   isLoading:      mainInstance?.isLoading      ?? false
  readonly property bool   hasError:       mainInstance?.hasError       ?? false
  readonly property int    secondsToNext:  mainInstance?.secondsToNext  ?? -1
  readonly property string nextPrayerName: mainInstance?.nextPrayerName ?? ""
  readonly property bool   azanPlaying:    mainInstance?.azanPlaying    ?? false
  readonly property bool   isJumuah:       mainInstance?.isJumuah       ?? false

  readonly property int    secondsElapsed:  mainInstance?.secondsElapsed ?? -1
  readonly property string lastPrayerName:  mainInstance?.lastPrayerName ?? ""
  readonly property bool   isElapsed:       showElapsed && secondsElapsed >= 0

  readonly property bool prayerNow: secondsToNext === 0 && nextPrayerName !== ""

  Timer {
    interval: 1000
    running: (secondsToNext > 0 && secondsToNext <= 3600) || isElapsed
    repeat: true
    onTriggered: mainInstance?.updateCountdown()
  }

  readonly property string nextPrayerLabel: {
    if (nextPrayerName === "Dhuhr" && isJumuah) return "Jumu'ah"
    return nextPrayerName
  }

  readonly property string lastPrayerLabel: {
    const key = mainInstance?.getPrayer(lastPrayerName)?.labelKey ?? ""
    if (!key) return ""
    return pluginApi?.tr(key)
  }

  readonly property string nextPrayerTimeStr: {
    if (!prayerTimings || !nextPrayerName) return "--:--"
    const raw = prayerTimings[nextPrayerName]
    if (!raw) return "--:--"
    if (!use12h) return raw
    const parts = raw.split(":")
    let h = parseInt(parts[0])
    const m = parts[1]
    const ampm = h >= 12 ? "PM" : "AM"
    h = h % 12 || 12
    return `${h}:${m} ${ampm}`
  }

  readonly property string countdownStr: {
    if (secondsToNext <= 0) return ""
    const h = Math.floor(secondsToNext / 3600)
    const m = Math.floor((secondsToNext % 3600) / 60)
    if (h > 0) return `${h}h ${m}m`
    if (m > 0) return `${m}m`
    return pluginApi?.tr("widget.soon")
  }

  readonly property string elapsedStr: {
    if (secondsElapsed < 0) return ""
    if (secondsElapsed < 60) return pluginApi?.tr("widget.now")
    const h = Math.floor(secondsElapsed / 3600)
    const m = Math.floor((secondsElapsed % 3600) / 60)
    if (h > 0) return `+${h}h ${m}m`
    return `+${m}m`
  }

  readonly property string tooltipText: {
    if (!prayerTimings) return pluginApi?.tr("widget.tooltip.noData")
    return `${nextPrayerLabel}: ${nextPrayerTimeStr}\n${pluginApi?.tr("widget.tooltip.countdown")}: ${countdownStr}`
  }

  readonly property string displayIcon: {
    if (!dynamicIcon || (!nextPrayerName && !lastPrayerName)) return root.widgetIcon
    return mainInstance?.getPrayer(isElapsed ? lastPrayerName : nextPrayerName)?.icon ?? root.widgetIcon
  }

  readonly property string displayText: {
    if (isLoading && !prayerTimings) return "..."
    if (hasError) return "!"
    if (!prayerTimings || !nextPrayerName) return "—"

    if (isElapsed) {
      if (hidePrayerName) return elapsedStr
      return `${lastPrayerLabel} ${elapsedStr}`
    }

    if (prayerNow) {
      if (hidePrayerName) return pluginApi?.tr("widget.now")
      return `${nextPrayerLabel} · ${pluginApi?.tr("widget.now")}`
    }

    if (showCountdown && secondsToNext > 0) {
      if (hidePrayerName) return countdownStr
      return `${nextPrayerLabel} ${countdownStr}`
    }

    if (hidePrayerName) return nextPrayerTimeStr
    return `${nextPrayerLabel} ${nextPrayerTimeStr}`
  }

  readonly property string verticalLine1: {
    if (isLoading && !prayerTimings) return "..."
    if (hasError) return "!"
    if (!prayerTimings || !nextPrayerName) return "—"

    if (isElapsed)    return hidePrayerName ? elapsedStr    : lastPrayerLabel
    if (hidePrayerName) {
      if (prayerNow)                          return pluginApi?.tr("widget.now")
      if (showCountdown && secondsToNext > 0) return countdownStr
      return nextPrayerTimeStr
    }
    return nextPrayerLabel
  }

  readonly property string verticalLine2: {
    if (!prayerTimings || !nextPrayerName) return ""
    if (isElapsed)      return hidePrayerName ? "" : elapsedStr
    if (hidePrayerName) return ""
    if (prayerNow)      return pluginApi?.tr("widget.now")
    if (showCountdown && secondsToNext > 0) return countdownStr
    return nextPrayerTimeStr
  }

  readonly property real iconSize: Style.toOdd(capsuleHeight * 0.55)

  readonly property real contentWidth: {
    if (isVertical) return capsuleHeight
    let w = iconSize + Style.marginS + labelText.implicitWidth + Style.marginM * 2
    if (azanPlaying) w += Style.marginS + iconSize + Style.marginS + iconSize
    return w
  }
  readonly property real contentHeight: isVertical
    ? capsuleHeight * 2
    : capsuleHeight

  implicitWidth:  contentWidth
  implicitHeight: contentHeight

  Rectangle {
    id: capsule
    x: Style.pixelAlignCenter(parent.width,  width)
    y: Style.pixelAlignCenter(parent.height, height)
    width:  root.contentWidth
    height: root.contentHeight
    radius: Style.radiusL
    color:        Style.capsuleColor
    border.color: azanPlaying ? Color.mPrimary : Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    Behavior on color        { ColorAnimation { duration: Style.animationFast } }
    Behavior on border.color { ColorAnimation { duration: Style.animationFast } }

    // ── Horizontal layout ─────────────────────────────────────────────
    RowLayout {
      id: hLayout
      anchors.fill: parent
      anchors.leftMargin:  Style.marginM
      anchors.rightMargin: Style.marginM
      spacing: Style.marginS
      visible: !isVertical

      NIcon {
        icon: root.displayIcon
        pointSize: root.iconSize
        color: Color.resolveColorKey(prayerNow || isElapsed ? root.activeColor : root.iconColor)
        Layout.alignment: Qt.AlignVCenter
      }

      NIcon {
        icon: "volume"
        pointSize: root.iconSize
        color: Color.mPrimary
        visible: azanPlaying
        Layout.alignment: Qt.AlignVCenter
        SequentialAnimation on opacity {
          running: azanPlaying
          loops: Animation.Infinite
          NumberAnimation { to: 0.3; duration: 600 }
          NumberAnimation { to: 1.0; duration: 600 }
        }
      }

      NText {
        id: labelText
        text: root.displayText
        pointSize: root.barFontSize
        applyUiScale: false
        color: Color.resolveColorKey(prayerNow || isElapsed ? root.activeColor : root.textColor)
        Layout.alignment: Qt.AlignVCenter
        Behavior on color { ColorAnimation { duration: 300 } }
      }

      NIcon {
        id: stopIconH
        icon: "player-stop-filled"
        pointSize: root.iconSize
        color: stopAreaH.containsMouse ? Color.mError : Color.mOnSurface
        visible: azanPlaying
        Layout.alignment: Qt.AlignVCenter
      }
    }

    // ── Vertical layout ───────────────────────────────────────────────
    ColumnLayout {
      anchors.centerIn: parent
      spacing: Style.marginXS
      visible: isVertical

      RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: Style.marginXS

        NIcon {
          icon: root.displayIcon
          pointSize: Style.toOdd(root.capsuleHeight * 0.45)
          color: Color.resolveColorKey(prayerNow || isElapsed ? root.activeColor : root.iconColor)
        }

        NIcon {
          icon: "volume"
          pointSize: Style.toOdd(root.capsuleHeight * 0.38)
          color: Color.mPrimary
          visible: azanPlaying
          SequentialAnimation on opacity {
            running: azanPlaying
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 600 }
            NumberAnimation { to: 1.0; duration: 600 }
          }
        }
      }

      NText {
        text: root.verticalLine1
        pointSize: root.barFontSize * 0.7
        applyUiScale: false
        font.weight: Font.Medium
        color: Color.resolveColorKey(prayerNow || isElapsed ? root.activeColor : root.textColor)
        Layout.alignment: Qt.AlignHCenter
        Behavior on color { ColorAnimation { duration: 300 } }
      }

      NText {
        text: root.verticalLine2
        pointSize: root.barFontSize * 0.7
        applyUiScale: false
        opacity: 0.75
        color: Color.resolveColorKey(prayerNow || isElapsed ? root.activeColor : root.textColor)
        Layout.alignment: Qt.AlignHCenter
        visible: root.verticalLine2 !== ""
        Behavior on color { ColorAnimation { duration: 300 } }
      }

      NIcon {
        id: stopIconV
        icon: "player-stop-filled"
        pointSize: root.iconSize
        color: stopAreaV.containsMouse ? Color.mError : Color.mOnSurface
        visible: azanPlaying
        Layout.alignment: Qt.AlignHCenter
      }
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      acceptedButtons: Qt.LeftButton | Qt.RightButton

      onClicked: mouse => {
        if (azanPlaying) return
        if (mouse.button === Qt.LeftButton) {
          if (pluginApi) pluginApi.openPanel(root.screen, root)
        } else if (mouse.button === Qt.RightButton) {
          PanelService.showContextMenu(contextMenu, root, screen)
        }
      }

      onEntered: TooltipService.show(root, tooltipText, BarService.getTooltipDirection(root.screen?.name))
      onExited:  TooltipService.hide()
    }

    MouseArea {
      id: stopAreaH
      visible: azanPlaying && !isVertical
      x: stopIconH.x + hLayout.x
      y: 0
      width:  stopIconH.width + Style.marginM
      height: parent.height
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: mouse => {
        mouse.accepted = true
        mainInstance?.stopAzanFile()
      }
      onEntered: TooltipService.show(stopIconH, pluginApi?.tr("widget.stopAzan"), BarService.getTooltipDirection(root.screen?.name))
      onExited:  TooltipService.hide()
    }

    MouseArea {
      id: stopAreaV
      visible: azanPlaying && isVertical
      x: stopIconV.x
      y: stopIconV.y
      width:  stopIconV.width
      height: stopIconV.height
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: mouse => {
        mouse.accepted = true
        mainInstance?.stopAzanFile()
      }
      onEntered: TooltipService.show(stopIconV, pluginApi?.tr("widget.stopAzan"), BarService.getTooltipDirection(root.screen?.name))
      onExited:  TooltipService.hide()
    }
  }

  NPopupContextMenu {
    id: contextMenu
    model: [
      { "label": pluginApi?.tr("menu.openPanel"), "action": "open", "icon": root.widgetIcon },
      { "label": pluginApi?.tr("menu.settings"),  "action": "settings", "icon": "settings" }
    ]
    onTriggered: function(action) {
      contextMenu.close()
      PanelService.closeContextMenu(screen)
      if (action === "open") {
        pluginApi.openPanel(root.screen, root)
      } else if (action === "settings") {
        BarService.openPluginSettings(root.screen, pluginApi.manifest)
      }
    }
  }
}
