import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

Item {
    id: root
    property real maxWindowPreviewHeight: 200
    property real maxWindowPreviewWidth: 300
    property real windowControlsHeight: 30
    property real buttonPadding: 5
    property bool vertical: false
    property string dockPosition: "bottom"
    property var parentWindow: null

    property Item lastHoveredButton
    property bool buttonHovered: false
    property bool contextMenuOpen: false
    property bool requestDockShow: dockPreviewPopup.visible || contextMenuOpen
    
    // Signal to close any open context menu before opening a new one
    signal closeAllContextMenus()
    
    // Function to show the new preview popup (Waffle-style)
    function showPreviewPopup(appEntry: var, button: Item): void {
        // Respect hoverPreview setting
        if (Config.options?.dock?.hoverPreview === false) return
        dockPreviewPopup.show(appEntry, button)
    }

    Layout.fillHeight: !vertical
    Layout.fillWidth: vertical
    implicitWidth: listView.contentWidth
    implicitHeight: listView.contentHeight
    
    property var dockItems: []
    
    // Direct reactive binding to Config - will automatically trigger when Config changes
    readonly property bool separatePinnedFromRunning: Config.options?.dock?.separatePinnedFromRunning ?? true
    onSeparatePinnedFromRunningChanged: {
        root.rebuildDockItems()
    }
    
    // Cache compiled regexes - only recompile when config changes
    property var _cachedIgnoredRegexes: []
    property var _lastIgnoredRegexStrings: []
    
    function _getIgnoredRegexes(): list<var> {
        const ignoredRegexStrings = Config.options?.dock?.ignoredAppRegexes ?? [];
        // Check if we need to recompile
        if (JSON.stringify(ignoredRegexStrings) !== JSON.stringify(_lastIgnoredRegexStrings)) {
            const systemIgnored = ["^$", "^portal$", "^x-run-dialog$", "^kdialog$", "^org.freedesktop.impl.portal.*"];
            const allIgnored = ignoredRegexStrings.concat(systemIgnored);
            _cachedIgnoredRegexes = allIgnored.map(pattern => new RegExp(pattern, "i"));
            _lastIgnoredRegexStrings = ignoredRegexStrings.slice();
        }
        return _cachedIgnoredRegexes;
    }
    
    function rebuildDockItems() {
        const pinnedApps = Config.options?.dock?.pinnedApps ?? [];
        const ignoredRegexes = _getIgnoredRegexes();
        const separatePinnedFromRunning = root.separatePinnedFromRunning;

        // Get all open windows
        const allToplevels = CompositorService.sortedToplevels && CompositorService.sortedToplevels.length
                ? CompositorService.sortedToplevels
                : ToplevelManager.toplevels.values;
        
        // Build map of running apps (apps with open windows)
        const runningAppsMap = new Map();
        for (const toplevel of allToplevels) {
            if (!toplevel.appId) continue;
            if (toplevel.appId === "" || toplevel.appId === "null") continue;

            if (ignoredRegexes.some(re => re.test(toplevel.appId))) {
                continue;
            }

            const lowerAppId = toplevel.appId.toLowerCase();
            if (!runningAppsMap.has(lowerAppId)) {
                runningAppsMap.set(lowerAppId, {
                    appId: toplevel.appId,
                    toplevels: [],
                    pinned: false
                });
            }
            runningAppsMap.get(lowerAppId).toplevels.push(toplevel);
        }

        const values = [];
        let order = 0;
        
        // If separation is disabled, use legacy behavior: combine pinned with their running windows
        if (!separatePinnedFromRunning) {
            // Add all pinned apps (with or without windows)
            for (const appId of pinnedApps) {
                const lowerAppId = appId.toLowerCase();
                const runningEntry = runningAppsMap.get(lowerAppId);
                values.push({
                    uniqueId: "app-" + lowerAppId,
                    appId: lowerAppId,
                    toplevels: runningEntry?.toplevels ?? [],
                    pinned: true,
                    originalAppId: appId,
                    section: "pinned",
                    order: order++
                });
                // Remove from running map so we don't add it again
                runningAppsMap.delete(lowerAppId);
            }
            
            // Add separator if there are both pinned and unpinned running apps
            if (values.length > 0 && runningAppsMap.size > 0) {
                values.push({
                    uniqueId: "separator",
                    appId: "SEPARATOR",
                    toplevels: [],
                    pinned: false,
                    originalAppId: "SEPARATOR",
                    section: "separator",
                    order: order++
                });
            }
            
            // Add unpinned running apps
            for (const [lowerAppId, entry] of runningAppsMap) {
                values.push({
                    uniqueId: "app-" + lowerAppId,
                    appId: lowerAppId,
                    toplevels: entry.toplevels,
                    pinned: false,
                    originalAppId: entry.appId,
                    section: "open",
                    order: order++
                });
            }
        } else {
            // NEW BEHAVIOR: Separate pinned-only from running apps
            // 1) Add ONLY pinned apps (without running windows) - left section
            for (const appId of pinnedApps) {
                const lowerAppId = appId.toLowerCase();
                // Only show pinned apps that don't have running windows
                if (!runningAppsMap.has(lowerAppId)) {
                    values.push({
                        uniqueId: "app-" + lowerAppId,
                        appId: lowerAppId,
                        toplevels: [],
                        pinned: true,
                        originalAppId: appId,
                        section: "pinned",
                        order: order++
                    });
                }
            }
            
            // 2) Add separator if there are both pinned-only apps and running apps
            const hasPinnedOnly = values.length > 0;
            const hasRunning = runningAppsMap.size > 0;
            
            if (hasPinnedOnly && hasRunning) {
                values.push({
                    uniqueId: "separator",
                    appId: "SEPARATOR",
                    toplevels: [],
                    pinned: false,
                    originalAppId: "SEPARATOR",
                    section: "separator",
                    order: order++
                });
            }
            
            // 3) Add running apps (right section) - includes pinned apps that are also running
            const sortedRunningApps = [];
            for (const [lowerAppId, entry] of runningAppsMap) {
                sortedRunningApps.push({
                    lowerAppId: lowerAppId,
                    entry: entry
                });
            }
            // Sort to keep consistency: pinned+running apps first (by pinned order), then unpinned
            sortedRunningApps.sort((a, b) => {
                const aIndex = pinnedApps.findIndex(p => p.toLowerCase() === a.lowerAppId);
                const bIndex = pinnedApps.findIndex(p => p.toLowerCase() === b.lowerAppId);
                
                const aIsPinned = aIndex !== -1;
                const bIsPinned = bIndex !== -1;
                
                // Pinned apps first (in their pinned order)
                if (aIsPinned && bIsPinned) return aIndex - bIndex;
                if (aIsPinned) return -1;
                if (bIsPinned) return 1;
                
                // Unpinned apps maintain their order
                return 0;
            });
            
            for (const {lowerAppId, entry} of sortedRunningApps) {
                values.push({
                    uniqueId: "app-" + lowerAppId,
                    appId: lowerAppId,
                    toplevels: entry.toplevels,
                    pinned: pinnedApps.some(p => p.toLowerCase() === lowerAppId),
                    originalAppId: entry.appId,
                    section: "running",
                    order: order++
                });
            }
        }

        dockItems = values
    }
    
    Connections {
        target: ToplevelManager.toplevels
        function onValuesChanged() {
            root.rebuildDockItems()
        }
    }
    
    Connections {
        target: CompositorService
        function onSortedToplevelsChanged() {
            root.rebuildDockItems()
        }
    }
    
    Connections {
        target: Config.options?.dock
        function onPinnedAppsChanged() {
            root.rebuildDockItems()
        }
        function onIgnoredAppRegexesChanged() {
            root.rebuildDockItems()
        }
    }
    
    Component.onCompleted: rebuildDockItems()
    
    StyledListView {
        id: listView
        spacing: 2
        orientation: root.vertical ? ListView.Vertical : ListView.Horizontal
        anchors {
            top: root.vertical ? undefined : parent.top
            bottom: root.vertical ? undefined : parent.bottom
            left: root.vertical ? parent.left : undefined
            right: root.vertical ? parent.right : undefined
        }
        implicitWidth: contentWidth
        implicitHeight: contentHeight

        Behavior on implicitWidth {
            animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
        }
        Behavior on implicitHeight {
            animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
        }

        model: ScriptModel {
            objectProp: "uniqueId"
            values: root.dockItems
        }
        
        delegate: DockAppButton {
            required property var modelData
            appToplevel: modelData
            appListRoot: root
            vertical: root.vertical
            dockPosition: root.dockPosition
            
            anchors.verticalCenter: !root.vertical ? parent?.verticalCenter : undefined
            anchors.horizontalCenter: root.vertical ? parent?.horizontalCenter : undefined

            // Sin insets - el tamaño viene del DockButton
            topInset: 0
            bottomInset: 0
            leftInset: 0
            rightInset: 0
            
            // Connect hover preview signals
            onHoverPreviewRequested: {
                root.showPreviewPopup(appToplevel, this)
            }
            onHoverPreviewDismissed: {
                dockPreviewPopup.close()
            }
        }
    }
    
    // New Waffle-style preview popup
    DockPreview {
        id: dockPreviewPopup
        dockHovered: root.buttonHovered
        dockPosition: root.dockPosition
        anchor.window: root.parentWindow
    }

}
