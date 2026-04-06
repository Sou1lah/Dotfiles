pragma Singleton

import QtQuick
import Quickshell
import qs.modules.common
import qs.services

Singleton {
    id: root

    function _log(...args): void {
        if (Quickshell.env("QS_DEBUG") === "1") console.log(...args);
    }

    property bool ready: false
    readonly property string currentTheme: Config.options?.appearance?.theme ?? "auto"
    readonly property bool isAutoTheme: currentTheme === "auto"
    readonly property bool isStandaloneSettingsWindow: (Quickshell.env("QS_NO_RELOAD_POPUP") ?? "") === "1"
    readonly property bool defaultApplyExternal: !isStandaloneSettingsWindow
    readonly property bool vesktopEnabled: (Config.options?.appearance?.wallpaperTheming?.enableVesktop ?? true) !== false

    onCurrentThemeChanged: {
        if (Config.ready) {
            root._log("[ThemeService] currentTheme changed to:", currentTheme, "- applying");
            Qt.callLater(() => applyCurrentTheme(defaultApplyExternal));
        }
    }

    function setTheme(themeId, applyExternal = true): void {
        root._log("[ThemeService] setTheme called with:", themeId);
        Config.setNestedValue(["appearance", "theme"], themeId)
        
        // Update recent themes (max 4, no duplicates)
        let recent = Config.options?.appearance?.recentThemes ?? []
        recent = recent.filter(t => t !== themeId)
        recent.unshift(themeId)
        if (recent.length > 4) recent = recent.slice(0, 4)
        Config.setNestedValue("appearance.recentThemes", recent)
        
        root._log("[ThemeService] Config updated, now applying theme");
        if (themeId === "auto") {
            root._log("[ThemeService] Auto theme, regenerating from wallpaper");
            // Force regeneration of colors from wallpaper
            Quickshell.execDetached([Directories.wallpaperSwitchScriptPath, "--noswitch"]);
        } else {
            root._log("[ThemeService] Manual theme, calling ThemePresets.applyPreset");
            ThemePresets.applyPreset(themeId, applyExternal);
        }
        root._log("[ThemeService] setTheme completed");
    }

    function applyCurrentTheme(applyExternal = defaultApplyExternal): void {
        root._log("[ThemeService] applyCurrentTheme called, currentTheme:", currentTheme, "isAutoTheme:", isAutoTheme);
        if (isAutoTheme) {
            root._log("[ThemeService] Delegating to MaterialThemeLoader");
            MaterialThemeLoader.reapplyTheme();

            // Apply terminal colors if they exist (from previous generation)
            if (applyExternal) {
                Qt.callLater(() => {
                    Quickshell.execDetached([
                        "/usr/bin/bash",
                        Directories.scriptPath + "/colors/applycolor.sh"
                    ]);
                });
            }

            if (applyExternal && vesktopEnabled) {
                Qt.callLater(() => {
                    Quickshell.execDetached([
                        "/usr/bin/python3",
                        Directories.scriptPath + "/colors/system24_palette.py"
                    ]);
                });
            }
        } else {
            root._log("[ThemeService] Applying manual theme:", currentTheme);
            ThemePresets.applyPreset(currentTheme, applyExternal);
        }
        root.ready = true;
    }

    function regenerateAutoTheme(): void {
        root._log("[ThemeService] regenerateAutoTheme called");
        if (isAutoTheme) {
            // Force full regeneration from wallpaper (includes terminals, GTK, etc)
            Quickshell.execDetached([Directories.wallpaperSwitchScriptPath, "--noswitch"]);
        } else {
            // For manual presets, just re-apply with external apps
            ThemePresets.applyPreset(currentTheme, true);
        }
    }

    // Theme Scheduling
    readonly property bool scheduleEnabled: Config.options?.appearance?.themeSchedule?.enabled ?? false
    
    function isNightTime(): bool {
        const now = new Date()
        const currentMinutes = now.getHours() * 60 + now.getMinutes()
        
        const dayStart = Config.options?.appearance?.themeSchedule?.dayStart ?? "06:00"
        const nightStart = Config.options?.appearance?.themeSchedule?.nightStart ?? "18:00"
        
        const [dayH, dayM] = dayStart.split(":").map(Number)
        const [nightH, nightM] = nightStart.split(":").map(Number)
        
        const dayMinutes = dayH * 60 + dayM
        const nightMinutes = nightH * 60 + nightM
        
        // Night if before day start or after night start
        return currentMinutes < dayMinutes || currentMinutes >= nightMinutes
    }
    
    function applyScheduledTheme(): void {
        if (!scheduleEnabled) return
        
        const schedule = Config.options?.appearance?.themeSchedule
        const targetTheme = isNightTime() ? schedule?.nightTheme : schedule?.dayTheme
        
        if (targetTheme && targetTheme !== currentTheme) {
            root._log("[ThemeService] Schedule: switching to", targetTheme)
            setTheme(targetTheme, true)
        }
    }
    
    Timer {
        interval: 60000  // Check every minute
        running: root.scheduleEnabled
        repeat: true
        triggeredOnStart: true
        onTriggered: root.applyScheduledTheme()
    }
}
