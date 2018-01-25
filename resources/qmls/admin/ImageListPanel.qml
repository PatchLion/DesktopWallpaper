import QtQuick 2.0
import DesktopWallpaper.APIRequestEx 1.0
import "../../controls/PLToast.js" as Toast
import "../../controls/PLCoverPanel.js" as Cover
import "../../controls"
import "../Global.js" as Global
import ".."

Rectangle{
    id: root_item

    APIRequestEx{ id: api_request } //api请求对象

    color: Qt.rgba(0.7, 0.7, 0.7, 0.3)

    property int currentPageIndex: 0
    property string currentClassify: ""

    Item{
        id: top_area

        height: 60

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.margins: 10

        PLImageButtonItem{
            anchors.top: parent.top
            anchors.right: parent.right

            width: 24
            height: 24

            defaultIcon: "qrc:/images/button_24_0_2.png"
            pressedIcon: "qrc:/images/button_24_0_1.png"
            hoverIcon: "qrc:/images/button_24_0_0.png"
            disableIcon: "qrc:/images/button_24_0_2.png"

            onClicked: {
                Qt.quit();
            }
        }

        ListView{
            height: 30

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            clip: true
            boundsBehavior: Flickable.StopAtBounds

            orientation: ListView.Horizontal

            spacing: 10

            PLCheckButtonGroup{
                id: buttons_group
            }

            delegate: PLCheckTextButton{
                text: name
                width: 160
                height: 30

                textPressedColor: "white"
                pressedColor: "#1E90FF"

                radius: 5

                onClicked: {
                    changeClassify(text);
                }
                Component.onCompleted: {
                    buttons_group.appendButton(this);

                    //console.log("buttons length:", buttons_group.buttons.length);
                    if (buttons_group.buttons.length == 1){
                        buttons_group.buttons[0].isChecked = true;
                        root_item.changeClassify(buttons_group.buttons[0].text);
                    }

                }
            }
            model: ListModel{
                id: classifies_model
            }

            Component.onCompleted: {
                var cover = Cover.showLoadingCover(root_item, "读取分类中...")
                api_request.classifiesRequest(function(suc, msg, data){
                    Global.destroyPanel(cover);

                    var result = Global.resolveAPIResponse(suc, msg, data);

                    console.log(result[0], result[1])
                    if(result[0]){
                        var model_data = Global.toClassifiesModelData(result[1]);
                        classifies_model.clear();
                        classifies_model.append(model_data)

                    }
                    else{
                        Toast.showToast(root_item, result[1]);
                    }
                });
            }
        }

    }

    ListView{
        id: image_list_item
        anchors.left: parent.left
        anchors.top: top_area.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.margins: 10

        spacing: 5

        clip: true
        //boundsBehavior: Flickable.StopAtBounds

        delegate: AdminItemDetails{
            height: 240
            width: image_list_item.width
            myID: itemID
            myTitle: title
        }

        model: ListModel{
            id: item_model
        }


        onContentYChanged: {
            console.log(contentY, contentHeight, height)
            var temp = contentHeight - height + 100
            if (contentY >= temp)
            {
                root_item.requestNextPage();
            }
        }
    }

    function changeClassify(classify){
        if (root_item.currentClassify !== classify){
            root_item.currentClassify = classify;
            item_model.clear();
            root_item.currentPageIndex = 0;
            requestNextPage();
        }

    }

    function requestNextPage(){

        root_item.currentPageIndex = root_item.currentPageIndex + 1

        console.log("请求下一页：",root_item.currentClassify, root_item.currentPageIndex)
         api_request.pageRequest(root_item.currentClassify, root_item.currentPageIndex, function(suc, msg, data){
            var result = Global.resolveAPIResponse(suc, msg, data);
            if(result[0]){
                var model_data = Global.toPageModelData(result[1]);

                if(model_data.length > 0){
                    item_model.append(model_data);
                }
                else{
                    Toast.showToast(root_item, "没有了或者网络不太好")
                }
            }

         });
    }

}
