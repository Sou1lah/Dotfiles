import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null

  readonly property var geometryPlaceholder: panelContainer
  property real contentPreferredWidth: 360 * Style.uiScaleRatio
  readonly property real maxHeight: 580 * Style.uiScaleRatio
  property real contentPreferredHeight: Math.min(contentColumn.implicitHeight + Style.marginL * 2, maxHeight)
  readonly property bool allowAttach: true

  anchors.fill: parent

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})
  readonly property bool use12h: Settings.data.location.use12hourFormat;

  // Shared state from Main.qml
  readonly property var mainInstance: pluginApi?.mainInstance
  readonly property var prayerTimings: mainInstance?.prayerTimings ?? null
  readonly property bool isRamadan: mainInstance ? mainInstance.isRamadan : false
  readonly property bool isLoading: mainInstance ? mainInstance.isLoading : false
  readonly property bool hasError: mainInstance ? mainInstance.hasError : false
  readonly property string errorMessage: mainInstance ? mainInstance.errorMessage : ""
  readonly property int secondsToIftar: mainInstance ? mainInstance.secondsToIftar : -1
  readonly property bool iftarPassed: mainInstance ? mainInstance.iftarPassed : false
  readonly property string hijriDateStr: mainInstance ? mainInstance.hijriDateStr : ""
  readonly property int hijriMonth: mainInstance ? mainInstance.hijriMonth : 0
  readonly property int hijriYear: mainInstance ? mainInstance.hijriYear : 0
  readonly property string hijriMonthName: mainInstance ? mainInstance.hijriMonthName : ""
  readonly property string gregorianDateStr: mainInstance ? mainInstance.gregorianDateStr : ""

  // Update countdown every second in panel
  Timer {
    interval: 1000
    running: secondsToIftar > 0
    repeat: true
    onTriggered: mainInstance?.updateCountdown()
  }

  function formatTime(rawTime) {
    if (!rawTime) return "--:--";
    if (!use12h) return rawTime;
    const parts = rawTime.split(":");
    let h = parseInt(parts[0]);
    const m = parts[1];
    const ampm = h >= 12 ? "PM" : "AM";
    h = h % 12 || 12;
    return `${h}:${m} ${ampm}`;
  }

  function formatCountdown(secs) {
    if (secs <= 0) return "";
    const h = Math.floor(secs / 3600);
    const m = Math.floor((secs % 3600) / 60);
    const s = secs % 60;
    if (h > 0) return `${h}h ${m.toString().padStart(2, "0")}m ${s.toString().padStart(2, "0")}s`;
    if (m > 0) return `${m}m ${s.toString().padStart(2, "0")}s`;
    return `${s}s`;
  }

  // Ordered list of prayer names to display
  readonly property var prayerOrder: [
    { key: "Imsak",   labelKey: "panel.suhoor",   icon: "moon",    highlight: "suhoor" },
    { key: "Fajr",    labelKey: "panel.fajr",     icon: "sunrise", highlight: "" },
    { key: "Sunrise", labelKey: "panel.sunrise",  icon: "sun",     highlight: "" },
    { key: "Dhuhr",   labelKey: "panel.dhuhr",    icon: "sun-high",highlight: "" },
    { key: "Asr",     labelKey: "panel.asr",      icon: "sun-low", highlight: "" },
    { key: "Maghrib", labelKey: "panel.iftar",    icon: "sunset",  highlight: "iftar" },
    { key: "Isha",    labelKey: "panel.isha",      icon: "moon-stars", highlight: "" }
  ]

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      id: contentColumn
      anchors {
        fill: parent
        margins: Style.marginL
      }
      spacing: Style.marginM

      // Header
      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginM

        NIcon {
          icon: "moon-stars"
          pointSize: Style.fontSizeXL
          color: Color.mPrimary
          Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
          spacing: 0

          NText {
            text: pluginApi?.tr("panel.title") || "Prayer Times"
            pointSize: Style.fontSizeL
            font.weight: Font.Bold
            color: Color.mOnSurface
          }

          NText {
            visible: hijriDateStr !== ""
            text: hijriDateStr !== "" ? `${hijriMonthName} ${hijriYear} AH` : ""
            pointSize: Style.fontSizeS
            color: isRamadan ? Color.mPrimary : Color.mSecondary
          }
        }

        Item { Layout.fillWidth: true }

        NIconButton {
          icon: "refresh"
          tooltipText: pluginApi?.tr("panel.refresh") || "Refresh"
          enabled: !isLoading
          onClicked: mainInstance?.fetchPrayerTimes()
          Layout.alignment: Qt.AlignVCenter
        }

        NIconButton {
          icon: "settings"
          tooltipText: pluginApi?.tr("menu.settings") || "Settings"
          onClicked: {
            const screen = pluginApi?.panelOpenScreen;
            if (screen) {
              pluginApi.closePanel(screen);
              Qt.callLater(() => BarService.openPluginSettings(screen, pluginApi.manifest));
            }
          }
          Layout.alignment: Qt.AlignVCenter
        }

        NIconButton {
          icon: "x"
          tooltipText: pluginApi?.tr("panel.close") || "Close"
          onClicked: {
            const screen = pluginApi?.panelOpenScreen;
            if (screen) pluginApi.closePanel(screen);
          }
          Layout.alignment: Qt.AlignVCenter
        }
      }

      // Date
      NText {
        visible: gregorianDateStr !== ""
        text: gregorianDateStr
        pointSize: Style.fontSizeS
        color: Color.mSecondary
      }

      NDivider {
        Layout.fillWidth: true;
        visible: prayerTimings === null
      }

      // Countdown or past-Iftar message
      Rectangle {
        Layout.fillWidth: true
        implicitHeight: countdownColumn.implicitHeight + Style.marginM * 2
        color: iftarPassed ? Color.mSurfaceVariant : Qt.alpha(Color.mPrimary, 0.12)
        radius: Style.radiusL
        visible: prayerTimings !== null

        ColumnLayout {
          id: countdownColumn
          anchors.centerIn: parent
          spacing: Style.marginXS

          NText {
            Layout.alignment: Qt.AlignHCenter
            text: {
              if (iftarPassed) return pluginApi?.tr("panel.iftarPassed") || "Iftar has passed";
              return pluginApi?.tr("panel.iftarIn") || "Iftar in";
            }
            pointSize: Style.fontSizeS
            color: iftarPassed ? Color.mSecondary : Color.mPrimary
          }

          NText {
            Layout.alignment: Qt.AlignHCenter
            visible: !iftarPassed && secondsToIftar > 0
            text: formatCountdown(secondsToIftar)
            pointSize: Style.fontSizeXXL
            font.weight: Font.Bold
            color: Color.mPrimary
          }

          NText {
            Layout.alignment: Qt.AlignHCenter
            visible: !iftarPassed && prayerTimings !== null && prayerTimings.Maghrib !== undefined
            text: formatTime(prayerTimings?.Maghrib || "")
            pointSize: iftarPassed ? Style.fontSizeXL : Style.fontSizeM
            color: iftarPassed ? Color.mOnSurface : Color.mSecondary
          }
        }
      }

      // Loading / error state
      Item {
        Layout.fillWidth: true
        implicitHeight: Style.baseWidgetSize
        visible: isLoading || hasError

        NBusyIndicator {
          anchors.centerIn: parent
          visible: isLoading
          running: isLoading
        }

        NText {
          anchors.centerIn: parent
          visible: hasError && !isLoading
          text: errorMessage || (pluginApi?.tr("error.generic") || "Failed to load prayer times")
          color: Color.mError
          pointSize: Style.fontSizeS
          wrapMode: Text.Wrap
          horizontalAlignment: Text.AlignHCenter
          width: parent.width
        }
      }

      // Prayer times list
      NScrollView {
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(prayerListColumn.implicitHeight, root.maxHeight * 0.6)
        horizontalPolicy: ScrollBar.AlwaysOff
        reserveScrollbarSpace: false
        visible: prayerTimings !== null

        ColumnLayout {
          id: prayerListColumn
          width: parent.width
          spacing: Style.marginS

          Repeater {
            model: root.prayerOrder

            delegate: Rectangle {
              required property var modelData

              readonly property string rawTime: prayerTimings?.[modelData.key] || ""
              readonly property bool isHighlightIftar: modelData.highlight === "iftar"
              readonly property bool isHighlightSuhoor: modelData.highlight === "suhoor"
              readonly property bool isHighlighted: isHighlightIftar || isHighlightSuhoor

              Layout.fillWidth: true
              implicitWidth: parent.width
              implicitHeight: rowLayout.implicitHeight + Style.marginS * 2
              radius: Style.radiusM
              color: {
                if (isHighlightIftar) return Qt.alpha(Color.mPrimary, 0.15);
                if (isHighlightSuhoor) return Qt.alpha(Color.mSecondary, 0.12);
                return Color.mSurfaceVariant;
              }

              RowLayout {
                id: rowLayout
                anchors {
                  fill: parent
                  leftMargin: Style.marginM
                  rightMargin: Style.marginM
                  topMargin: Style.marginS
                  bottomMargin: Style.marginS
                }
                spacing: Style.marginM

                NIcon {
                  icon: modelData.icon
                  pointSize: Style.fontSizeM
                  color: isHighlightIftar ? Color.mPrimary : (isHighlightSuhoor ? Color.mSecondary : Color.mOnSurfaceVariant)
                  Layout.alignment: Qt.AlignVCenter
                }

                NText {
                  text: pluginApi?.tr(modelData.labelKey) || modelData.key
                  pointSize: Style.fontSizeM
                  font.weight: isHighlighted ? Style.fontWeightSemiBold : Style.fontWeightRegular
                  color: isHighlightIftar ? Color.mPrimary : (isHighlightSuhoor ? Color.mSecondary : Color.mOnSurface)
                  Layout.fillWidth: true
                  Layout.alignment: Qt.AlignVCenter
                }

                NText {
                  text: rawTime ? formatTime(rawTime) : "—"
                  pointSize: Style.fontSizeM
                  font.weight: isHighlighted ? Style.fontWeightBold : Style.fontWeightRegular
                  color: isHighlightIftar ? Color.mPrimary : (isHighlightSuhoor ? Color.mSecondary : Color.mOnSurface)
                  Layout.alignment: Qt.AlignVCenter
                }
              }
            }
          }
        }
      }

      // Empty state
      Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        visible: prayerTimings === null && !isLoading && !hasError

        ColumnLayout {
          anchors.centerIn: parent
          spacing: Style.marginM

          NIcon {
            icon: "moon-stars"
            pointSize: Style.fontSizeXXXL
            color: Color.mSecondary
            Layout.alignment: Qt.AlignHCenter
          }

          NText {
            text: pluginApi?.tr("panel.configure") || "Configure your city in settings"
            color: Color.mSecondary
            pointSize: Style.fontSizeM
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
          }
        }
      }
    }
  }
}
