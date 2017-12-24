import QtQuick 2.0
import QtQuick.Controls 2.2
import DesktopWallpaper.APIRequest 1.0
import "./Global.js" as Global

Item {
    id: root_item



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

        APIRequest{
            id: classifies_request

            onClassifiesResponse: {
                //console.log("Classifies data:", data);

                var result = Global.runFuncWithUseTime(Global.resolveClassifiesData, "Global.resolveClassifiesData", data);

                //console.log("UseTime:", start, end,  end-start);

                if(result[0])
                {
                    imageClassifyListModel.clear();
                    imageClassifyListModel.append(result[1]);
                }
            }



            onApiRequestError: {
                console.warn("Catch error when reuqest api:", apiName, "code:", error);
            }
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
                classifies_request.requestClassifiesData();
            }
        }

    }
}
