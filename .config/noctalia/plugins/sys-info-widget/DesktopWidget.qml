import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Modules.DesktopWidgets
import qs.Widgets 

DraggableDesktopWidget {
    id: root
    property var pluginApi: null

    readonly property real _width: Math.round(300 * widgetScale)
    readonly property real _height: Math.round(165 * widgetScale)
    
    implicitWidth:  _width
    implicitHeight: _height

    // --- Data Variables ---
    property string distroVal: "..."
    property string kernelVal: "..."
    property string uptimeVal: "..."
    property string lanaddressVal: "..."
    property string ipaddressVal: "..."


	// Changed font size to L
    // --- Data Fetching ---
    Process {
        id: distroProc
        command: ["sh", "-c", "grep '^NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '\"'"]
        stdout: StdioCollector { 
            onTextChanged: if (text.trim() !== "") root.distroVal = text.trim()
        }
    }

    Process {
        id: kernelProc
        command: ["uname", "-r"]
        stdout: StdioCollector { 
            onTextChanged: if (text.trim() !== "") root.kernelVal = text.trim()
        }
    }

    Process {
        id: uptimeProc
        command: ["sh", "-c", "awk '{d=int($1/86400); h=int(($1%86400)/3600); m=int(($1%3600)/60); if(d>0) printf \"%dd \", d; printf \"%dh %dm\", h, m}' /proc/uptime"]
        stdout: StdioCollector {
            onTextChanged: if (text.trim() !== "") root.uptimeVal = text.trim()
        }
    }
    Process {
        id: lanaddressProc
        command: ["sh", "-c",  "ip -4 addr show scope global | awk '/inet/ {print $2}' | head -n 1 | cut -d/ -f1"]
        stdout: StdioCollector {
            onTextChanged: if (text.trim() !== "") root.lanaddressVal = text.trim()
        }
    }
    Process {
        id: ipaddressProc
        command: ["curl", "ifconfig.me"]
        stdout: StdioCollector {
            onTextChanged: if (text.trim() !== "") root.ipaddressVal = text.trim()
        }
    }

    // Refresh all data on startup and uptime every minute
    Timer { 
        interval: 60000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            distroProc.running = true
            kernelProc.running = true
            uptimeProc.running = true
            lanaddressProc.running = true
            ipaddressProc.running = true

        }
    }

    // --- UI Layout ---
    Rectangle {
        anchors.fill: parent
        color: Color.mSurface
        opacity: 0.85
        radius: Style.radiusM 

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.marginL
            spacing: Style.marginS

            GridLayout {
                columns: 2
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                rowSpacing: Style.marginS

                // Row 1: Distribution
                NText { 
                    text: pluginApi?.tr("widget.distribution")
                    color: Color.mOnSurfaceVariant
                    font.pointSize: Style.fontSizeM * widgetScale
                }
                NText { 
                    text: root.distroVal
                    color: Color.mOnSurface
                    font.bold: true
                    font.pointSize: Style.fontSizeM * widgetScale
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight 
                }

                // Row 2: Kernel
                NText { 
                    text: pluginApi?.tr("widget.kernel")
                    color: Color.mOnSurfaceVariant
                    font.pointSize: Style.fontSizeM * widgetScale
                }
                NText { 
                    text: root.kernelVal
                    color: Color.mOnSurface
                    font.bold: true
                    font.pointSize: Style.fontSizeM * widgetScale
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    elide: Text.ElideRight
                }

                // Row 3: Uptime
                NText { 
                    text: pluginApi?.tr("widget.uptime")
                    color: Color.mOnSurfaceVariant
                    font.pointSize: Style.fontSizeM * widgetScale
                }
                NText { 
                    text: root.uptimeVal
                    color: Color.mOnSurface
                    font.bold: true
                    font.pointSize: Style.fontSizeM * widgetScale
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight 
                }

                // Row 4: LAN Address
                NText {
                    text: pluginApi?.tr("widget.lanaddress")
                    color: Color.mOnSurfaceVariant
                    font.pointSize: Style.fontSizeM * widgetScale
                }
                NText {
                    text: root.lanaddressVal
                    color: Color.mOnSurface
                    font.bold: true
                    font.pointSize: Style.fontSizeM * widgetScale
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                }

                // Row 5: IP Address
                NText {
                    text: pluginApi?.tr("widget.ipaddress")
                    color: Color.mOnSurfaceVariant
                    font.pointSize: Style.fontSizeM * widgetScale
                }
                NText {
                    text: root.ipaddressVal
                    color: Color.mOnSurface
                    font.bold: true
                    font.pointSize: Style.fontSizeM * widgetScale
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                }

            }
        }
    }
}
