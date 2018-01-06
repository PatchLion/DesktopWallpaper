import QtQuick 2.0

Rectangle{

    id: root_item
    color: Qt.rgba(1.0, 0, 0, 0.85)

    property alias text: text_item.text
    property alias fontPixelSize: text_item.font.pixelSize


    width: 16
    height: 16

    smooth: true
    radius: width/2

    Text{
        id: text_item
        anchors.centerIn: parent
        color: "white"
        font.bold: true
        //font.family: "微软雅黑"
        font.pixelSize: 10
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
