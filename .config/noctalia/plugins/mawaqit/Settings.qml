import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null
  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})
  property var methods: [
    { "key": "1",  "name": "University of Islamic Sciences, Karachi" },
    { "key": "2",  "name": "Islamic Society of North America (ISNA)" },
    { "key": "3",  "name": "Muslim World League (MWL)" },
    { "key": "4",  "name": "Umm Al-Qura University, Makkah" },
    { "key": "5",  "name": "Egyptian General Authority of Survey" },
    { "key": "7",  "name": "Institute of Geophysics, Tehran" },
    { "key": "8",  "name": "Gulf Region" },
    { "key": "9",  "name": "Kuwait" },
    { "key": "10", "name": "Qatar" },
    { "key": "11", "name": "Majlis Ugama Islam Singapura" },
    { "key": "12", "name": "Union Organization Islamic de France" },
    { "key": "13", "name": "Diyanet İşleri Başkanlığı, Turkey" },
    { "key": "14", "name": "Spiritual Administration of Muslims of Russia" },
    { "key": "15", "name": "Moonsighting Committee Worldwide" },
    { "key": "16", "name": "Dubai (Experimental)" },
    { "key": "19", "name": "Algeria" },
    { "key": "99", "name": "Manual ID" }
  ]

  property string valueCity:              cfg.city              ?? defaults.city              ?? "London"
  property string valueCountry:           cfg.country           ?? defaults.country           ?? "UK"
  property int    valueMethod:            cfg.method            ?? defaults.method            ?? 3
  readonly property bool valueMethodCustom: {
    const match = root.methods.find(m => m.key === String(root.valueMethod))
    return !match || match.key === "99"
  }
  property string valueMethodCustomInput: valueMethodCustom     ? String(root.valueMethod)         : ""
  property bool   valueTune:              cfg.tune              ?? defaults.tune              ?? false
  property int    valueTuneFajr:          cfg.tuneFajr          ?? defaults.tuneFajr          ?? 0
  property int    valueTuneDhuhr:         cfg.tuneDhuhr         ?? defaults.tuneDhuhr         ?? 0
  property int    valueTuneAsr:           cfg.tuneAsr           ?? defaults.tuneAsr           ?? 0
  property int    valueTuneMaghrib:       cfg.tuneMaghrib       ?? defaults.tuneMaghrib       ?? 0
  property int    valueTuneIsha:          cfg.tuneIsha          ?? defaults.tuneIsha          ?? 0
  property int    valueSchool:            cfg.school            ?? defaults.school            ?? 0
  property bool   valueShowCountdown:     cfg.showCountdown     ?? defaults.showCountdown     ?? true
  property bool   valueShowElapsed:       cfg.showElapsed       ?? defaults.showElapsed       ?? false
  property bool   valueHidePrayerName:    cfg.hidePrayerName    ?? defaults.hidePrayerName    ?? false
  property bool   valueShowNotifications: cfg.showNotifications ?? defaults.showNotifications ?? true
  property bool   valuePlayAzan:          cfg.playAzan          ?? defaults.playAzan          ?? false
  property string valueAzanFile:          cfg.azanFile          ?? defaults.azanFile          ?? "azan1.mp3"
  property int    valueHijriDayOffset:    cfg.hijriDayOffset    ?? defaults.hijriDayOffset    ?? 0
  property int    valueWeekStartDay:      cfg.weekStartDay      ?? defaults.weekStartDay      ?? 1
  property string valueWidgetIcon:        cfg.widgetIcon        ?? defaults.widgetIcon        ?? "building-mosque"
  property bool   valueDynamicIcon:       cfg.dynamicIcon       ?? defaults.dynamicIcon       ?? false
  property string valueTextColor:         cfg.textColor         ?? defaults.textColor         ?? "none"
  property string valueIconColor:         cfg.iconColor         ?? defaults.iconColor         ?? "none"
  property string valueActiveColor:       cfg.activeColor       ?? defaults.activeColor       ?? "primary"

  property bool previewing: false

  spacing: Style.marginL

  // ── Location ──────────────────────────────────────────────────────────────

  NHeader {
    label: pluginApi?.tr("settings.location.header")
    description: pluginApi?.tr("settings.location.desc")
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.city.label")
    description: pluginApi?.tr("settings.city.desc")
    placeholderText: "London"
    text: root.valueCity
    onTextChanged: root.valueCity = text
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.country.label")
    description: pluginApi?.tr("settings.country.desc")
    placeholderText: "UK"
    text: root.valueCountry
    onTextChanged: root.valueCountry = text
  }

  NComboBox {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.method.label")
    description: pluginApi?.tr("settings.method.desc")
    currentKey: valueMethodCustom ? 99 : String(root.valueMethod)
    model: root.methods
    onSelected: key => {
      root.valueMethod = parseInt(key)
    }
  }

  NTextInput {
    Layout.fillWidth: true
    visible: root.valueMethodCustom
    label: pluginApi?.tr("settings.methodCustom.label")
    description: pluginApi?.tr("settings.methodCustom.desc")
    placeholderText: "e.g. 19"
    text: root.valueMethodCustomInput
    onTextChanged: {
      root.valueMethodCustomInput = text
      const n = parseInt(text)
      if (!isNaN(n) && n > 0) root.valueMethod = n
    }
  }


  NComboBox {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.school.label")
    description: pluginApi?.tr("settings.school.desc")
    currentKey: String(root.valueSchool)
    model: [
      { "key": "0", "name": "Shafi / Maliki / Hanbali (Default)" },
      { "key": "1", "name": "Hanafi" }
    ]
    onSelected: key => root.valueSchool = parseInt(key)
  }

  NDivider { Layout.fillWidth: true }

  // ── Calibration ───────────────────────────────────────────────────────────

  NHeader {
    label: pluginApi?.tr("settings.calibration.header")
    description: pluginApi?.tr("settings.calibration.desc")
  }

  NComboBox {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.hijriDayOffset.label")
    description: pluginApi?.tr("settings.hijriDayOffset.desc")
    currentKey: String(root.valueHijriDayOffset)
    model: [
      { "key": "-1", "name": "−1 day" },
      { "key": "0",  "name": "Default (from API)" },
      { "key": "1",  "name": "+1 day" }
    ]
    onSelected: key => root.valueHijriDayOffset = parseInt(key)
  }

  NHeader {
    label: pluginApi?.tr("settings.tune.header")
    description: pluginApi?.tr("settings.tune.desc")
    Layout.bottomMargin: -Style.marginM
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.tune.enable")
    checked: root.valueTune
    onToggled: checked => root.valueTune = checked
  }

  Repeater {
    model: [
      { key: "Fajr",    labelKey: "settings.tune.fajr"    },
      { key: "Dhuhr",   labelKey: "settings.tune.dhuhr"   },
      { key: "Asr",     labelKey: "settings.tune.asr"     },
      { key: "Maghrib", labelKey: "settings.tune.maghrib"  },
      { key: "Isha",    labelKey: "settings.tune.isha"     }
    ]
    delegate: NTextInput {
      visible: root.valueTune
      required property var modelData
      Layout.fillWidth: true
      label: pluginApi?.tr(modelData.labelKey)
      placeholderText: "0"
      text: {
        const v = modelData.key === "Fajr"    ? root.valueTuneFajr
               : modelData.key === "Dhuhr"   ? root.valueTuneDhuhr
               : modelData.key === "Asr"     ? root.valueTuneAsr
               : modelData.key === "Maghrib" ? root.valueTuneMaghrib
               :                               root.valueTuneIsha
        return v === 0 ? "" : String(v)
      }
      onTextChanged: {
        const n = parseInt(text)
        const v = isNaN(n) ? 0 : n
        if      (modelData.key === "Fajr")    root.valueTuneFajr    = v
        else if (modelData.key === "Dhuhr")   root.valueTuneDhuhr   = v
        else if (modelData.key === "Asr")     root.valueTuneAsr     = v
        else if (modelData.key === "Maghrib") root.valueTuneMaghrib = v
        else                                  root.valueTuneIsha    = v
      }
    }
  }

  NDivider { Layout.fillWidth: true }

  // ── Calendar ──────────────────────────────────────────────────────────────

  NHeader {
    label: pluginApi?.tr("settings.calendar.header")
    Layout.bottomMargin: -Style.marginM
  }

  NComboBox {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.weekStartDay.label")
    description: pluginApi?.tr("settings.weekStartDay.desc")
    currentKey: String(root.valueWeekStartDay)
    model: [
      { "key": "6", "name": "Saturday" },
      { "key": "0", "name": "Sunday"   },
      { "key": "1", "name": "Monday"   }
    ]
    onSelected: key => root.valueWeekStartDay = parseInt(key)
  }

  NDivider { Layout.fillWidth: true }

  // ── Display ───────────────────────────────────────────────────────────────

  NHeader {
    label: pluginApi?.tr("settings.display.header")
    Layout.bottomMargin: -Style.marginM
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.showCountdown.label")
    description: pluginApi?.tr("settings.showCountdown.desc")
    checked: root.valueShowCountdown
    onToggled: checked => root.valueShowCountdown = checked
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.showElapsed.label")
    description: pluginApi?.tr("settings.showElapsed.desc")
    checked: root.valueShowElapsed
    onToggled: checked => root.valueShowElapsed = checked
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.hidePrayerName.label")
    description: pluginApi?.tr("settings.hidePrayerName.desc")
    checked: root.valueHidePrayerName
    onToggled: checked => root.valueHidePrayerName = checked
  }

  NDivider { Layout.fillWidth: true }

  NHeader {
    label: pluginApi?.tr("settings.styling.header")
    Layout.bottomMargin: -Style.marginM
  }

  RowLayout {
    Layout.fillWidth: true
    spacing: Style.marginM

    NTextInput {
      id: widgetIconInput
      Layout.fillWidth: true
      label: pluginApi?.tr("settings.widgetIcon.label")
      placeholderText: "building-mosque"
      text: root.valueWidgetIcon
      onTextChanged: root.valueWidgetIcon = text.trim()
    }

    NIcon {
      icon: root.valueWidgetIcon || "building-mosque"
      pointSize: Style.fontSizeXL
      color: Color.mPrimary
      Layout.alignment: Qt.AlignBottom
      Layout.bottomMargin: Style.marginM
    }

    NIconButton {
      icon: "search"
      tooltipText: "Browse icons"
      Layout.alignment: Qt.AlignBottom
      Layout.bottomMargin: Style.marginXS
      onClicked: {
        mainIconPicker.open();
      }
    }

    NIconPicker {
      id: mainIconPicker
      initialIcon: root.valueWidgetIcon
      onIconSelected: function (iconName) {
        root.valueWidgetIcon = iconName;
        wigetIconInput.text = iconName;
      }
    }
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.dynamicIcon.label")
    description: pluginApi?.tr("settings.dynamicIcon.desc")
    checked: root.valueDynamicIcon
    onToggled: checked => root.valueDynamicIcon = checked
  }

  NColorChoice {
    label: pluginApi?.tr("settings.textColor.label")
    currentKey: root.valueTextColor
    onSelected: key => { root.valueTextColor = key; }
  }

  NColorChoice {
    label: pluginApi?.tr("settings.iconColor.label")
    currentKey: root.valueIconColor
    onSelected: key => { root.valueIconColor = key; }
  }

  NColorChoice {
    label: pluginApi?.tr("settings.activeColor.label")
    description: pluginApi?.tr("settings.activeColor.desc")
    currentKey: root.valueActiveColor
    onSelected: key => { root.valueActiveColor = key; }
  }

  NDivider { Layout.fillWidth: true }

  // ── Notifications ─────────────────────────────────────────────────────────

  NHeader {
    label: pluginApi?.tr("settings.notifications.header")
    Layout.bottomMargin: -Style.marginM
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.showNotifications.label")
    description: pluginApi?.tr("settings.notifications.desc")
    checked: root.valueShowNotifications
    onToggled: checked => root.valueShowNotifications = checked
  }

  NDivider { Layout.fillWidth: true }

  // ── Azan ──────────────────────────────────────────────────────────────────

  NHeader {
    label: pluginApi?.tr("settings.azan.header")
    Layout.bottomMargin: -Style.marginM
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.playAzan.label")
    description: pluginApi?.tr("settings.azan.desc")
    checked: root.valuePlayAzan
    onToggled: checked => {
      root.valuePlayAzan = checked
      if (!checked && root.previewing) {
        pluginApi?.mainInstance?.stopAzanFile()
        root.previewing = false
      }
    }
  }

  RowLayout {
    Layout.fillWidth: true
    visible: root.valuePlayAzan
    spacing: Style.marginM
    Layout.alignment: Qt.AlignVCenter

    NComboBox {
      Layout.fillWidth: true
      label: pluginApi?.tr("settings.azanFile.label")
      description: pluginApi?.tr("settings.azanFile.desc")
      currentKey: root.valueAzanFile
      model: [
        { "key": "azan1.mp3", "name": pluginApi?.tr("settings.azan1") },
        { "key": "azan2.mp3", "name": pluginApi?.tr("settings.azan2") },
        { "key": "azan3.mp3", "name": pluginApi?.tr("settings.azan3") }
      ]
      onSelected: key => {
        root.valueAzanFile = key
        if (root.previewing) {
          pluginApi?.mainInstance?.stopAzanFile()
          Qt.callLater(() => pluginApi?.mainInstance?.playAzanFile(root.valueAzanFile))
        }
      }
    }

    NIconButton {
      Layout.alignment: Qt.AlignBottom
      Layout.bottomMargin: Style.marginS
      Layout.preferredHeight: Math.round(Style.baseWidgetSize * 1.1 * Style.uiScaleRatio)
      Layout.preferredWidth: Math.round(Style.baseWidgetSize * 1.1 * Style.uiScaleRatio)
      icon: root.previewing ? "player-stop-filled" : "player-play-filled"
      tooltipText: root.previewing
        ? pluginApi?.tr("settings.azan.stop")
        : pluginApi?.tr("settings.azan.preview")
      onClicked: {
        const main = pluginApi?.mainInstance
        if (!main) return
        if (root.previewing) {
          main.stopAzanFile()
          root.previewing = false
        } else {
          main.playAzanFile(root.valueAzanFile)
          root.previewing = true
        }
      }
    }
  }

  Connections {
    target: pluginApi?.mainInstance ?? null
    function onAzanPlayingChanged() {
      if (pluginApi?.mainInstance && !pluginApi.mainInstance.azanPlaying)
        root.previewing = false
    }
  }

  function saveSettings() {
    if (!pluginApi) return
    if (root.previewing) {
      pluginApi?.mainInstance?.stopAzanFile()
      root.previewing = false
    }
    pluginApi.pluginSettings.city              = root.valueCity.trim()
    pluginApi.pluginSettings.country           = root.valueCountry.trim()
    pluginApi.pluginSettings.method            = root.valueMethod
    pluginApi.pluginSettings.showCountdown     = root.valueShowCountdown
    pluginApi.pluginSettings.showElapsed       = root.valueShowElapsed
    pluginApi.pluginSettings.hidePrayerName    = root.valueHidePrayerName
    pluginApi.pluginSettings.showNotifications = root.valueShowNotifications
    pluginApi.pluginSettings.playAzan          = root.valuePlayAzan
    pluginApi.pluginSettings.azanFile          = root.valueAzanFile
    pluginApi.pluginSettings.school            = root.valueSchool
    pluginApi.pluginSettings.hijriDayOffset    = root.valueHijriDayOffset
    pluginApi.pluginSettings.weekStartDay      = root.valueWeekStartDay
    pluginApi.pluginSettings.tune              = root.valueTune
    pluginApi.pluginSettings.tuneFajr          = root.valueTuneFajr
    pluginApi.pluginSettings.tuneDhuhr         = root.valueTuneDhuhr
    pluginApi.pluginSettings.tuneAsr           = root.valueTuneAsr
    pluginApi.pluginSettings.tuneMaghrib       = root.valueTuneMaghrib
    pluginApi.pluginSettings.tuneIsha          = root.valueTuneIsha
    pluginApi.pluginSettings.widgetIcon        = root.valueWidgetIcon
    pluginApi.pluginSettings.dynamicIcon       = root.valueDynamicIcon
    pluginApi.pluginSettings.textColor         = root.valueTextColor
    pluginApi.pluginSettings.iconColor         = root.valueIconColor
    pluginApi.pluginSettings.activeColor       = root.valueActiveColor
    pluginApi.saveSettings()
    Logger.d("Mawaqit", "Settings saved")
  }
}
