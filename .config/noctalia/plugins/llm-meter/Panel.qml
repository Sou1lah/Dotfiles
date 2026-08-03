import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets

Item {
    id: root
    property var pluginApi: null
    readonly property var geometryPlaceholder: panelContainer
    readonly property bool allowAttach: true
    property real contentPreferredWidth: Math.round(420 * Style.uiScaleRatio)
    property real contentPreferredHeight: Math.round(480 * Style.uiScaleRatio)
    property color panelBackgroundColor: Qt.alpha(Color.mSurface, 0.78)
    readonly property color glassCardColor: Qt.alpha(Color.mSurfaceVariant, 0.56)

    property string activePage: "overview"
    property bool offline: false
    property string accountName: "LLM Meter"
    property string connectionStatus: "正在读取"
    property string quotaName: "当前额度"
    property int quotaPercent: -1
    property string quotaResetsAt: "—"
    property string quotaForecast: "正在积累本地用量样本"
    property string todayTokens: "—"
    property string todayCost: "—"
    property string modelSummary: "Provider 未返回模型维度"
    property var trendValues: [0, 0, 0, 0, 0, 0, 0]
    property real trendMaximum: 1
    property string trendTotal: "—"
    property var connections: []
    property var localCodex: ({ active_sessions: [], models: [] })
    property string actionMessage: ""
    property string pendingRemoveId: ""
    property string budgetAmount: "20"
    property bool loginCancelled: false
    property bool autostartEnabled: false
    property bool autostartActive: false
    property bool autostartKnown: false

    readonly property string cli: Quickshell.env("HOME") + "/.local/bin/llm-meter"
    readonly property bool busy: actionProcess.running || loginProcess.running
    readonly property var resetSummaries: root.connections
        .map(connection => connection.rate_limit_reset_credits)
        .filter(summary => summary !== null && summary !== undefined)
    readonly property int resetAvailableCount: root.resetSummaries
        .reduce((total, summary) => total + Number(summary.available_count || 0), 0)
    readonly property var resetCreditItems: root.resetSummaries
        .reduce((items, summary) => items.concat(summary.credits || []), [])
    readonly property bool resetDetailsKnown: root.resetSummaries
        .some(summary => summary.credits !== null && summary.credits !== undefined)
    readonly property bool hasSubscription: root.connections
        .some(connection => connection.connection_type === "chatgpt_subscription")
    readonly property var nearestResetCredit: {
        const now = Date.now()
        const available = root.resetCreditItems.filter(credit =>
            credit.status === "available" && credit.expires_at && new Date(credit.expires_at).getTime() > now)
        available.sort((left, right) => new Date(left.expires_at).getTime() - new Date(right.expires_at).getTime())
        return available.length ? available[0] : null
    }
    readonly property bool nearestResetUrgent: root.nearestResetCredit
        && new Date(root.nearestResetCredit.expires_at).getTime() - Date.now() < 24 * 60 * 60 * 1000

    function statusText(status) {
        const labels = {
            "ready": "已同步", "syncing": "同步中", "connecting": "连接中",
            "stale": "数据陈旧", "offline": "离线", "auth_required": "需要认证",
            "rate_limited": "已限流", "provider_error": "Provider 错误",
            "disabled": "已停用"
        }
        return labels[status] || status || "未知"
    }

    function compact(value) {
        const number = Number(value || 0)
        if (Math.abs(number) >= 1000000) return (number / 1000000).toFixed(2) + "M"
        if (Math.abs(number) >= 1000) return (number / 1000).toFixed(1) + "K"
        return Math.round(number).toLocaleString()
    }

    function localDateTime(value) {
        if (!value) return "永久有效"
        const date = new Date(value)
        if (isNaN(date.getTime())) return "未知"
        return date.toLocaleString(Qt.locale(), "yyyy-MM-dd HH:mm")
    }

    function localDateKey(date) {
        const year = date.getFullYear()
        const month = String(date.getMonth() + 1).padStart(2, "0")
        const day = String(date.getDate()).padStart(2, "0")
        return year + "-" + month + "-" + day
    }

    function resetStatusText(status) {
        const labels = {
            "available": "可使用", "redeeming": "使用中",
            "redeemed": "已使用", "unknown": "未知"
        }
        return labels[status] || status || "未知"
    }

    function consume(text) {
        try {
            const snapshot = JSON.parse(String(text))
            const items = snapshot.connections || []
            root.connections = items
            root.localCodex = snapshot.local_codex || ({ active_sessions: [], models: [] })
            root.offline = false
            const now = new Date()
            const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
            const keys = []
            for (let index = 6; index >= 0; index--) {
                const date = new Date(today)
                date.setDate(date.getDate() - index)
                keys.push(root.localDateKey(date))
            }
            const values = [0, 0, 0, 0, 0, 0, 0]
            const localDaily = root.localCodex.daily_usage || []
            const hasLocalHistory = localDaily.length > 0
            localDaily.forEach(usage => {
                const index = keys.indexOf(String(usage.date || ""))
                if (index >= 0) values[index] = Number(usage.total_tokens || 0)
            })
            root.trendValues = values
            root.trendMaximum = Math.max.apply(null, values.concat([1]))
            root.trendTotal = root.compact(values.reduce((sum, value) => sum + value, 0)) + " Token"
            root.todayTokens = root.compact(root.localCodex.today_tokens || 0)
            const hasLocalTodayCost = root.localCodex.today_estimated_cost_usd !== null
                && root.localCodex.today_estimated_cost_usd !== undefined
            const localTodayCost = hasLocalTodayCost ? Number(root.localCodex.today_estimated_cost_usd) : 0
            root.todayCost = hasLocalTodayCost
                ? "$" + localTodayCost.toFixed(localTodayCost > 0 && localTodayCost < 1 ? 4 : 2)
                : "—"
            if (!items.length) {
                root.accountName = "尚未添加连接"
                root.connectionStatus = "可在设置中登录"
                root.quotaPercent = -1
                root.modelSummary = "登录后显示模型用量"
                return
            }

            root.accountName = items[0].display_name || "LLM Meter"
            root.connectionStatus = root.statusText(items[0].status)

            let selectedQuota = null
            items.forEach(connection => (connection.quota_windows || []).forEach(quota => {
                if (quota.remaining_ratio === null || quota.remaining_ratio === undefined) return
                if (!selectedQuota || Number(quota.remaining_ratio) < Number(selectedQuota.remaining_ratio)) selectedQuota = quota
            }))
            root.quotaPercent = selectedQuota ? Math.round(Number(selectedQuota.remaining_ratio) * 100) : -1
            root.quotaName = selectedQuota ? (selectedQuota.display_name || "当前额度") : "当前额度"
            root.quotaResetsAt = selectedQuota && selectedQuota.resets_at ? root.localDateTime(selectedQuota.resets_at) : "—"
            const forecast = root.localCodex.weekly_quota_forecast
            if (forecast) {
                root.quotaForecast = forecast.exhausts_at
                    ? "按近期速度预计 " + root.localDateTime(forecast.exhausts_at) + " 用完"
                    : "按近期速度，本周期预计不会用完"
            } else {
                root.quotaForecast = "正在积累本地用量样本"
            }

            const models = new Set()

            if (!hasLocalHistory) items.forEach(connection => {
                const metrics = connection.metrics || []
                const totals = metrics.filter(metric => metric.metric_key === "token.total" && metric.period_start && keys.includes(metric.period_start.slice(0, 10)))
                const source = totals.length ? totals : metrics.filter(metric =>
                    (metric.metric_key === "token.input" || metric.metric_key === "token.output") && metric.period_start
                )
                source.forEach(metric => {
                    const index = keys.indexOf(metric.period_start.slice(0, 10))
                    if (index >= 0) values[index] += Number(metric.value || 0)
                })
                metrics.forEach(metric => {
                    if (metric.dimensions && metric.dimensions.model) models.add(metric.dimensions.model)
                })
            })

            const total = values.reduce((sum, value) => sum + value, 0)
            root.trendValues = values
            root.trendMaximum = Math.max.apply(null, values.concat([1]))
            root.trendTotal = root.compact(total) + " Token"
            root.todayTokens = root.compact(values[6])
            root.modelSummary = models.size ? Array.from(models).slice(0, 3).join(" · ") + (models.size > 3 ? " 等" : "") : "Provider 未返回模型维度"
        } catch (error) {
            root.offline = true
            root.connectionStatus = "daemon 离线"
        }
    }

    function refresh() {
        if (!snapshotProcess.running) snapshotProcess.running = true
    }

    function refreshAutostart() {
        if (!autostartStatusProcess.running) autostartStatusProcess.running = true
    }

    function runAction(arguments, pendingText) {
        if (root.busy) return
        root.actionMessage = pendingText
        actionProcess.command = [root.cli].concat(arguments)
        actionProcess.running = true
    }

    function saveBarSetting(key, value) {
        if (!root.pluginApi?.pluginSettings) return
        root.pluginApi.pluginSettings[key] = value
        root.pluginApi.saveSettings()
    }

    function startLogin() {
        if (root.busy) return
        root.loginCancelled = false
        root.actionMessage = "已打开浏览器，正在等待登录完成…"
        loginProcess.running = true
    }

    Component.onCompleted: {
        refresh()
        refreshAutostart()
    }
    onActivePageChanged: {
        if (activePage === "settings") refreshAutostart()
    }
    onVisibleChanged: {
        if (visible) {
            root.activePage = "overview"
            root.actionMessage = ""
            root.pendingRemoveId = ""
            root.refresh()
        }
    }

    Process {
        id: snapshotProcess
        command: [root.cli, "status"]
        stdout: StdioCollector {}
        onExited: exitCode => {
            if (exitCode === 0) root.consume(snapshotProcess.stdout.text)
            else {
                root.offline = true
                root.connectionStatus = "daemon 离线"
            }
        }
    }

    Process {
        id: actionProcess
        stdout: StdioCollector {}
        stderr: StdioCollector {}
        onExited: exitCode => {
            root.pendingRemoveId = ""
            root.actionMessage = exitCode === 0 ? "操作成功，数据已刷新" : "操作失败：" + String(actionProcess.stderr.text).trim()
            if (actionProcess.command.length > 1 && actionProcess.command[1] === "autostart")
                root.refreshAutostart()
            root.refresh()
        }
    }

    Process {
        id: autostartStatusProcess
        command: [root.cli, "autostart", "status"]
        stdout: StdioCollector {}
        onExited: exitCode => {
            if (exitCode !== 0) {
                root.autostartKnown = false
                return
            }
            try {
                const status = JSON.parse(String(autostartStatusProcess.stdout.text))
                root.autostartEnabled = status.enabled === true
                root.autostartActive = status.active === true
                root.autostartKnown = true
            } catch (error) {
                root.autostartKnown = false
            }
        }
    }

    Process {
        id: loginProcess
        command: [root.cli, "add", "subscription", "--open", "--name", "OpenAI ChatGPT"]
        stdout: StdioCollector {}
        stderr: StdioCollector {}
        onExited: exitCode => {
            if (root.loginCancelled)
                root.actionMessage = "已取消登录"
            else
                root.actionMessage = exitCode === 0 ? "登录成功，正在刷新用量…" : "登录未完成：" + String(loginProcess.stderr.text).trim()
            root.refresh()
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: root.visible && !root.busy
        onTriggered: root.refresh()
    }

    Rectangle {
        id: panelContainer
        anchors.fill: parent
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.marginL
            spacing: Style.marginM

            NBox {
                color: root.glassCardColor
                clip: true
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width
                implicitHeight: headerRow.implicitHeight + Style.margin2M
                RowLayout {
                    id: headerRow
                    anchors.fill: parent
                    anchors.margins: Style.marginM
                    spacing: Style.marginS
                    NIcon {
                        icon: root.activePage === "settings" ? "settings" : (root.activePage === "resets" ? "restore" : (root.activePage === "local" ? "terminal-2" : "chart-line"))
                        pointSize: Style.fontSizeXXL
                        color: root.offline ? Color.mError : Color.mPrimary
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        Layout.preferredWidth: 1
                        spacing: 0
                        NText {
                            text: root.activePage === "settings" ? "LLM Meter 设置" : (root.activePage === "resets" ? "Reset 额度" : (root.activePage === "local" ? "本地 Codex" : root.accountName))
                            pointSize: Style.fontSizeL
                            font.weight: Style.fontWeightBold
                            color: Color.mOnSurface
                            Layout.fillWidth: true
                            Layout.minimumWidth: 0
                            elide: Text.ElideRight
                        }
                        NText {
                            text: root.activePage === "settings" ? "连接、登录与预算" : (root.activePage === "resets" ? "ChatGPT 订阅重置机会" : (root.activePage === "local" ? "运行会话、模型与 API 等价费用" : root.connectionStatus))
                            pointSize: Style.fontSizeXS
                            color: root.offline ? Color.mError : Color.mOnSurfaceVariant
                            Layout.fillWidth: true
                            Layout.minimumWidth: 0
                            elide: Text.ElideRight
                        }
                    }
                    NIconButton {
                        visible: root.activePage === "overview" && root.hasSubscription
                        icon: "restore"
                        tooltipText: "Reset 额度"
                        baseSize: Style.baseWidgetSize * 0.72
                        onClicked: {
                            root.activePage = "resets"
                            root.actionMessage = ""
                            root.pendingRemoveId = ""
                        }
                    }
                    NIconButton {
                        visible: root.activePage === "overview"
                        icon: "terminal-2"
                        tooltipText: "本地 Codex"
                        baseSize: Style.baseWidgetSize * 0.72
                        onClicked: {
                            root.activePage = "local"
                            root.actionMessage = ""
                        }
                    }
                    NIconButton {
                        icon: root.activePage === "overview" ? "settings" : "arrow-left"
                        tooltipText: root.activePage === "overview" ? "设置" : "返回概览"
                        baseSize: Style.baseWidgetSize * 0.72
                        onClicked: {
                            root.activePage = root.activePage === "overview" ? "settings" : "overview"
                            root.actionMessage = ""
                            root.pendingRemoveId = ""
                        }
                    }
                    NIconButton {
                        icon: "refresh"
                        tooltipText: "强制刷新全部数据"
                        baseSize: Style.baseWidgetSize * 0.72
                        enabled: !root.busy
                        onClicked: root.runAction(["refresh-all"], "正在刷新全部连接与本地 Codex…")
                    }
                    NIconButton {
                        icon: "close"
                        tooltipText: "关闭"
                        baseSize: Style.baseWidgetSize * 0.72
                        onClicked: pluginApi?.closePanel(pluginApi?.panelOpenScreen)
                    }
                }
            }

            Loader {
                Layout.fillWidth: true
                Layout.fillHeight: true
                sourceComponent: root.activePage === "settings" ? settingsPage : (root.activePage === "resets" ? resetsPage : (root.activePage === "local" ? localCodexPage : overviewPage))
            }
        }
    }

    Component {
        id: localCodexPage
        Flickable {
            clip: true
            contentWidth: width
            contentHeight: localCodexColumn.implicitHeight
            boundsBehavior: Flickable.StopAtBounds

            ColumnLayout {
                id: localCodexColumn
                width: parent.width
                spacing: Style.marginM

                NBox {
                    color: root.glassCardColor
                    Layout.fillWidth: true
                    implicitHeight: localSummary.implicitHeight + Style.margin2M
                    ColumnLayout {
                        id: localSummary
                        anchors.fill: parent
                        anchors.margins: Style.marginM
                        spacing: Style.marginXS
                        RowLayout {
                            Layout.fillWidth: true
                            NIcon { icon: "terminal-2"; color: Color.mPrimary; pointSize: Style.fontSizeXL }
                            NText { text: (root.localCodex.active_sessions || []).length + " 个运行中会话"; color: Color.mOnSurface; font.weight: Style.fontWeightBold; Layout.fillWidth: true }
                            NText {
                                text: root.localCodex.estimated_cost_usd !== null && root.localCodex.estimated_cost_usd !== undefined
                                    ? "$" + Number(root.localCodex.estimated_cost_usd).toFixed(2) : "—"
                                color: Color.mPrimary
                                pointSize: Style.fontSizeXL
                                font.weight: Style.fontWeightBold
                            }
                        }
                        NText {
                            text: "当前运行会话累计的 API 等价费用估算；ChatGPT 订阅不会按此金额额外收费"
                            color: Color.mOnSurfaceVariant
                            pointSize: Style.fontSizeXS
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }
                }

                Repeater {
                    model: root.localCodex.models || []
                    NBox {
                        required property var modelData
                        color: root.glassCardColor
                        Layout.fillWidth: true
                        implicitHeight: modelUsageColumn.implicitHeight + Style.margin2M
                        ColumnLayout {
                            id: modelUsageColumn
                            anchors.fill: parent
                            anchors.margins: Style.marginM
                            spacing: Style.marginXS
                            RowLayout {
                                Layout.fillWidth: true
                                NText { text: modelData.model; color: Color.mOnSurface; font.weight: Style.fontWeightBold; Layout.fillWidth: true; elide: Text.ElideRight }
                                NText {
                                    text: modelData.estimated_cost_usd !== null && modelData.estimated_cost_usd !== undefined
                                        ? "$" + Number(modelData.estimated_cost_usd).toFixed(2) : "价格未知"
                                    color: Color.mPrimary
                                }
                            }
                            NText {
                                text: "输入 " + root.compact(modelData.input_tokens) + " · 缓存 " + root.compact(modelData.cached_input_tokens)
                                    + " · 输出 " + root.compact(modelData.output_tokens)
                                color: Color.mOnSurfaceVariant
                                pointSize: Style.fontSizeXS
                                Layout.fillWidth: true
                            }
                        }
                    }
                }

                Repeater {
                    model: root.localCodex.active_sessions || []
                    NBox {
                        required property var modelData
                        color: root.glassCardColor
                        Layout.fillWidth: true
                        implicitHeight: sessionColumn.implicitHeight + Style.margin2M
                        ColumnLayout {
                            id: sessionColumn
                            anchors.fill: parent
                            anchors.margins: Style.marginM
                            spacing: Style.marginXS
                            NText { text: modelData.model + " · " + root.compact(modelData.total_tokens) + " Token"; color: Color.mOnSurface; font.weight: Style.fontWeightSemiBold; Layout.fillWidth: true }
                            NText { text: modelData.cwd || modelData.id; color: Color.mOnSurfaceVariant; pointSize: Style.fontSizeXS; elide: Text.ElideMiddle; Layout.fillWidth: true }
                        }
                    }
                }

                NText {
                    text: "官方标准处理价格 · 更新于 " + (root.localCodex.pricing_as_of || "未知")
                    color: Color.mOnSurfaceVariant
                    pointSize: Style.fontSizeXS
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }
    }

    Component {
        id: resetsPage
        Flickable {
            clip: true
            contentWidth: width
            contentHeight: resetsColumn.implicitHeight
            boundsBehavior: Flickable.StopAtBounds

            ColumnLayout {
                id: resetsColumn
                width: parent.width
                spacing: Style.marginM

                NBox {
                    color: root.glassCardColor
                    Layout.fillWidth: true
                    implicitHeight: resetSummaryColumn.implicitHeight + Style.margin2M
                    ColumnLayout {
                        id: resetSummaryColumn
                        anchors.fill: parent
                        anchors.margins: Style.marginM
                        spacing: Style.marginXS
                        RowLayout {
                            Layout.fillWidth: true
                            NIcon { icon: "restore"; color: Color.mPrimary; pointSize: Style.fontSizeXL }
                            NText { text: "剩余 Reset 机会"; color: Color.mOnSurfaceVariant; Layout.fillWidth: true }
                            NText {
                                text: root.resetSummaries.length ? root.resetAvailableCount + " 次" : "—"
                                color: Color.mPrimary
                                pointSize: Style.fontSizeXXL
                                font.weight: Style.fontWeightBold
                            }
                        }
                        NText {
                            text: root.resetSummaries.length
                                ? (root.resetDetailsKnown ? "以下时间均为本地时间" : "Provider 仅返回总次数，暂未提供逐条过期时间")
                                : "尚未获取 Reset 额度，请刷新订阅连接"
                            color: Color.mOnSurfaceVariant
                            pointSize: Style.fontSizeXS
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }
                }

                Repeater {
                    model: root.resetCreditItems
                    NBox {
                        required property var modelData
                        color: root.glassCardColor
                        Layout.fillWidth: true
                        implicitHeight: resetCreditColumn.implicitHeight + Style.margin2M
                        ColumnLayout {
                            id: resetCreditColumn
                            anchors.fill: parent
                            anchors.margins: Style.marginM
                            spacing: Style.marginXS
                            RowLayout {
                                Layout.fillWidth: true
                                NText {
                                    text: modelData.title || "Full reset"
                                    color: Color.mOnSurface
                                    font.weight: Style.fontWeightSemiBold
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                NText {
                                    text: root.resetStatusText(modelData.status)
                                    color: modelData.status === "available" ? Color.mPrimary : Color.mOnSurfaceVariant
                                    pointSize: Style.fontSizeXS
                                }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                NIcon { icon: "calendar-clock"; color: Color.mPrimary; pointSize: Style.fontSizeM }
                                NText { text: "过期"; color: Color.mOnSurfaceVariant; pointSize: Style.fontSizeXS }
                                NText {
                                    text: root.localDateTime(modelData.expires_at)
                                    color: Color.mOnSurface
                                    font.weight: Style.fontWeightSemiBold
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignRight
                                }
                            }
                        }
                    }
                }

                NBox {
                    visible: root.resetSummaries.length > 0 && root.resetDetailsKnown && root.resetCreditItems.length < root.resetAvailableCount
                    color: root.glassCardColor
                    Layout.fillWidth: true
                    implicitHeight: partialDetailsText.implicitHeight + Style.margin2M
                    NText {
                        id: partialDetailsText
                        anchors.fill: parent
                        anchors.margins: Style.marginM
                        text: "服务端返回了 " + root.resetAvailableCount + " 次机会，但仅提供 " + root.resetCreditItems.length + " 条明细。"
                        color: Color.mOnSurfaceVariant
                        pointSize: Style.fontSizeXS
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }

    Component {
        id: overviewPage
        ColumnLayout {
            spacing: Style.marginM
            NBox {
                color: root.glassCardColor
                Layout.fillWidth: true
                implicitHeight: quotaColumn.implicitHeight + Style.margin2M
                ColumnLayout {
                    id: quotaColumn
                    anchors.fill: parent
                    anchors.margins: Style.marginM
                    spacing: Style.marginS
                    RowLayout {
                        Layout.fillWidth: true
                        NText { text: root.quotaName; color: Color.mOnSurfaceVariant; Layout.fillWidth: true }
                        NText { text: root.quotaPercent >= 0 ? root.quotaPercent + "% 剩余" : "额度未提供"; font.weight: Style.fontWeightBold; color: Color.mOnSurface }
                    }
                    NLinearGauge {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.max(6, Math.round(6 * Style.uiScaleRatio))
                        orientation: Qt.Horizontal
                        ratio: root.quotaPercent < 0 ? 0 : root.quotaPercent / 100
                        fillColor: root.quotaPercent >= 0 && root.quotaPercent < 20 ? Color.mError : Color.mPrimary
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        NIcon { icon: "calendar-clock"; color: Color.mPrimary; pointSize: Style.fontSizeS }
                        NText { text: "下次重置 " + root.quotaResetsAt; color: Color.mOnSurfaceVariant; pointSize: Style.fontSizeXS; Layout.fillWidth: true }
                    }
                    NText {
                        text: root.quotaForecast
                        color: root.quotaForecast.indexOf("预计不会") >= 0 ? Color.mPrimary : Color.mOnSurfaceVariant
                        pointSize: Style.fontSizeXS
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }

            NBox {
                visible: root.nearestResetCredit !== null
                color: root.nearestResetUrgent ? Qt.alpha(Color.mError, 0.16) : root.glassCardColor
                Layout.fillWidth: true
                implicitHeight: nearestResetRow.implicitHeight + Style.margin2M
                RowLayout {
                    id: nearestResetRow
                    anchors.fill: parent
                    anchors.margins: Style.marginM
                    spacing: Style.marginS
                    NIcon { icon: "restore"; color: root.nearestResetUrgent ? Color.mError : Color.mPrimary; pointSize: Style.fontSizeL }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        NText { text: "最近到期的 Reset 机会"; color: Color.mOnSurfaceVariant; pointSize: Style.fontSizeXS }
                        NText {
                            text: root.localDateTime(root.nearestResetCredit ? root.nearestResetCredit.expires_at : null)
                            color: root.nearestResetUrgent ? Color.mError : Color.mOnSurface
                            font.weight: Style.fontWeightBold
                        }
                    }
                    NText { text: root.resetAvailableCount + " 次可用"; color: Color.mPrimary; pointSize: Style.fontSizeXS }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.marginM
                Repeater {
                    model: [
                        { icon: "coins", label: "今日 Token", value: root.todayTokens },
                        { icon: "currency-dollar", label: "今日费用", value: root.todayCost }
                    ]
                    NBox {
                        color: root.glassCardColor
                        Layout.fillWidth: true
                        implicitHeight: statColumn.implicitHeight + Style.margin2M
                        ColumnLayout {
                            id: statColumn
                            anchors.fill: parent
                            anchors.margins: Style.marginM
                            spacing: Style.marginXS
                            RowLayout {
                                NIcon { icon: modelData.icon; color: Color.mPrimary; pointSize: Style.fontSizeM }
                                NText { text: modelData.label; color: Color.mOnSurfaceVariant; pointSize: Style.fontSizeXS }
                            }
                            NText { text: modelData.value; color: Color.mOnSurface; pointSize: Style.fontSizeXL; font.weight: Style.fontWeightBold }
                        }
                    }
                }
            }

            NBox {
                color: root.glassCardColor
                Layout.fillWidth: true
                Layout.fillHeight: true
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.marginM
                    spacing: Style.marginXS
                    RowLayout {
                        Layout.fillWidth: true
                        NText { text: "近 7 天 Token 趋势"; color: Color.mOnSurfaceVariant; Layout.fillWidth: true }
                        NText { text: root.trendTotal; color: Color.mPrimary; font.weight: Style.fontWeightSemiBold }
                    }
                    NGraph {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        values: root.trendValues
                        minValue: 0
                        maxValue: root.trendMaximum
                        color: Color.mPrimary
                        strokeWidth: Math.max(1, Style.uiScaleRatio)
                        fill: true
                        fillOpacity: 0.15
                        updateInterval: 0
                    }
                }
            }
        }
    }

    Component {
        id: settingsPage
        Flickable {
            clip: true
            contentWidth: width
            contentHeight: settingsColumn.implicitHeight
            boundsBehavior: Flickable.StopAtBounds

            ColumnLayout {
                id: settingsColumn
                width: parent.width
                spacing: Style.marginM

                NBox {
                    color: root.glassCardColor
                    Layout.fillWidth: true
                    implicitHeight: applicationSettingsColumn.implicitHeight + Style.margin2M
                    ColumnLayout {
                        id: applicationSettingsColumn
                        anchors.fill: parent
                        anchors.margins: Style.marginM
                        spacing: Style.marginS
                        NText { text: "应用"; font.weight: Style.fontWeightBold; color: Color.mOnSurface }
                        NToggle {
                            label: "开机自动启动"
                            description: root.autostartKnown
                                ? (root.autostartActive ? "daemon 已随当前用户会话运行" : "登录桌面后自动启动 daemon")
                                : "正在读取 systemd 用户服务状态"
                            checked: root.autostartEnabled
                            enabled: root.autostartKnown && !root.busy
                            onToggled: checked => {
                                root.autostartEnabled = checked
                                root.runAction(["autostart", checked ? "enable" : "disable"], checked ? "正在启用开机自启动…" : "正在关闭开机自启动…")
                            }
                        }
                        NButton {
                            Layout.fillWidth: true
                            text: "更新到最新稳定版"
                            icon: "download"
                            outlined: true
                            enabled: !root.busy
                            onClicked: root.runAction(["update"], "正在从 crates.io 更新，请稍候…")
                        }
                    }
                }

                NBox {
                    color: root.glassCardColor
                    Layout.fillWidth: true
                    implicitHeight: barSettingsColumn.implicitHeight + Style.margin2M
                    ColumnLayout {
                        id: barSettingsColumn
                        anchors.fill: parent
                        anchors.margins: Style.marginM
                        spacing: Style.marginS
                        NText { text: "顶栏显示"; font.weight: Style.fontWeightBold; color: Color.mOnSurface }
                        NText {
                            text: "选择顶栏中需要显示的信息，修改后立即生效。"
                            color: Color.mOnSurfaceVariant
                            pointSize: Style.fontSizeXS
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                        NToggle {
                            label: "账号"
                            description: "显示当前连接的账号名称"
                            checked: root.pluginApi?.pluginSettings?.barShowAccount ?? true
                            defaultValue: true
                            onToggled: checked => root.saveBarSetting("barShowAccount", checked)
                        }
                        NToggle {
                            label: "周额度"
                            description: "显示当前剩余额度百分比"
                            checked: root.pluginApi?.pluginSettings?.barShowQuota ?? true
                            defaultValue: true
                            onToggled: checked => root.saveBarSetting("barShowQuota", checked)
                        }
                        NToggle {
                            label: "今日 Token"
                            description: "显示本地 Codex 今日 Token"
                            checked: root.pluginApi?.pluginSettings?.barShowTodayTokens ?? false
                            defaultValue: false
                            onToggled: checked => root.saveBarSetting("barShowTodayTokens", checked)
                        }
                        NToggle {
                            label: "今日费用"
                            description: "显示今日 API 等价费用"
                            checked: root.pluginApi?.pluginSettings?.barShowTodayCost ?? false
                            defaultValue: false
                            onToggled: checked => root.saveBarSetting("barShowTodayCost", checked)
                        }
                        NToggle {
                            label: "Codex 会话数"
                            description: "显示当前运行中的 Codex 数量"
                            checked: root.pluginApi?.pluginSettings?.barShowCodexSessions ?? false
                            defaultValue: false
                            onToggled: checked => root.saveBarSetting("barShowCodexSessions", checked)
                        }
                        NToggle {
                            label: "Token 趋势"
                            description: "显示最近七天的紧凑趋势图"
                            checked: root.pluginApi?.pluginSettings?.barShowTrend ?? true
                            defaultValue: true
                            onToggled: checked => root.saveBarSetting("barShowTrend", checked)
                        }
                    }
                }

                NBox {
                    color: root.glassCardColor
                    Layout.fillWidth: true
                    implicitHeight: connectionsColumn.implicitHeight + Style.margin2M
                    ColumnLayout {
                        id: connectionsColumn
                        anchors.fill: parent
                        anchors.margins: Style.marginM
                        spacing: Style.marginS
                        RowLayout {
                            Layout.fillWidth: true
                            NText { text: "连接"; font.weight: Style.fontWeightBold; color: Color.mOnSurface; Layout.fillWidth: true }
                            NText { text: root.connections.length + " 个"; pointSize: Style.fontSizeXS; color: Color.mOnSurfaceVariant }
                        }
                        NText {
                            visible: root.connections.length === 0
                            text: "尚未连接账号，可在下方直接登录 ChatGPT。"
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            color: Color.mOnSurfaceVariant
                            pointSize: Style.fontSizeXS
                        }
                        Repeater {
                            model: root.connections
                            ColumnLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: Style.marginXS
                                RowLayout {
                                    Layout.fillWidth: true
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        NText { text: modelData.display_name || "OpenAI"; color: Color.mOnSurface; font.weight: Style.fontWeightSemiBold; elide: Text.ElideRight; Layout.fillWidth: true }
                                        NText { text: root.statusText(modelData.status); color: Color.mOnSurfaceVariant; pointSize: Style.fontSizeXS }
                                    }
                                    NIconButton {
                                        icon: "refresh"
                                        tooltipText: "刷新此连接"
                                        baseSize: Style.baseWidgetSize * 0.72
                                        enabled: !root.busy
                                        onClicked: root.runAction(["refresh", modelData.id], "正在刷新连接…")
                                    }
                                    NIconButton {
                                        icon: root.pendingRemoveId === modelData.id ? "check" : "trash"
                                        tooltipText: root.pendingRemoveId === modelData.id ? "再次点击确认删除" : "删除连接"
                                        baseSize: Style.baseWidgetSize * 0.72
                                        colorFg: root.pendingRemoveId === modelData.id ? Color.mError : Color.mPrimary
                                        enabled: !root.busy
                                        onClicked: {
                                            if (root.pendingRemoveId === modelData.id)
                                                root.runAction(["remove", modelData.id], "正在删除连接…")
                                            else {
                                                root.pendingRemoveId = modelData.id
                                                root.actionMessage = "再次点击红色确认按钮删除该连接"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                NBox {
                    color: root.glassCardColor
                    Layout.fillWidth: true
                    implicitHeight: loginColumn.implicitHeight + Style.margin2M
                    ColumnLayout {
                        id: loginColumn
                        anchors.fill: parent
                        anchors.margins: Style.marginM
                        spacing: Style.marginS
                        NText { text: "添加账号"; font.weight: Style.fontWeightBold; color: Color.mOnSurface }
                        NText {
                            text: "在默认浏览器完成 OpenAI 登录，成功后用量会自动刷新。"
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            color: Color.mOnSurfaceVariant
                            pointSize: Style.fontSizeXS
                        }
                        NButton {
                            Layout.fillWidth: true
                            text: loginProcess.running ? "取消登录" : "登录 ChatGPT"
                            icon: loginProcess.running ? "close" : "login"
                            enabled: !actionProcess.running
                            onClicked: {
                                if (loginProcess.running) {
                                    root.loginCancelled = true
                                    loginProcess.running = false
                                } else {
                                    root.startLogin()
                                }
                            }
                        }
                    }
                }

                NBox {
                    color: root.glassCardColor
                    visible: root.connections.length > 0
                    Layout.fillWidth: true
                    implicitHeight: budgetColumn.implicitHeight + Style.margin2M
                    ColumnLayout {
                        id: budgetColumn
                        anchors.fill: parent
                        anchors.margins: Style.marginM
                        spacing: Style.marginS
                        NText { text: "月度预算"; font.weight: Style.fontWeightBold; color: Color.mOnSurface }
                        RowLayout {
                            Layout.fillWidth: true
                            NTextInput {
                                Layout.fillWidth: true
                                placeholderText: "20"
                                text: root.budgetAmount
                                inputMethodHints: Qt.ImhFormattedNumbersOnly
                                showClearButton: false
                                onTextChanged: root.budgetAmount = text
                            }
                            NButton {
                                text: "保存 USD"
                                outlined: true
                                enabled: !root.busy && root.budgetAmount.trim() !== ""
                                onClicked: root.runAction(["budget", root.connections[0].id, root.budgetAmount, "--currency", "USD"], "正在保存预算…")
                            }
                        }
                    }
                }

                NText {
                    visible: root.actionMessage !== ""
                    text: root.actionMessage
                    color: root.actionMessage.indexOf("失败") >= 0 || root.actionMessage.indexOf("未完成") >= 0 ? Color.mError : Color.mOnSurfaceVariant
                    pointSize: Style.fontSizeXS
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }
    }
}
