import QtQuick 2.0
import "../controls"

Rectangle {
    id: root_item

    color: Qt.rgba(0, 0, 0, 0.6)

    property alias titleArea: title_area
    property alias centerArea: center_area
    property alias bottomArea: bottom_area

    signal closeButtonClicked();


    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
    }

    z: 10000

    Rectangle{
        width: 560
        height: 360
        anchors.centerIn: parent

        color: Qt.rgba(0.41, 0.41, 0.41, 0.9)

        radius: 10


        Item{
            id: title_area
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            height: 80
            //color: "red"

            PLImageButtonItem{
                defaultIcon: "qrc:/images/close_icon_28x28_0_2.png"
                pressedIcon: "qrc:/images/close_icon_28x28_0_1.png"
                hoverIcon: "qrc:/images/close_icon_28x28_0_1.png"
                disableIcon: "qrc:/images/close_icon_28x28_0_0.png"

                width: 22
                height: 22
                Component.onCompleted: {
                    if (Qt.platform.os === "windows"){
                        anchors.right = parent.right;
                        anchors.rightMargin = 10;
                        anchors.top = parent.top;
                        anchors.topMargin = 10;
                    }
                    else if (Qt.platform.os === "osx"){
                        anchors.left = parent.left;
                        anchors.left = 10;
                        anchors.top = parent.top;
                        anchors.topMargin = 10;
                    }
                }
                onClicked: {
                    root_item.closeButtonClicked();
                }
            }
        }

        Item{

            id: center_area

            anchors.left: parent.left
            anchors.top: title_area.bottom
            anchors.right: parent.right
            anchors.bottom: bottom_area.top
            //color: "white"
        }

        Item{

            id: bottom_area

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            //color: "blue"

            height: 80
        }
    }


}
