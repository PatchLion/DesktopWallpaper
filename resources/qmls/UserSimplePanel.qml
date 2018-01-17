import QtQuick 2.0
import DesktopWallpaper.UserManager 1.0
import "../controls"
import "../qmls/Global.js" as Global
import "../controls/PLToast.js" as Toast

Rectangle {

    id: root_item

    height: 40

    radius: 5

    color: "transparent"

    UserManager{
        id: user_information
    }

    width: head_image_item.width + user_name_item.width + logout_item.width + 25


    Image{
        id: head_image_item
        height: parent.height * 3 / 5
        width: height

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10


        source: (user_information.headerImage.length === 0) ? "qrc:/images/default_head_icon.jpg" : user_information.headerImage

        smooth: true
        antialiasing: true
        fillMode: Image.PreserveAspectFit
    }

    PLTextWithDefaultFamily{
        id: user_name_item
        anchors.left:head_image_item.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        text: user_information.token.length === 0 ? "点击登录" : (user_information.nickName.length === 0 ? user_information.userName : user_information.nickName)
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
            if(user_information.token.length===0){
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
        visible: user_information.token.length>0
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
            Toast.showToast(Global.RootPanel, "用户"+user_information.nickName+"登出")
            user_information.clearUserInfo();
        }
    }
}
