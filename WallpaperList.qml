import QtQuick 2.0
import DesktopWallpaper.ImagesRequests 1.0

Item {
    ImagesRequests{
        id: imagesRequests
    }

    Component.onCompleted: {
        console.log("分类Json数据:", imagesRequests.imageClassifies);
        var classfies = JSON.parse(imagesRequests.imageClassifies);


        for(var i = 0; i< classfies.length; i++){
            var classify = classfies[i];
            console.log(classify.id, classify.name)
        }

        imageClassifyListModel.append(classfies)
    }


    ListView{
        id: imageClassifyList
        anchors.fill: parent
        anchors.margins: 10
        orientation: ListView.Horizontal
        spacing: 30
        clip: true


        boundsBehavior: Flickable.OvershootBounds

        model:ListModel{
            id: imageClassifyListModel
        }

        delegate: ImageListInReview{
            classifyName: name
            width: 800
            height: imageClassifyList.height

            onMoreImageByClassifyID: {

            }

            onSingelImageClicked: {

            }
        }
    }
}
