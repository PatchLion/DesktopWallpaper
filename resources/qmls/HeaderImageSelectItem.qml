import QtQuick 2.0
import DesktopWallpaper.APIRequestEx 1.0
import "./Global.js" as Global
import "../controls/PLToast.js" as Toast
import "../controls"

PLImageCheckButtonItem {

    id: root_item

    property string source: ""

    defaultIcon: source
    pressedIcon: source
    hoverIcon: source
    disableIcon: source

    defaultBorderColor: "white"
    hoverBorderColor: "white"
    pressedBorderColor: "white"
    disabledBorderColor: "white"

    defaultColor: "white"
    pressedColor: "white"
    hoverColor: "white"
    disabledColor: "white"

    radius: 0

    APIRequestEx{id: api_request}
    Component.onCompleted: {
        api_request.defaultHeadImagesRequest(function(suc, msg, data){
            var result = Global.resolveAPIResponse(suc, msg, data);
            if(result[0]){
                var urls = result[1];

                var model_data = []


                for(var i = 0; i < urls.length; i++){

                    //console.log("Head image url-->", urls[i]);
                    model_data.push({"url": urls[i]});

                    if(0 === i){
                        root_item.source = urls[i];
                    }
                }

                images_model.clear();
                images_model.append(model_data);
            }
            else{
                Toast.showToast(Global.RootPanel, "获取默认头像列表失败: " + result[1]);
            }
        });
    }

    ListView{
        id: list_view_item

        visible:  root_item.isChecked
        anchors.top: parent.bottom
        anchors.topMargin: 5

        spacing: 0

        property int maxShowCount: images_model.count <= 3 ? images_model.count : 3

        width: parent.width
        height: parent.height * maxShowCount + (spacing - 1) * maxShowCount - 20

        model: ListModel{
            id: images_model
        }

        delegate: PLImageButtonItem{
            id: list_item
            property string source: url

            defaultIcon: url
            pressedIcon: url
            hoverIcon: url
            disableIcon: url

            defaultBorderColor: "white"
            hoverBorderColor:  "white"
            pressedBorderColor: "white"
            disabledBorderColor: "white"

            defaultColor: "white"
            pressedColor: "white"
            hoverColor: "white"
            disabledColor: "white"

            //color: ""
            width: list_view_item.width
            height: root_item.height

            onClicked: {
                console.log("Head image click:", list_item.source)
                root_item.source = list_item.source;

                root_item.isChecked = false;

                api_request.eventStatistics("header_image", "select", list_item.source);
            }

            Rectangle{
                anchors.fill: parent

                border.color: root_item.source == list_item.source ? "#4169E1" : "white"
                border.width: 2

                color: "transparent"
            }
        }

        clip: true
    }
}
