import QtQuick 2.0
import "./Global.js" as Global
import "../controls"
import "../controls/PLCoverPanel.js" as CoverPanel
import "../controls/PLToast.js" as Toast

Rectangle {

    id:root_item
    color: Qt.rgba(0.3, 0.3, 0.3, 0.3)

    property string keyword: ""
    property var cover: null


    function startToSearch(keyword){
        root_item.keyword = keyword
        console.log("keyword change to:", keyword);
        Global.APIRequestEx.searchKeyWord(keyword);

        //Toast.showToast(root_item, "正在搜索中...");


        cover = CoverPanel.showLoadingCover(Global.RootPanel, "加载中");
    }

    ClassifyDetailPanel{
        anchors.fill: parent
    }

    Connections{
        //id:api_request
        target: Global.APIRequestEx

        onApiRequestError: {
            console.warn("Failed to search: ", apiName, "|", error)


            Toast.showToast(root_item, "搜索失败! 错误代码:"+error);


            if(root_item.cover)
            {
                root_item.cover.visible = false;
                root_item.cover.destroy();
            }
        }

        onSearchResponse: {

            var result = Global.resolveSearchResult(data);

            if(result[0])
            {
                var items = result[1];

                grid_view_model.clear();
                grid_view_model.append(items);
            }


            //Toast.showToast(root_item, "搜索完成");

            if(root_item.cover)
            {
                root_item.cover.visible = false;
                root_item.cover.destroy();
            }
        }
    }


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
            anchors.leftMargin: 5
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

            anchors.centerIn: parent
            font.pointSize: 11
            color: "white"
            clip: true
            text: "关键字：" + keyword
        }

        SearchControl{
            id: search_button

            width: 160
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            //property var cover: null

            visible: false
            smooth: true

            onStartSearch: {
                if (keyword.length>0){
                    grid_view_model.clear();
                    root_item.startToSearch(keyword);
                    //cover = CoverPanel.showLoadingCover(root_item, "加载中...");
                    //console.log("Cover-->", cover)
                }
            }
        }
    }




    ClassifyGridView{
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


        onContentXChanged: {
            console.log(contentX, contentWidth, width)
            var temp = contentWidth - width - 100
            if (contentX >= temp)
            {
                root_item.currentPageIndex += 1
                Global.APIRequestEx.requestItemsByClassify(root_item.classifyID, root_item.currentPageIndex);
            }
        }
    }
}
