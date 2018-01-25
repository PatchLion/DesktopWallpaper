import QtQuick 2.0
import "../../controls"
import DesktopWallpaper.APIRequestEx 1.0
import "../../controls/PLToast.js" as Toast
import "../../controls/PLCoverPanel.js" as Cover
import "../../controls"
import "../Global.js" as Global
import ".."

Rectangle {
    id: root_item
    property string myID: itemID
    property string myTitle: title


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

    PLTextWithDefaultFamily{
        id: title_item

        text: myTitle

        height: 20

        color: "white"

        anchors.horizontalCenter:parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
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
