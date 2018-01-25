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

        StackView{
            id: main_stackview
            anchors.fill: parent

            initialItem:  AdminLoginPanel{
                id: login_panel
                onLoginSuccessed: {
                    root_window.adminToken = token;
                    main_stackview.push(image_list_panel_componet);
                }
            }
        }



        Component{
            id: image_list_panel_componet
            ImageListPanel{
            }
        }

    }

    Component.onCompleted: {
        Global.RootPanel = root_window
    }
}
