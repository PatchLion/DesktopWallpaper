import QtQuick 2.0
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0

Rectangle {
    id: toolTipRoot
    width: toolTip.contentWidth + 10
    height: 20
    visible: false
    clip: false
    z: 999999999

    property int tipPosMode: 0 //0下方 1上方

    color: Qt.rgba(0.8, 0.8, 0.8, 0.7)
    border.color: Qt.rgba(0.4, 0.4, 0.4, 0.55)

    radius: 5

    property alias text: toolTip.text
    property var target: null //
    property var mouseArea: null //

    onMouseAreaChanged: {
        if(mouseArea){
            mouseArea.positionChanged.connect(onMouseAreaPositionChanged);
            mouseArea.entered.connect(onMouseEnter);
            mouseArea.exited.connect(onMouseExited);
        }
    }

    //鼠标位置改变
    function onMouseAreaPositionChanged(event) {
        var obj = toolTipRoot.target.mapToItem(toolTipRoot.parent, event.x, event.y);
        //console.log("Tooltip onMouseAreaPositionChanged!", obj.x, obj.y, event.x, event.y);
        toolTipRoot.x = event.x - toolTip.width/2;//obj.x;
        toolTipRoot.y = event.y + ((tipPosMode === 0) ? (toolTip.height+25) : (-toolTip.height-25));//obj.y;
    }

    //鼠标区域进入
    function onMouseEnter(){
        //console.log("Tooltip onMouseEnter!");
        toolTipRoot.visible = true;
    }
    //鼠标区域离开
    function onMouseExited(){
        //console.log("Tooltip onMouseExited!");
        toolTipRoot.visible = false;
    }
    PLTextWithDefaultFamily {
        id: toolTip
        anchors.fill: parent
        anchors.margins: 5
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: Qt.rgba(0.2, 0.2, 0.2, 0.8)
    }

    Behavior on visible {
        NumberAnimation {
            duration: 200
        }
    }
}
