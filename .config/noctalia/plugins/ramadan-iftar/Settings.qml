import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property string valueCity: cfg.city ?? defaults.city ?? "London";
  property string valueCountry: cfg.country ?? defaults.country ?? "UK";
  property int valueMethod: cfg.method ?? defaults.method ?? 3;
  property bool valueShowAlways: cfg.showAlways ?? defaults.showAlways ?? true;
  property bool valueShowCountdown: cfg.showCountdown ?? defaults.showCountdown ?? true;

  spacing: Style.marginL

  NHeader {
    label: pluginApi?.tr("settings.location.header") || "Location"
    description: pluginApi?.tr("settings.location.desc") || "Used to fetch daily prayer times from Aladhan API."
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.city.label") || "City"
    description: pluginApi?.tr("settings.city.desc") || "Enter your city name in English."
    placeholderText: "London"
    text: root.valueCity
    onTextChanged: root.valueCity = text
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.country.label") || "Country"
    description: pluginApi?.tr("settings.country.desc") || "Enter your country name or 2-letter code."
    placeholderText: "UK"
    text: root.valueCountry
    onTextChanged: root.valueCountry = text
  }

  NComboBox {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.method.label") || "Calculation Method"
    description: pluginApi?.tr("settings.method.desc") || "Determines how prayer times are calculated."
    currentKey: String(root.valueMethod)
    model: [
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
      { "key": "15", "name": "Moonsighting Committee Worldwide" }
    ]
    onSelected: key => root.valueMethod = parseInt(key)
  }

  NDivider { Layout.fillWidth: true }

  NHeader {
    label: pluginApi?.tr("settings.display.header") || "Display"
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.showCountdown.label") || "Show countdown"
    description: pluginApi?.tr("settings.showCountdown.desc") || "Show a countdown to Iftar instead of the static time."
    checked: root.valueShowCountdown
    onToggled: checked => root.valueShowCountdown = checked
  }

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.showAlways.label") || "Show outside Ramadan"
    description: pluginApi?.tr("settings.showAlways.desc") || "Keep the bar widget visible even when it is not Ramadan."
    checked: root.valueShowAlways
    onToggled: checked => root.valueShowAlways = checked
  }

  function saveSettings() {
    if (!pluginApi) return;
    pluginApi.pluginSettings.city = root.valueCity.trim();
    pluginApi.pluginSettings.country = root.valueCountry.trim();
    pluginApi.pluginSettings.method = root.valueMethod;
    pluginApi.pluginSettings.showAlways = root.valueShowAlways;
    pluginApi.pluginSettings.showCountdown = root.valueShowCountdown;
    pluginApi.saveSettings();
    Logger.d("RamadanIftar", "Settings saved");
  }
}
