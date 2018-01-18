import QtQuick 2.0
import DesktopWallpaper.APIRequestEx 1.0
import "./Global.js" as Global
import "../controls"
import "../controls/PLCoverPanel.js" as CoverPanel
import "../controls/PLToast.js" as Toast

Rectangle {

    id:root_item
    color: Qt.rgba(0.3, 0.3, 0.3, 0.3)

    property string keyword: ""

    function startToSearch(keyword){
        search_button.startSearch(keyword);
    }

    APIRequestEx{id: api_request}

    ClassifyDetailPanel{
        anchors.fill: parent
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
                    console.log("开始搜索关键词: " + keyword)
                    grid_view_model.clear();
                    root_item.keyword = keyword
                    var cover = CoverPanel.showLoadingCover(Global.RootPanel, "搜索中...");
                    api_request.searchRequest(keyword, function(suc, msg, data){
                        Global.destroyPanel(cover);
                        var result = Global.resolveAPIResponse(suc, msg, data, true);

                        console.log("搜索结果: " + result[0]);

                        if(result[0]){
                            var model_data = Global.toPageModelData(result[1]);
                            if (model_data.length > 0){
                                console.log("Search result length: " + model_data.length);
                                grid_view_model.append(model_data);
                            }
                            else{
                                Toast.showToast(Global.RootPanel, "抱歉!按照您提供的关键词，我们没有搜索到任何结果!");
                            }

                        }
                        else{
                            Toast.showToast(Global.RootPanel, result[1]);
                        }
                    });
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
    }
}
