import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services.Noctalia

Item {
    property var pluginApi: null

    IpcHandler {
        target: "llmMeterDev"

        function reload() {
            // Return from the IPC handler before unloading this component.
            Qt.callLater(() => PluginService.reloadPlugin("llm-meter"))
        }
    }
}
