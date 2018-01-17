import QtQuick 2.0
import "./Global.js" as Global
import "../controls/PLToast.js" as Toast
import "../controls/PLCoverPanel.js" as Cover
import "../controls"

DefaultPopupPanelBase {
    id: root_item
    color: Qt.rgba(0, 0, 0, 0.3)

    property var cover

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
        parent: centerArea
        width: parent.width * 4 / 7
        anchors.centerIn: parent
        height: parent.height

        spacing: 15

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
            anchors.verticalCenterOffset: -parent.height * 2 / 10


            KeyNavigation.tab: password_confirm_item.inputItem

        }

        InputItem{
            id: password_confirm_item
            width: parent.width
            height: 30
            anchors.verticalCenterOffset: parent.height * 2 / 10

            tipString: "请再次输入密码"
            echoMode: TextInput.Password
            KeyNavigation.tab: nickname_item.inputItem

        }

        InputItem{
            id: nickname_item
            width: parent.width
            height: 30
            anchors.verticalCenterOffset: parent.height *4 / 10

            tipString: "请输入昵称"


            KeyNavigation.tab: regeister_button
        }
    }
    Connections{
        target: Global.APIRequest
        onRegisterFinished:{
            root_item.cover.visible =false;
            root_item.cover.destroy();
            root_item.cover = null;
            var result = Global.resolveRegisterData(data);
            if(result[0]){

                root_item.registerFinished(result[1]);
                root_item.cancelButtonClicked();
            }
            else{
                Toast.showToast(root_item, "注册失败: "+result[1]);
            }
        }
    }
    Item{
        parent: bottomArea
        anchors.fill: parent

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
                var chars = '~!@#$^&*()=|{}\"\':;\',\\[\\].<>/?~！@#￥……&*（）——|{}【】'
                for(var c in chars){
                    if(userName.split(c).length > 1){
                        return "名称中包含特殊字符("+chars+")";
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
                var confirm = password_confirm_item.text
                var nickname = nickname_item.text

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
                if(user !== confirm){
                    Toast.showToast(root_item, "两次输入的密码不一致");
                    return;
                }

                root_item.cover = Cover.showLoadingCover(root_item, "注册中...");
                Global.APIRequest.tryToRegeister(user, pwd, nickname);

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
            anchors.horizontalCenterOffset: -parent.width / 6

            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                root_item.cancelButtonClicked();
            }
        }
    }
}
