import QtQuick 2.0
import QtQuick.Controls 1.4
import DesktopWallpaper.APIRequestEx 1.0
import "../../controls/PLToast.js" as Toast
import "../../controls/PLCoverPanel.js" as Cover
import "../../controls"
import "../Global.js" as Global
import ".."

Rectangle{
    id: root_item

    APIRequestEx{ id: api_request } //api请求对象

    color: Qt.rgba(0.7, 0.7, 0.7, 0.3)


    signal loginSuccessed(string token);

    PLImageButtonItem{
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: 10

        width: 24
        height: 24

        defaultIcon: "qrc:/images/button_24_0_2.png"
        pressedIcon: "qrc:/images/button_24_0_1.png"
        hoverIcon: "qrc:/images/button_24_0_0.png"
        disableIcon: "qrc:/images/button_24_0_2.png"

        onClicked: {
            Qt.quit();
        }
    }


    Rectangle{
        width: 420
        height: 260

        anchors.centerIn: parent

        color: Qt.rgba(0.8, 0.8, 0.8, 0.4)

        radius: 10

        PLTextWithDefaultFamily{
            id: title_item
            text: "管理员登录"
            font.pixelSize: 18
            color: Qt.rgba(1, 1, 1, 0.7)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20

        }

        Column{
            anchors.centerIn: parent
            width: parent.width * 4 / 7
            height: 100

            spacing: 25

            InputItem{
                id: user_name_item
                width: parent.width
                height: 30

                tipString: "请输入用户名"

                text: "admin"

                KeyNavigation.tab: password_item.inputItem

                Keys.onPressed: {
                    switch(event.key){
                    case Qt.Key_Enter:
                    case Qt.Key_Return:
                        //console.log("enter");
                        login_button.clicked();
                    }
                }
            }

            InputItem{
                id: password_item
                width: parent.width
                height: 30

                tipString: "请输入密码"
                echoMode: TextInput.Password


                KeyNavigation.tab: login_button

                focus: true

                Keys.onPressed: {
                    switch(event.key){
                    case Qt.Key_Enter:
                    case Qt.Key_Return:
                        //console.log("enter");
                        login_button.clicked();
                    }
                }

            }
        }

        Item{

            width: 400
            height: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter

            MainTextButton{
                id: login_button
                text: "登录"



                width: 80
                height: 36
                textPixelSize: 15
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: parent.width / 5

                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    var user = user_name_item.text;
                    var pwd = password_item.text;

                    if(user.length === 0 || pwd.length === 0){
                        Toast.showToast(Global.RootPanel, "用户名或密码为空");
                    }
                    else{
                        var cover = Cover.showLoadingCover(root_item, "登录中...");
                        api_request.loginRequest(user, pwd, function(suc, msg, data){
                            Global.destroyPanel(cover);

                            var result = Global.resolveAPIResponse(suc, msg, data);

                            if(result[0]){
                                var info=result[1];

                                if(!info.is_admin){

                                    Toast.showToast(Global.RootPanel, "请登录管理员账户！");
                                }
                                else{
                                    root_item.loginSuccessed(info.token);
                                }
                            }
                            else{
                                Toast.showToast(Global.RootPanel, "登录失败: "+result[1]);
                            }
                        });
                    }
                }

            }
            PLTextButton{
                id: cancel_button
                text: "取消"
                width: 80
                height: 36
                textPixelSize: 15


                focus: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -parent.width / 5

                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    Qt.quit();
                }


            }
        }
    }

    focus: true
    Keys.enabled: true
    Keys.onPressed: {
        switch(event.key){
        case Qt.Key_Enter:
        case Qt.Key_Return:
            //console.log("enter");
            login_button.clicked();
        }
    }
}
