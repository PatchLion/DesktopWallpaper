import QtQuick 2.4

Rectangle
{
    id: root_item
    property alias message: text_item.text
    signal confirmClicked()

    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true
    }

    color: Qt.rgba(0, 0, 0, 0.5)

    Rectangle{
        id: messagebox
        color: Qt.rgba(0, 0, 0, 0.8)
        height: text_item.height + 60 + buttons_content.height
        radius: 5
        width: 420

        anchors.centerIn: parent


        PLTextWithDefaultFamily
        {
            id: text_item
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 40
            font.pixelSize: 16
            wrapMode: Text.Wrap
            color: "white"
        }

        Item
        {
            id: buttons_content
            width: parent.width
            height: 80
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            PLTextButton{
                width: 50
                height: 25
                text: "确定"
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: - width/2 - 30
                onClicked: {
                    emit: root_item.confirmClicked()
                }
            }

            PLTextButton{
                width: 50
                height: 25
                text: "取消"
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: width/2 + 30
                onClicked: {
                    root_item.visible = false
                }
            }
        }
    }
}
