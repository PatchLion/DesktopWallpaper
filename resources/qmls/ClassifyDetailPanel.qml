import QtQuick 2.0
import QtQuick.Dialogs 1.2

import DesktopWallpaper.APIRequest 1.0
import "./Toast.js" as Toast
import "./Global.js" as Global

Item {
    id: root_item

    signal itemClicked(int currentID, string title, string itemurl);

    signal backButtonClicked();
    //property alias model: grid_view_model
    property int classifyID: -1
    property int currentPageIndex: 1


    property bool isUseReferer: false
    APIRequest{
        id:api_request

        onItemsByClassifyIDResponse: {
            var result = Global.resolvePageData(data, isUseReferer)
            if(result[0])
            {
                //grid_view_model.clear();
                grid_view_model.append(result[1]);
            }

        }
    }

    onClassifyIDChanged: {
        api_request.requestItemsByClassifyID(classifyID, currentPageIndex);
    }

    Rectangle{
        id: image_area

        anchors.fill: parent
        anchors.topMargin: 1

        color: Qt.rgba(0.7, 0.7, 0.7, 0.3)

        ClassifyGridView{
            anchors.fill: parent

            anchors.topMargin: 35
            columnCount: 3

            flow: GridView.FlowTopToBottom

            model: ListModel{
                id: grid_view_model
            }

            onItemClicked: {
                root_item.itemClicked(currentID, title,itemurl);
            }


            onContentXChanged: {
                console.log(contentX, contentWidth, width)
                var temp = contentWidth - width - 100
                if (contentX >= temp)
                {
                    root_item.currentPageIndex += 1
                    api_request.requestItemsByClassifyID(root_item.classifyID, root_item.currentPageIndex);
                }
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
        height: 30

        Button{
            id: back_button
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.top: parent.top
            anchors.topMargin: 10
            width: 60
            height: 20
            buttonText: "返回"
            onButtonClicked: {
                root_item.backButtonClicked();
            }
        }
    }




}
