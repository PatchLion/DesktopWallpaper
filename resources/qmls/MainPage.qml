import QtQuick 2.0
import QtQuick.Controls 2.2
import DesktopWallpaper.APIRequestEx 1.0
import "./Global.js" as Global
import "../controls/PLToast.js" as Toast

Item {
    id: root_item


    APIRequestEx {id:api_request}

    ListView{
        id: imageClassifyList

        anchors.fill: parent
        orientation: ListView.Horizontal
        spacing: 4
        clip: true


        boundsBehavior: Flickable.OvershootBounds

        model:ListModel{
            id: imageClassifyListModel
        }

        delegate: ImageListInReview{
            classify: name
            width: 700
            height: imageClassifyList.height
        }

        Component.onCompleted: {
            timer.start();
        }

        //延时加载图片分类列表
        Timer{
            id: timer
            interval: 1
            repeat: false
            running: false

            onTriggered: {
               api_request.classifiesRequest(function(suc, msg, data){
                   //console.log("classifies:", suc, msg, data)
                   var result = Global.resolveAPIResponse(suc, msg, data);

                   if (result[0]){
                       imageClassifyListModel.clear();
                       imageClassifyListModel.append(Global.toClassifiesModelData(result[1]));
                   }
                   else
                   {
                        Toast.showToast(Global.RootPanel, "获取分类信息失败:"+result[1]);
                   }
              });
            }
        }

    }
}
