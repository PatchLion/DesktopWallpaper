import QtQuick 2.0
import DesktopWallpaper.ImagesRequests 1.0

Rectangle{
    id: root_item
    property int classifyID: -1
    property string classifyName: ""

    color: Qt.rgba(0.8, 0.8, 0.8, 0.2)

    signal moreImageByClassifyID(var pagebean); //更多
    signal singelImageGroupClicked(string title, var imagelist); //点击图片组


    property var contentlist
    property var pagebean

    onClassifyIDChanged: {
        console.log("-->ID changed to ", classifyID);

        var image_json = imagesRequests.request(root_item.classifyID, 1);
        var json_object = JSON.parse(image_json);

        var page_infos = json_object.showapi_res_body.pagebean;
        root_item.pagebean = json_object.showapi_res_body.pagebean;
        if(page_infos)
        {
            //console.log(page_infos)
            var allPages = page_infos.allPages;
            var contentlist = page_infos.contentlist;
            root_item.contentlist = page_infos.contentlist;
            var currentPage = page_infos.currentPage;
            var allNum = page_infos.allNum;
            var maxResult = page_infos.maxResult;

            console.log(allPages, currentPage, allNum)

            var MAX = grid_view_item.rowCount * grid_view_item.columnCount;

            var first_page_data = []
            for(var i = 0; i < contentlist.length; i++){
                if(i>=MAX) break;

                var content = contentlist[i];
                first_page_data.push({"itemID": content.itemId, "title":content.title, "image": content.list[0].middle});

                console.log(content.title, content.itemId, content.list[0].middle)
            }

            grid_view_model.clear();
            grid_view_model.append(first_page_data);
        }

    }

    //获取图片列表
    function getImageListByItemId(itemID)
    {
        for(var i = 0; i < contentlist.length; i++)
        {
            var content = contentlist[i];
            if(itemID === content.itemId)
            {
                //console.log(content.title, content.itemId, content.list[0].middle)

                var images = []

                for(var j = 0; j < content.list.length; j++)
                {
                    var temp = content.list[j];

                    images.push({"image": temp.big});
                }

                return [true, content.title, images]
            }
        }

        return [false, 0, null]
    }



    ImagesRequests{
        id: imagesRequests
    }

    Text{
        id: text_item
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 10
        height: 40
        font.pointSize: 10
        font.family: "微软雅黑"
        color: "#444444"
        text: classifyName
        verticalAlignment:Text.AlignVCenter
    }

    Button{
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.verticalCenter: text_item.verticalCenter

        buttonText: "更多"

        onButtonClicked: {
            root_item.moreImageByClassifyID(root_item.pagebean);
        }
    }

    ClassifyGridView{
        id: grid_view_item

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: text_item.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        rowCount: 3
        columnCount: 2

        model: ListModel{
            id: grid_view_model
        }

        onItemClicked: {

            console.log("Item " + currentID + " clicked!");
            var result = root_item.getImageListByItemId(currentID);

            var suc = result[0];
            if (suc)
            {
                console.log(result[1], result[2]);
                root_item.singelImageGroupClicked(result[1], result[2]);
            }
            else
            {
                console.warn("Can not find item: ", currentID);
            }
        }
    }
}
