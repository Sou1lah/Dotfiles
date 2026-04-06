import QtQuick

Item {
    id: root
    
    property string source
    property int fillMode: Image.PreserveAspectCrop
    property size sourceSize
    // If we use the snapshot, we might want the crossfader to switch instantly "under the hood"
    // But keeping it smooth doesn't hurt, just double fade.
    property int transitionDuration: 1200
    property bool ready: (internal.activeIndex === 0 && img0.status === Image.Ready) || (internal.activeIndex === 1 && img1.status === Image.Ready)
    
    // Read-only state
    readonly property alias activeIndex: internal.activeIndex

    QtObject {
        id: internal
        property int activeIndex: 0

        function updateSource() {
            if (root.source === "") {
                img0.source = ""
                img1.source = ""
                return
            }
            
            // Check if current active image already has this source
            var currentImg = (activeIndex === 0) ? img0 : img1
            if (currentImg.source == root.source && currentImg.status === Image.Ready) {
                return // Already showing this image
            }

            // Load into the inactive image
            var targetImg = (activeIndex === 0) ? img1 : img0
            
            // If the target already has the source we want and is ready, switch immediately
            if (targetImg.source == root.source && targetImg.status === Image.Ready) {
                activeIndex = (activeIndex === 0) ? 1 : 0
            } else {
                // Otherwise set source to trigger load
                if (targetImg.source != root.source) {
                    targetImg.source = root.source
                }
            }
        }
    }

    onSourceChanged: internal.updateSource()

    Image {
        id: img0
        anchors.fill: parent
        fillMode: root.fillMode
        sourceSize: root.sourceSize
        asynchronous: true
        cache: true
        mipmap: true
        smooth: true
        
        // Only visible if it's the active one AND ready
        opacity: (internal.activeIndex === 0 && status === Image.Ready) ? 1 : 0
        
        Behavior on opacity { 
            NumberAnimation { 
                duration: root.transitionDuration
                easing.type: Easing.InOutQuad 
            } 
        }
        
        onStatusChanged: {
            // If we finished loading the NEW source and we are currently inactive, become active
            if (status === Image.Ready && internal.activeIndex === 1 && source == root.source) {
                internal.activeIndex = 0
            }
        }
    }

    Image {
        id: img1
        anchors.fill: parent
        fillMode: root.fillMode
        sourceSize: root.sourceSize
        asynchronous: true
        cache: true
        mipmap: true
        smooth: true
        
        opacity: (internal.activeIndex === 1 && status === Image.Ready) ? 1 : 0
        
        Behavior on opacity { 
            NumberAnimation { 
                duration: root.transitionDuration
                easing.type: Easing.InOutQuad 
            } 
        }
        
        onStatusChanged: {
            if (status === Image.Ready && internal.activeIndex === 0 && source == root.source) {
                internal.activeIndex = 1
            }
        }
    }
    
    Component.onCompleted: {
        // Initial load
        if (root.source !== "") {
            img0.source = root.source
        }
    }
}
