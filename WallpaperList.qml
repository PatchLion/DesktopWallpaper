import QtQuick 2.0
import DesktopWallpaper.ImageClassify 1.0

Item {
    id: root_item

    ImageClassify{
        id: classifies_item

        Component.onCompleted: {
            if(classifies.length > 0){
                root_item.updateClassifiesListView();
            }
        }

        onClassifiesChanged: {
            root_item.updateClassifiesListView();
        }
    }


    function updateClassifiesListView(){
        var json_obj = JSON.parse(classifies_item.classifies);
        if(json_obj)
        {
            var classifies = json_obj["showapi_res_body"]["list"];

            var model_data = [];
            if(classifies)
            {
                for(var i = 0; i < classifies.length; i++)
                {
                    var childlist = classifies[i].list;

                    for(var j = 0; j<childlist.length; j++)
                    {
                        var classify = childlist[j];

                        console.log(classify.id, classify.name);

                        model_data.push({"id": classify.id, "name":classify.name});
                    }
                }
            }

            imageClassifyListModel.clear();
            imageClassifyListModel.append(model_data);
        }
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
            classifyID: id
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
