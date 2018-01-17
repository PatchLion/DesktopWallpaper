import QtQuick 2.0
import DesktopWallpaper.APIRequestEx 1.0
import "./Global.js" as Global
import "../controls/PLToast.js" as Toast
import "../controls"

Rectangle{
    id: root_item
    property string classify: ""

    color: Qt.rgba(0.7, 0.7, 0.7, 0.3)

    radius: 3

    APIRequestEx{id: api_request}

    onClassifyChanged: {
        api_request.pageRequest(classify, 0, function(suc, msg, data){

            if (suc){
                var result = Global.resolveStandardData(data);

                if(result[0] && result[1] === 0){


                    var model_data = [];
                    var childlist = result[3].items;

                    var limit = grid_view_item.rowCount*grid_view_item.columnCount //限制个数

                    for(var j = 0; j<childlist.length; j++)
                    {
                        var item = childlist[j];

                        model_data.push({"itemID": item.id, "newOne": item.new, "image": item.image, "title": item.title, "sourcePage":item.source});

                        if (limit > 0 && j>=(limit-1))
                        {
                            break;
                        }
                    }

                    grid_view_model.clear();
                    grid_view_model.append(model_data);
                }
                else{
                    Toast.showToast(Global.RootPanel, "获取分页数据失败: "+result[2]);
                }
            }
            else{
                Toast.showToast(Global.RootPanel, "获取分页数据失败: "+msg);
            }
       });
    }

    Item{
        id: top_area

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        height: 40


        PLTextWithDefaultFamily{
            id: text_item
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 10
            height: 30
            font.pointSize: 13
            font.bold: true
            color: "#EEEEEE"
            text: classify
            verticalAlignment:Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        PLTextButton{
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.verticalCenter: parent.verticalCenter

            text: "更多"
            width: 60
            height: 24

            onClicked: {
                Global.RootPanel.showAllItemByClassifyPanel(root_item.classify);
            }
        }

    }

    ClassifyGridView{
        id: grid_view_item

        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: top_area.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5

        rowCount: 3
        columnCount: 2

        model: ListModel{
            id: grid_view_model
        }
    }
}
