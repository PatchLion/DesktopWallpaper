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

            function toModelData(data){
                var childlist = data;

                var model_data = [];
                for(var j = 0; j<data.length; j++)
                {
                    var classify = data[j];

                    model_data.push({"name":classify});
                }

                return model_data;
            }

            onTriggered: {
               api_request.classifiesRequest(function(suc, msg, data){

                   if (suc){
                       var result = Global.resolveStandardData(data);

                       if(result[0] && result[1] === 0)
                       {
                           imageClassifyListModel.clear();
                           imageClassifyListModel.append(toModelData(result[3]));
                       }
                       else
                       {
                            Toast.showToast(Global.RootPanel, "获取分类信息失败:"+result[2]);
                       }
                   }
                   else
                   {
                       Toast.showToast(Global.RootPanel, "获取分类信息失败:"+msg);
                   }


              });
            }
        }

    }
}
