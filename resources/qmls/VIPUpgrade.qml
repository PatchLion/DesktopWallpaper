import QtQuick 2.0

import "../controls"

Rectangle {
    id: root_item
    color: Qt.rgba(0, 0, 0, 0.5)


    /*focus: true
    Keys.enabled: true;
    Keys.onEscapePressed: {
        event.accepted = true;
    }*/

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
    }

    z: 10000

    Rectangle{
        width: 800
        height: 600
        anchors.centerIn: parent

        Item{
            id: title_area
            height: image_item.height * image_item.scale
            width: 340
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 40


            Image{

                id: image_item
                source: "qrc:/images/zs1.png"
                scale: 0.8
                opacity: 0.9
                sourceSize: Qt.size(118,81)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left

            }

            PLTextWithDefaultFamily{
                id: title_item
                text: "升级为尊贵的VIP用户"
                height: title_area.height
                font.pixelSize: 24
                color: Qt.rgba(0, 0, 0, 0.7)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: image_item.width * image_item.scale / 2 + 10
            }
        }

        Rectangle{
            id: content_item

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: title_area.bottom
            anchors.bottom: buttons_item.top
            color: "transparent"
        }

        Rectangle{
            id: buttons_item
            color: "transparent"
            height: 100
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            PLTextButton{
                id: upgrade_button
                text: "升级"
                width: 80
                height: 36
                textPixelSize: 15
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: parent.width / 6

                anchors.verticalCenter: parent.verticalCenter
                onClicked: {

                }
            }

            PLTextButton{
                id: cancel_button
                text: "取消"
                width: 80
                height: 36
                textPixelSize: 15
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -parent.width / 6

                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    root_item.visible = false;
                    root_item.destroy();
                }
            }
        }



        color: Qt.rgba(1, 1, 1, 0.7)

        radius: 10
    }

}
