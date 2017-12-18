import QtQuick 2.0
import DesktopWallpaper.APIRequest 1.0
import "./Global.js" as Global

Rectangle{
    id: root_item
    property int classifyID: -1
    property string classifyName: ""

    color: Qt.rgba(0.8, 0.8, 0.8, 0.2)

    signal moreImageByClassifyID(var pagebean); //更多
    signal singelImageGroupClicked(int itemID, string title); //点击图片组


    property var contentlist
    property var pagebean

    onClassifyIDChanged: {
        console.log("-->ID changed to ", classifyID);

        items_request.requestItemsByClassifyID(classifyID);
    }

    APIRequest{
        id: items_request

        onItemsByClassifyIDResponse: {
            if(root_item.classifyID == classifyID)
            {
                var result = Global.resolveItemsData(data, 6);

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

            root_item.singelImageGroupClicked(currentID, title);
        }
    }
}
