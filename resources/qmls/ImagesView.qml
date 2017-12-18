import QtQuick 2.0

Rectangle{
    id: root_item

    property int currentID: -1
    property alias source: image_item.source
    property alias titleString: text_item.text


    signal itemClicked(string currentID);

    Item{
        width: parent.width * 9/10
        height: parent.height * 9/10
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

            color: Qt.rgba(0, 0, 0, 0.6)
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

    border.color: mouse_area.containsMouse ? "#1E90FF" : "transparent"

    border.width: 1

    MouseArea{
        id: mouse_area

        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root_item.itemClicked(root_item.currentID);
        }
    }
}
