import QtQuick 2.0

Rectangle {
    id: rectangle
    width: 500
    height: 80

    property alias title: title_item.text
    property int downloaded: 0
    property int failed: 0
    property int downloading: 0

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
        anchors.right: text_item.left
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height / 4
    }

    property int total: downloaded+failed+downloading
    ProgressBar {
        id: progressBar

        height: 14
        anchors.left: title_item.left
        anchors.right: title_item.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.height / 4

        progress: total ===0 ? 0 : (downloaded / total)
    }

    Text
    {
        id: text_item

        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: progressBar.verticalCenter

        width: 50
        height: 40




        text: downloaded + "/" + total

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        font.pixelSize: 12


        color: "white"
    }

}
