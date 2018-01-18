import QtQuick 2.0
import QtQuick.Dialogs 1.2
import DesktopWallpaper.APIRequestEx 1.0
import "../controls/PLToast.js" as Toast
import "./Global.js" as Global
import "../controls"
Item {
    id: root_item

    property string classify: ""
    property int currentPageIndex: 0
    property alias title: text_item.text

    APIRequestEx{id: api_request}

    function onClassifyOrIndexChanged(classify, index){
        api_request.pageRequest(classify, index, function(suc, msg, data){
            var result = Global.resolveAPIResponse(suc, msg, data);
            if(result[0]){
                grid_view_model.append(Global.toPageModelData(result[1]));
            }
            else{
                Toast.showToast(Global.RootPanel, "获取分页数据失败: " + result[1]);
            }
        });
    }

    onClassifyChanged: {
        grid_view_model.clear();
        if(classify){
            onClassifyOrIndexChanged(classify, 0);
        }
    }

    Rectangle{
        id: image_area

        anchors.fill: parent


        color: Qt.rgba(0.7, 0.7, 0.7, 0.3)


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
                //console.log(contentX, contentWidth, width)
                var temp = contentWidth - width - 100
                if (contentX >= temp)
                {
                    root_item.currentPageIndex += 1;
                    onClassifyOrIndexChanged(root_item.classify, root_item.currentPageIndex);
                }
            }
        }
    }


}
