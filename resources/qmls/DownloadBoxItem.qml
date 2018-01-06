import QtQuick 2.0

Rectangle {
    width: 500
    height: 80

    property alias progress: progressBar.progress
    property alias title: title_item.text

    border.color: "#66888888"
    color: "#66555555"

    radius: 5

    Text {
        id: title_item
        text: "下载标题"
        font.pixelSize: 12
        color:"white"

        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: state_item.left
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height / 4
    }

    ProgressBar {
        id: progressBar
        height: 16
        anchors.left: title_item.left
        anchors.right: title_item.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.height / 4
    }

    Rectangle
    {
        id: state_item

        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        width: parent.height * 4 / 5
        height: parent.height * 4 / 5

        radius: 5

        border.color: "white"
        color: "transparent"
    }

}
