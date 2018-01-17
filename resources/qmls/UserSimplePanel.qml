import QtQuick 2.0
import "../controls"
import "../qmls/Global.js" as Global
import "../controls/PLToast.js" as Toast

Rectangle {

    id: root_item

    height: 40

    property string headSource: ""
    property string userName: ""

    radius: 5

    color: "transparent"

    width: head_image_item.width + user_name_item.width + logout_item.width + 25


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

    PLTextButton{
        id: logout_item
        anchors.left:user_name_item.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        text: "注销"
        textPixelSize: 11
        visible: Global.User.token.length>0
        width: 30
        height: user_name_item.height

        defaultColor: "transparent"
        hoverColor: "transparent"
        pressedColor: "transparent"
        disabledColor: "transparent"

        textDefaultColor: "#1E90FF"
        textPressedColor: "#00BFFF"
        textHoverColor: "#00BFFF"
        textDisabledColor: "#B0C4DE"

        onClicked: {
            Toast.showToast(Global.RootPanel, "用户"+Global.User.nickName+"登出")
            Global.RootPanel.clearUserInformation();
            //visible = false
        }
    }
}
