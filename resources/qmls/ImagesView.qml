import QtQuick 2.9
import "./Global.js" as Global

Rectangle{
    id: root_item

    property string currentID: ""
    property alias source: image_item.source
    property string titleString: ""
    property string itemUrl: ""
    property bool isNew: false

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

            cache: true
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
                text: titleString.substring(0, 25)
            }
        }
        Rectangle{
            width: 32
            height: 32
            color: Qt.rgba(1.0, 0, 0, 0.5)
            anchors.right: parent.right
            anchors.rightMargin: -10
            anchors.top:parent.top
            anchors.topMargin: -10
            radius: width/2

            transform: Rotation{
                angle: 15
            }


            smooth: true
            Text{
                anchors.centerIn: parent
                text: "New"
                color: "white"
                font.family: "微软雅黑"
                font.pointSize: 8
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
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
            console.log("Item", root_item.currentID, "clicked!!!")
            Global.RootPanel.showItemDetailsPanel(root_item.currentID, text_item.text, root_item.itemUrl);
        }
    }
}
