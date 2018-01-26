import QtQuick 2.0
import DesktopWallpaper.APIRequestEx 1.0
import DesktopWallpaper.UserManager 1.0
import "../controls"
import "../qmls/Global.js" as Global
import "../controls/PLToast.js" as Toast

Rectangle {

    id: root_item

    height: 40

    radius: 5

    color: "transparent"

    property bool enableUserPanel: true

    APIRequestEx{id:api_request}

    UserManager{
        id: user_information
    }

    width: head_image_item.width + user_name_item.width + (user_information.token.length > 0 ? logout_item.width + modify_item.width : 0) + 10


    Image{
        id: head_image_item
        height: parent.height * 3.5 / 5
        width: height

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15


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
        font.pixelSize: 15
        color: mousearea.containsMouse ? "#00BFFF" : "#ffffff"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    MouseArea{
        id: mousearea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enableUserPanel ? Qt.PointingHandCursor : Qt.ArrowCursor

        enabled: enableUserPanel

        onClicked: {
            if(user_information.token.length===0){
                api_request.eventStatistics("click_to_login_button", "click", "1");
                Global.RootPanel.showLoginPanel();
            }
            else{

                api_request.eventStatistics("show_pefers_detail_panel_button", "click", "1");
                Global.RootPanel.showPefersDetailsPanel();
            }
        }
    }

    BlueTextButton{
        id: modify_item
        anchors.left:user_name_item.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: "修改资料"

        visible: user_information.token.length>0
        width: 30
        height: user_name_item.height

        onClicked: {

        }
    }

    BlueTextButton{
        id: logout_item
        anchors.left:modify_item.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: "注销"
        visible: user_information.token.length>0
        width: 30
        height: modify_item.height

        onClicked: {
            Toast.showToast(Global.RootPanel, "用户"+user_information.nickName+"登出")
            user_information.clearUserInfo();
        }
    }
}
