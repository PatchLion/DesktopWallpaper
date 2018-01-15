import QtQuick 2.0
import QtQuick.Controls 1.4

import "./Global.js" as Global
import "../controls/PLToast.js" as Toast
import "../controls/PLCoverPanel.js" as Cover
import "../controls"

StackView{
    id: root_item
    property var cover

    anchors.fill: parent

    initialItem:Component{
        DefaultPopupPanelBase {
            id: login_panel
            color: Qt.rgba(0, 0, 0, 0.3)

            onCloseButtonClicked: {
                root_item.visible = false;
                root_item.destroy();
            }


            Item{
                parent: titleArea
                anchors.fill: parent

                PLTextWithDefaultFamily{
                    id: title_item
                    text: "登录"
                    font.pixelSize: 22
                    color: Qt.rgba(1, 1, 1, 0.7)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }
            }

            Column{
                parent: centerArea

                anchors.centerIn: parent
                width: parent.width * 4 / 7
                height: parent.height

                spacing: 25
                Item{
                    id: empty_item
                    height: 10
                    width: parent.width
                }

                InputItem{
                    id: user_name_item
                    width: parent.width
                    height: 30

                    tipString: "请输入用户名"

                    KeyNavigation.tab: password_item.inputItem
                }

                InputItem{
                    id: password_item
                    width: parent.width
                    height: 30

                    tipString: "请输入密码"
                    echoMode: TextInput.Password


                    KeyNavigation.tab: login_button

                }
            }
            Connections{
                target: Global.APIRequest
                onLoginFinished:{
                    root_item.cover.visible =false;
                    root_item.cover.destroy();
                    root_item.cover = null;
                    var result = Global.resolveLoginData(data);
                    if(result[0]){
                        //console.log("IsVIP:", result[1]["is_vip"]);


                        Global.RootPanel.updateUserInformation(result[1]);
                        root_item.visible = false;
                        root_item.destroy();
                    }
                    else{
                        Toast.showToast(root_item, "登录失败: "+result[1]);
                    }
                }
            }
            Item{
                parent: bottomArea
                anchors.fill: parent

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
                        var user = user_name_item.text
                        var pwd = password_item.text

                        if(user.length === 0 || pwd.length === 0){
                            Toast.showToast(root_item, "用户名或密码为空");
                        }
                        else{
                            root_item.cover = Cover.showLoadingCover(root_item, "登录中...");
                            Global.APIRequest.tryToLogin(user, pwd);
                        }
                    }

                    Keys.onPressed: {
                        switch(event.key){
                        case Qt.Key_Enter:
                        case Qt.Key_Return:
                            clicked();
                        }
                    }
                }
                PLTextButton{
                    id: register_button
                    text: "注册"
                    width: 80
                    height: 36
                    textPixelSize: 15


                    focus: true
                    anchors.horizontalCenter: parent.horizontalCenter

                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        root_item.push(regeister_component);
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
                        root_item.visible = false;
                        root_item.destroy();
                    }


                }
            }
        }
    }

    Component{
        id: regeister_component
        UserRegeisterPanel{
            onCloseButtonClicked: {
                root_item.visible = false;
                root_item.destroy();
            }

            onRegisterFinished: {
               root_item.pop();
            }

            onCancelButtonClicked: {
                root_item.pop();
            }
        }
    }
}
