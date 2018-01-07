import QtQuick 2.0
import "./Global.js" as Global
import "./CoverPanel.js" as CoverPanel

import "./Toast.js" as Toast
Rectangle {

    id:root_item
    color: Qt.rgba(0.3, 0.3, 0.3, 0.3)

    property string keyword: ""
    property var cover: null


    function startToSearch(keyword){
        root_item.keyword = keyword
        console.log("keyword change to:", keyword);
        Global.APIRequest.searchKeyWord(keyword);

        //Toast.showToast(root_item, "正在搜索中...");


        cover = CoverPanel.showLoadingCover(Global.RootView, "加载中");
    }

    ClassifyDetailPanel{
        anchors.fill: parent
    }

    Connections{
        //id:api_request
        target: Global.APIRequest

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

        DefaultButton{
            id: back_button
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: 20
            buttonText: "返回"
            onButtonClicked: {
                Global.RootPanel.back();
            }
        }

        Text{
            id: text_item

            anchors.centerIn: parent
            font.family: "微软雅黑"
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
                Global.APIRequest.requestItemsByClassify(root_item.classifyID, root_item.currentPageIndex);
            }
        }
    }
}
