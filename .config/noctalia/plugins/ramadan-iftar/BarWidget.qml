import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null

  // Required properties for bar widgets
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""
  property int sectionWidgetIndex: -1
  property int sectionWidgetsCount: 0

  // Bar positioning helpers
  readonly property string screenName: screen ? screen.name : ""
  readonly property string barPosition: Settings.getBarPositionForScreen(screenName)
  readonly property bool isVertical: barPosition === "left" || barPosition === "right"
  readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)
  readonly property real barFontSize: Style.getBarFontSizeForScreen(screenName)

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  readonly property bool use12h: Settings.data.location.use12hourFormat;
  readonly property bool showAlways: cfg.showAlways ?? defaults.showAlways ?? true;
  readonly property bool showCountdown: cfg.showCountdown ?? defaults.showCountdown ?? true;

  // Access shared state from Main.qml
  readonly property var mainInstance: pluginApi?.mainInstance
  readonly property var prayerTimings: mainInstance ? mainInstance.prayerTimings : null
  readonly property bool isRamadan: mainInstance ? mainInstance.isRamadan : false
  readonly property bool isLoading: mainInstance ? mainInstance.isLoading : false
  readonly property bool hasError: mainInstance ? mainInstance.hasError : false
  readonly property int secondsToIftar: mainInstance ? mainInstance.secondsToIftar : -1
  readonly property bool iftarPassed: mainInstance ? mainInstance.iftarPassed : false

  readonly property bool shouldShow: isRamadan || showAlways

  visible: shouldShow
  opacity: shouldShow ? 1.0 : 0.0

  // Per-second countdown update when within 1 hour of Iftar
  Timer {
    id: secondTimer
    interval: 1000
    running: secondsToIftar > 0 && secondsToIftar <= 3600
    repeat: true
    onTriggered: mainInstance?.updateCountdown()
  }

  readonly property string iftarTimeStr: {
    if (!prayerTimings?.Maghrib) return "--:--";
    if (use12h) {
      const parts = prayerTimings.Maghrib.split(":");
      let h = parseInt(parts[0]);
      const m = parts[1];
      const ampm = h >= 12 ? "PM" : "AM";
      h = h % 12 || 12;
      return `${h}:${m} ${ampm}`;
    }
    return prayerTimings.Maghrib;
  }

  readonly property string suhoorTimeStr: {
    const t = prayerTimings?.Imsak || prayerTimings?.Fajr;
    if (!t) return "--:--";
    if (use12h) {
      const parts = t.split(":");
      let h = parseInt(parts[0]);
      const m = parts[1];
      const ampm = h >= 12 ? "PM" : "AM";
      h = h % 12 || 12;
      return `${h}:${m} ${ampm}`;
    }
    return t;
  }

  readonly property string countdownStr: {
    if (secondsToIftar <= 0) return "";
    const h = Math.floor(secondsToIftar / 3600);
    const m = Math.floor((secondsToIftar % 3600) / 60);
    if (h > 0) return `${h}h ${m}m`;
    if (m > 0) return `${m}m`;
    return pluginApi?.tr("widget.soon") || "soon";
  }

  readonly property string displayText: {
    if (isLoading && !prayerTimings) return "...";
    if (hasError) return "!";
    if (!prayerTimings) return "—";
    if (iftarPassed) {
      return `${pluginApi?.tr("widget.suhoor") || "Suhoor"} ${suhoorTimeStr}`;
    }
    if (showCountdown && secondsToIftar > 0) {
      return countdownStr;
    }
    return iftarTimeStr;
  }

  readonly property string tooltipText: {
    if (!prayerTimings) return pluginApi?.tr("widget.tooltip.noData") || "No prayer data";
    if (iftarPassed) {
      return `${pluginApi?.tr("widget.suhoor") || "Suhoor"}: ${suhoorTimeStr}`;
    }
    return `${pluginApi?.tr("widget.iftar") || "Iftar"}: ${iftarTimeStr}\n${pluginApi?.tr("widget.tooltip.countdown") || "Time remaining"}: ${countdownStr}`;
  }

  readonly property real iconSize: Style.toOdd(capsuleHeight * 0.55)

  readonly property real contentWidth: {
    if (isVertical) return capsuleHeight;
    return iconSize + labelText.implicitWidth + Style.marginS + Style.marginM * 3;
  }
  readonly property real contentHeight: isVertical ? capsuleHeight + Style.marginM * 2 : capsuleHeight

  implicitWidth: contentWidth
  implicitHeight: contentHeight

  Rectangle {
    id: capsule
    x: Style.pixelAlignCenter(parent.width, width)
    y: Style.pixelAlignCenter(parent.height, height)
    width: root.contentWidth
    height: root.contentHeight
    radius: Style.radiusL
    color: mouseArea.containsMouse ? Color.mHover : Style.capsuleColor
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    Behavior on color {
      ColorAnimation { duration: Style.animationFast }
    }

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: Style.marginM
      anchors.rightMargin: Style.marginM
      spacing: Style.marginS
      visible: !isVertical

      NIcon {
        icon: "moon-stars"
        pointSize: root.iconSize
        color: mouseArea.containsMouse ? Color.mOnHover : Color.mPrimary
        Layout.alignment: Qt.AlignVCenter
      }

      NText {
        id: labelText
        text: root.displayText
        pointSize: root.barFontSize
        applyUiScale: false
        color: mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
        Layout.alignment: Qt.AlignVCenter
      }
    }

    // Vertical layout
    ColumnLayout {
      anchors.centerIn: parent
      spacing: Style.marginXS
      visible: isVertical

      NIcon {
        icon: "moon-stars"
        pointSize: Style.toOdd(root.capsuleHeight * 0.45)
        color: mouseArea.containsMouse ? Color.mOnHover : Color.mPrimary
        Layout.alignment: Qt.AlignHCenter
      }

      NText {
        text: root.displayText
        pointSize: root.barFontSize * 0.65
        applyUiScale: false
        color: mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
        Layout.alignment: Qt.AlignHCenter
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    onClicked: mouse => {
      if (mouse.button === Qt.LeftButton) {
        if (pluginApi) pluginApi.openPanel(root.screen, root);
      } else if (mouse.button === Qt.RightButton) {
        PanelService.showContextMenu(contextMenu, root, screen);
      }
    }

    onEntered: {
      TooltipService.show(root, tooltipText, BarService.getTooltipDirection(root.screen?.name));
    }

    onExited: {
      TooltipService.hide();
    }
  }

  NPopupContextMenu {
    id: contextMenu

    model: [
      {
        "label": pluginApi?.tr("menu.openPanel") || "Open Prayer Times",
        "action": "open",
        "icon": "moon-stars"
      },
      {
        "label": pluginApi?.tr("menu.settings") || "Widget Settings",
        "action": "settings",
        "icon": "settings"
      }
    ]

    onTriggered: function (action) {
      contextMenu.close();
      PanelService.closeContextMenu(screen);
      if (action === "open") {
        pluginApi.openPanel(root.screen, root);
      } else if (action === "settings") {
        BarService.openPluginSettings(root.screen, pluginApi.manifest);
      }
    }
  }
}
