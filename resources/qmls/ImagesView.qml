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


        Rectangle{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: text_area_item.top
            color: Qt.rgba(1, 1, 1, 0.05)

            Image{
                id: image_item

                fillMode: Image.PreserveAspectCrop
                clip: true

                smooth: true

                mipmap: true
                sourceSize.width: 1024
                sourceSize.height: 1024

                anchors.fill: parent

                cache: true

            }

        }

        Rectangle{
            id: text_area_item
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 40
            border.color: color

            color: Qt.rgba(1, 1, 1, 0.3)

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
        CircleTooltip{
            width: 28
            height: 28
            anchors.right: parent.right
            anchors.rightMargin: -5
            anchors.top:parent.top
            anchors.topMargin: -5

            visible: root_item.isNew

            transform: Rotation{
                angle: 15
            }


            text: "New"

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
