import QtQuick 2.0
import DesktopWallpaper.APIRequest 1.0
import "./Global.js" as Global

import "./Toast.js" as Toast
Rectangle {

    id:root_item
    color: Qt.rgba(0.3, 0.3, 0.3, 0.3)

    property string keyword: ""
    function startToSearch(keyword){
        root_item.keyword = keyword
        console.log("keyword change to:", keyword);
        api_request.searchKeyWord(keyword);

        Toast.showToast(root_item, "正在搜索中...");
    }

    ClassifyDetailPanel{
        anchors.fill: parent
    }

    APIRequest{
        id:api_request

        onApiRequestError: {
            console.warn("Failed to search: ", apiName, "|", error)


            Toast.showToast(root_item, "搜索失败! 错误代码:"+error);
        }

        onSearchResponse: {

            var result = Global.resolveSearchResult(data);

            if(result[0])
            {
                var items = result[1];

                grid_view_model.clear();
                grid_view_model.append(items);
            }


            Toast.showToast(root_item, "搜索完成");
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


            smooth: true

            onStartSearch: {
                if (keyword.length>0){
                    grid_view_model.clear();
                    root_item.startToSearch(keyword);
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
                api_request.requestItemsByClassify(root_item.classifyID, root_item.currentPageIndex);
            }
        }
    }
}
