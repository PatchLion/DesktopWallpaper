import QtQuick 2.0

import "../controls"

DefaultPopupPanelBase {
    id: root_item
    color: Qt.rgba(0, 0, 0, 0.5)


    Item{
        parent: titleArea
        anchors.fill: parent

        Image{

            id: image_item
            source: "qrc:/images/zs1.png"
            scale: 0.4
            opacity: 0.9
            sourceSize: Qt.size(118,81)
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 50
        }

        PLTextWithDefaultFamily{
            id: title_item
            text: "升级为尊贵的VIP用户"
            height: parent.height
            font.pixelSize: 18
            color: Qt.rgba(1, 1, 1, 0.7)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: image_item.width * image_item.scale / 2 + 10
        }
    }

    Item{

        parent: bottomArea
        anchors.fill: parent


        PLTextButton{
            id: upgrade_button
            text: "升级"
            width: 80
            height: 36
            textPixelSize: 15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: parent.width / 8

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
            anchors.horizontalCenterOffset: -parent.width / 8

            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                root_item.visible = false;
                root_item.destroy();
            }
        }
    }


}
