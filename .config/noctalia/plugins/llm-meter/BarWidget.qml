import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Services.UI

Item {
    id: root
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""
    property int sectionWidgetIndex: -1
    property int sectionWidgetsCount: 0
    property var pluginApi: null
    property string label: "LLM offline"
    property string details: "llm-meter daemon is unavailable"
    property var latestValue: null

    implicitWidth: pill.width
    implicitHeight: pill.height

    function consume(line) {
        try {
            const value = JSON.parse(String(line).trim())
            root.latestValue = value
            root.composeLabel()
            root.details = value.tooltip || ""
        } catch (error) {
            root.label = "LLM error"
            root.details = String(error)
        }
    }

    function compact(value) {
        const number = Number(value || 0)
        if (Math.abs(number) >= 1000000000) return (number / 1000000000).toFixed(2) + "B"
        if (Math.abs(number) >= 1000000) return (number / 1000000).toFixed(2) + "M"
        if (Math.abs(number) >= 1000) return (number / 1000).toFixed(1) + "K"
        return Math.round(number).toLocaleString()
    }

    function composeLabel() {
        const value = root.latestValue
        if (!value) return
        const settings = pluginApi?.pluginSettings || ({})
        const parts = []
        if ((settings.barShowAccount ?? true) && value.account_label)
            parts.push(value.account_label)
        if ((settings.barShowQuota ?? true) && value.percentage !== null && value.percentage !== undefined)
            parts.push(value.percentage + "%")
        if (settings.barShowTodayTokens ?? false)
            parts.push(root.compact(value.today_tokens) + " tok")
        if ((settings.barShowTodayCost ?? false) && value.today_estimated_cost_usd !== null && value.today_estimated_cost_usd !== undefined) {
            const cost = Number(value.today_estimated_cost_usd)
            parts.push("$" + cost.toFixed(cost > 0 && cost < 1 ? 3 : 2))
        }
        if (settings.barShowCodexSessions ?? false)
            parts.push(value.active_codex_sessions + " Codex")
        if ((settings.barShowTrend ?? true) && value.trend)
            parts.push(value.trend)
        root.label = parts.length ? parts.join(" ") : "LLM Meter"
    }

    onPluginApiChanged: root.composeLabel()
    Connections {
        target: pluginApi
        function onPluginSettingsChanged() { root.composeLabel() }
    }

    BarPill {
        id: pill
        screen: root.screen
        oppositeDirection: BarService.getPillDirection(root)
        icon: "chart-line"
        text: root.label
        tooltipText: root.details
        forceOpen: true
        onClicked: {
            TooltipService.hide()
            pluginApi?.togglePanel(root.screen, pill)
        }
        onRightClicked: Quickshell.execDetached([
            "/home/wael/.cargo/bin/llm-meter", "ui", "--main"
        ])
    }

    Process {
        id: watcher
        command: ["/home/wael/.cargo/bin/llm-meter", "waybar", "--watch"]
        running: true
        stdout: SplitParser { onRead: line => root.consume(line) }
    }

    Timer {
        interval: 1000
        running: !watcher.running
        onTriggered: watcher.running = true
    }
}
