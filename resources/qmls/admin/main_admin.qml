import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import DesktopWallpaper.APIRequestEx 1.0
import "../../controls/"
import "../Global.js" as Global
import "../../controls/PLMessageBoxItem.js" as MessageBox

PLFrameLessAndMoveableWindow
{
    id: root_window
    visible: true
    width: 1200
    height: 700
    title: qsTr("Beauty Finder")
    color: "transparent"
    dragArea: Qt.rect(0, 0, width, 50)

    property string adminToken: ""

    Rectangle{
        id: bg_rect
        color: "black"
        radius: Qt.platform.os === "windows" ? 5 : 0
        anchors.fill: parent

        clip: true

        smooth: true

        AdminLoginPanel{
            id: login_panel
            anchors.fill: parent
            onLoginSuccessed: {
                /*
                    var msgbox = MessageBox.showMessageBox(root_window, "Admin: "+token, function(){
                    Global.destroyPanel(msgbox);
                });
                */
                visible = false;
                root_window.adminToken = token;
            }
        }


        ImageListPanel{
            anchors.fill: parent
            visible: !login_panel.visible
        }

    }

    Component.onCompleted: {
        Global.RootPanel = root_window
    }
}
