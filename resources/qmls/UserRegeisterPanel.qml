import QtQuick 2.0
import DesktopWallpaper.APIRequestEx 1.0
import "./Global.js" as Global
import "../controls/PLToast.js" as Toast
import "../controls/PLCoverPanel.js" as Cover
import "../controls"

DefaultPopupPanelBase {
    id: root_item
    color: Qt.rgba(0, 0, 0, 0.3)


    signal cancelButtonClicked();
    signal registerFinished(var data);

    Item{
        parent: titleArea
        anchors.fill: parent

        PLTextWithDefaultFamily{
            id: title_item
            text: "注册"
            font.pixelSize: 22
            color: Qt.rgba(1, 1, 1, 0.7)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
    }

    Column{
        id:col_item
        parent: centerArea
        width: parent.width * 4 / 7
        anchors.centerIn: parent
        height: parent.height

        spacing: 20

        z: 20

        Item{
            id: content_item
            width:parent.width
            height: user_name_item.height + nickname_item.height + col_item.spacing

            z: 22

            HeaderImageSelectItem{

                id: head_image_item
                height: parent.height
                width: height

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }

            InputItem{
                id: user_name_item
                width: parent.width - head_image_item.width - 5
                height: 30

                tipString: "请输入用户名"
                KeyNavigation.tab: nickname_item.inputItem

                anchors.top: parent.top
                anchors.left: nickname_item.left



            }


            InputItem{
                id: nickname_item
                width: parent.width - head_image_item.width - 5
                height: 30
                anchors.verticalCenterOffset: parent.height *4 / 10

                tipString: "请输入昵称"


                KeyNavigation.tab: password_item.inputItem

                anchors.bottom: parent.bottom
                anchors.left: head_image_item.right
                anchors.leftMargin: 5
            }
        }

        InputItem{
            id: password_item
            width: parent.width
            height: 30

            tipString: "请输入密码"
            echoMode: TextInput.Password
            anchors.verticalCenterOffset: -parent.height * 2 / 10


            KeyNavigation.tab: password_confirm_item.inputItem

            z: 10
        }

        InputItem{
            id: password_confirm_item
            width: parent.width
            height: 30
            anchors.verticalCenterOffset: parent.height * 2 / 10

            tipString: "请再次输入密码"
            echoMode: TextInput.Password
            KeyNavigation.tab: regeister_button

            z: 10
        }

    }

    APIRequestEx{id: api_request}

    centerArea.z: 1
    bottomArea.z: 0

    Item{
        parent: bottomArea
        anchors.fill: parent


        z: 0
        MainTextButton{
            id: regeister_button
            text: "注册"
            width: 80
            height: 36
            textPixelSize: 15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: parent.width / 6


            anchors.verticalCenter: parent.verticalCenter
            function trimStr(str){
                return str.replace(/(^\s*)|(\s*$)/g,"");
            }
            function checkUserName(userName){
                if(userName.split(" ").length > 1){
                    return "名称中包含空格";
                }
                var chars = '~!@#$^&*()=|{}\"\':;\',\\[].<>/?'
                for(var i=0; i<chars.length;i++){
                    var c = chars[i];
                    if(userName.split(c).length > 1){
                        return "名称中包含特殊字符("+c+")\n特殊字符:"+chars;
                    }
                }

                if (userName.length < 4){
                    return "用户名必须大于4位"
                }
                return ""
            }
            function checkPWD(pwd){
                if (pwd.length < 6){
                    return "密码必须大于6位"
                }

                return ""
            }
            focus: true

            Keys.onPressed: {
                switch(event.key){
                case Qt.Key_Enter:
                case Qt.Key_Return:
                    regeister_button.clicked();
                }
            }

            onClicked: {
                var user = trimStr(user_name_item.text)
                var pwd = trimStr(password_item.text)
                var confirm = trimStr(password_confirm_item.text)
                var nickname = trimStr(nickname_item.text)
                var header = head_image_item.source

                console.log("注册信息:", user, pwd, confirm, nickname, header);

                if(user.length === 0 || pwd.length === 0 || confirm.length === 0){
                    Toast.showToast(root_item, "用户名或密码为空");
                    return;
                }


                var res = checkUserName(user)

                if (res.length > 0){
                    Toast.showToast(root_item, "用户名格式不符合要求:"+res);
                    return;
                }
                var res1 = checkPWD(pwd)

                if (res1.length > 0){
                    Toast.showToast(root_item, "密码格式不符合要求:"+res1);
                    return;
                }
                if(pwd !== confirm){
                    Toast.showToast(root_item, "两次输入的密码不一致");
                    return;
                }

                var cover = Cover.showLoadingCover(root_item, "注册中...");
                api_request.regeisterRequest(user, pwd, nickname, header, function(suc, msg, data){
                    Global.destroyPanel(cover);

                    api_request.eventStatistics("regeister_event", "click", "1");
                    var result = Global.resolveAPIResponse(suc, msg, data);
                    if(result[0]){
                        root_item.registerFinished(result[1]);
                        root_item.cancelButtonClicked();

                    }
                    else{
                        Toast.showToast(root_item, result[1]);
                    }
                });

            }


        }

        PLTextButton{
            id: cancel_button
            text: "取消"
            width: 80
            height: 36
            textPixelSize: 15

            z: 0

            focus: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -parent.width / 6

            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                root_item.cancelButtonClicked();
            }
        }
    }

    Component.onCompleted: {
        api_request.viewStatistics("/regeister_page", "regeister");
    }
}
