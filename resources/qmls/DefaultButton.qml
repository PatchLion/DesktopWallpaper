import QtQuick 2.0

Rectangle{

    id: root_item

    property alias buttonText: text_item.text
    property alias isContainMouse: mouse_area.containsMouse
    property alias buttonTextPointSize: text_item.font.pointSize

    signal buttonClicked();

    color: mouse_area.containsMouse ? "#DDDDDD" : "#EEEEEE"
    width: 60
    height: 24
    radius: 5
    Text{
        id: text_item
        anchors.centerIn: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 9
        color: mouse_area.containsMouse ? "#888888" : "#555555"
        font.family: "微软雅黑"
        text: "更多"
    }

    MouseArea{
        id: mouse_area
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root_item.buttonClicked();
        }

        hoverEnabled: true
    }
}
