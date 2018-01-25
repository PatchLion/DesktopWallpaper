import QtQuick 2.0
import "../../controls"
import DesktopWallpaper.APIRequestEx 1.0
import "../../controls/PLToast.js" as Toast
import "../../controls/PLCoverPanel.js" as Cover
import "../../controls/PLMessageBoxItem.js" as MessageBox
import "../../controls"
import "../Global.js" as Global
import ".."

Rectangle {
    id: root_item
    property string myID: itemID
    property string myTitle: title


    signal needHide();
    color: Qt.rgba(1, 1, 1, 0.3)

    APIRequestEx{id: api_request}

    onMyIDChanged: {
        api_request.itemRequest(myID, function(suc, msg, data){
            var result = Global.resolveAPIResponse(suc, msg, data);

            if(result[0]){
                var model_data = Global.toImageDetailsModelData(result[1]);

                image_list_model.clear();
                image_list_model.append(model_data);
            }
            else{
                Toast.showToast(Global.RootPanel, "获取图片组详情失败! "+result[1]);
            }
        });
    }


    radius: 5

    PLCheckButtonGroup{
        autoCheckFirst: false
        buttons: [pass_button, hide_button]
    }

    PLTextWithDefaultFamily{
        id: title_item

        text: myTitle

        height: 20

        color: "white"

        anchors.horizontalCenter:parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    PLCheckTextButton{
        id: pass_button
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10

        width: 80
        height: 20

        enabled: image_list_model.count > 0

        text: "通过该组"

        onClicked: {
            //var msgbox = MessageBox.showMessageBox(root_item.)
            var passimageids = []
            for(var i = 0; i <image_list_model.count; i++){
                var imageid = image_list_model.get(i)["imageid"];
                console.log("SHOW:", imageid)
                passimageids.push(imageid);
            }

            var cover = Cover.showLoadingCover(Global.RootPanel, "通过图片组中...");
            api_request.setImagesVisibleRequest(Global.RootPanel.adminToken, [], passimageids,  function(suc, msg, data){

                Global.destroyPanel(cover);
                var result = Global.resolveAPIResponse(suc, msg, data);
                if(result[0]){
                    Toast.showToast(Global.RootPanel, "已通过");

                    root_item.needHide();
                }
                else{

                    Toast.showToast(Global.RootPanel, "通过图片组失败: " + result[1]);
                }
            });
        }
    }

    PLCheckTextButton{
        id: hide_button
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 150


        width: 80
        height: 20

        enabled: image_list_model.count > 0

        text: "隐藏该组"

        onClicked: {
            var hideimageids = []
            for(var i = 0; i <image_list_model.count; i++){
                var imageid = image_list_model.get(i)["imageid"];
                console.log("HIDE:", imageid)
                hideimageids.push(imageid);
            }

            var cover = Cover.showLoadingCover(Global.RootPanel, "隐藏图片组中...");
            api_request.setImagesVisibleRequest(Global.RootPanel.adminToken, hideimageids, [], function(suc, msg, data){

                Global.destroyPanel(cover);
                var result = Global.resolveAPIResponse(suc, msg, data);
                if(result[0]){
                    Toast.showToast(Global.RootPanel, "已隐藏");

                    root_item.needHide();
                }
                else{

                    Toast.showToast(Global.RootPanel, "隐藏图片组失败: " + result[1]);
                }
            });

        }
    }

    ListView{
        id: image_list_item
        anchors.top: title_item.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        height: root_item.height * 9 / 10

        spacing: 5

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        orientation: ListView.Horizontal

        delegate: Image{
           property int myid:imageid

           source: image
           cache: true

           smooth: false

           height: parent.height * 0.93

           visible: status === Image.Ready

           fillMode: Image.PreserveAspectFit

           sourceSize.height: height
        }

        model: ListModel{
            id: image_list_model
        }
    }
}
