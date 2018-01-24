import QtQuick 2.0
import QtQuick.Dialogs 1.2
import DesktopWallpaper.APIRequestEx 1.0
import DesktopWallpaper.UserManager 1.0
import "../controls/PLToast.js" as Toast
import "./Global.js" as Global
import "../controls/PLMessageBoxItem.js" as MessageBox
import "../controls"
Item {
    id: root_item

    APIRequestEx{id: api_request}
    UserManager{id: user_information}

    function updatePefers(){
        if(user_information.token.length === 0){
            var messagebox = MessageBox.showMessageBox(Global.RootPanel, "请登录您的账户", function(){
                Global.RootPanel.showLoginPanel();
            });
        }
        else{
            if (user_information.peferItemIDs.length > 0){
                api_request.itemsRequest(user_information.peferItemIDs, function(suc, msg, data){
                    var result = Global.resolveAPIResponse(suc, msg, data, true);

                    if(result[0]){
                        var model_data = Global.toPefersModelData(result[1]);

                        grid_view_model.clear();
                        grid_view_model.append(model_data);
                        Toast.showToast(Global.RootPanel, "已刷新我的收藏");
                    }
                    else{
                        Toast.showToast(Global.RootPanel, result[1]);
                    }
                });

            }
        }
    }


    Rectangle{
        id: image_area

        anchors.fill: parent


        color: Qt.rgba(0.7, 0.7, 0.7, 0.3)

        Item{

            id: top_area
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top:parent.top
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            height: 50

            PLTextButton{
                id: back_button
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 60
                height: 24
                text: "返回"
                onClicked: {
                    Global.RootPanel.back();
                }
            }

            PLTextWithDefaultFamily{
                id: text_item

                text: "我的收藏"

                anchors.centerIn: parent
                font.pointSize: 11
                color: "white"
                clip: true
            }

            PLTextButton{
                id: update_button
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 60
                height: 24
                text: "刷新"
                onClicked: {
                    root_item.updatePefers();
                }
            }
        }




        PefersGridView{
            anchors.top: top_area.bottom
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom:  parent.bottom
            anchors.bottomMargin: 10

            columnCount: 3

            flow: GridView.FlowTopToBottom

            model: ListModel{
                id: grid_view_model
            }


            PLTextWithDefaultFamily{
                anchors.centerIn: parent

                visible: grid_view_model.count === 0

                text: "您还没有收藏任何图片"

                font.pixelSize: 15

                color: Qt.rgba(0.8, 0.8, 0.8, 1.0)


                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
            }
        }

    }


}
