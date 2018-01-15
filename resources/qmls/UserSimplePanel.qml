import QtQuick 2.0
import "../controls"
import "../qmls/Global.js" as Global


Rectangle {

    id: root_item

    height: 40

    property string headSource: ""
    property string userName: ""

    radius: 5

    color: "transparent"

    width: head_image_item.width + user_name_item.width + 20


    Image{
        id: head_image_item
        height: parent.height * 3 / 5
        width: height

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10


        source: (headSource.length === 0 ) ? "qrc:/images/default_head_icon.jpg" : headSource

        smooth: true
        antialiasing: true
        fillMode: Image.PreserveAspectFit
    }

    PLTextWithDefaultFamily{
        id: user_name_item
        anchors.left:head_image_item.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        text: userName.length === 0 ? "点击登录" : userName
        font.pixelSize: 13
        color: mousearea.containsMouse ? "#00BFFF" : "#ffffff"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    MouseArea{
        id: mousearea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if(Global.User.token.length===0){
                Global.RootPanel.showLoginPanel();
            }
        }
    }
}
