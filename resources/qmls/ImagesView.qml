import QtQuick 2.9
import "./Global.js" as Global

Rectangle{
    id: root_item

    property int currentID: -1
    property alias source: image_item.source
    property alias titleString: text_item.text
    property string itemUrl: ""

    Item{
        width: parent.width * 0.95
        height: parent.height * 0.95
        //color: "red"
        anchors.centerIn: parent

        Image{
            id: image_item
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: text_area_item.top
            fillMode: Image.PreserveAspectCrop
            clip: true

            smooth: true

            mipmap: true
            sourceSize.width: 1024
            sourceSize.height: 1024

            cache: false
        }

        Rectangle{
            id: text_area_item
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 40
            border.color: color

            color: Qt.rgba(1, 1, 1, 0.5)
            Text{
                id: text_item
                anchors.fill:parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "微软雅黑"
                font.pointSize: 9
                color: "white"
                clip: true
            }
        }
    }

    color: "transparent"

    border.color: mouse_area.containsMouse ? "#1E90FF" : "transparent"

    border.width: 1

    MouseArea{
        id: mouse_area

        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Global.RootPanel.showItemDetailsPanel(root_item.currentID, text_item.text, root_item.itemUrl);
        }
    }
}
