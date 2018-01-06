import QtQuick 2.0
import "./Global.js" as Global

Rectangle{
    id: root_item
    property string classify: ""

    color: Qt.rgba(0.7, 0.7, 0.7, 0.3)

    radius: 3


    onClassifyChanged: {
        //console.log("Classify-->", classify);

        Global.APIRequest.requestItemsByClassify(classify, 1);
    }

    Connections{
        target: Global.APIRequest

        onItemsByClassifyResponse: {
            if(root_item.classify == classify)
            {
                var result = Global.resolvePageData(data, grid_view_item.rowCount*grid_view_item.columnCount);

                if(result[0])
                {
                    grid_view_model.clear();
                    grid_view_model.append(result[1]);
                }
            }
        }
        onApiRequestError: {
            console.warn("Catch error when reuqest api:", apiName, "code:", error);
        }
    }

    Item{
        id: top_area

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        height: 40


        Text{
            id: text_item
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 10
            height: 30
            font.pointSize: 13
            font.family: "微软雅黑"
            font.bold: true
            color: "#EEEEEE"
            text: classify
            verticalAlignment:Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        DefaultButton{
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.verticalCenter: parent.verticalCenter

            buttonText: "更多"
            width: 60
            height: 20

            onButtonClicked: {
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
