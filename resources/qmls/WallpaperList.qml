import QtQuick 2.0
import QtQuick.Controls 2.2
import DesktopWallpaper.APIRequest 1.0
import "./Global.js" as Global

StackView {
    id: root_item

    initialItem: imageClassifyList_compnent

    Component{
        id: imageClassifyList_compnent
        ListView{
            id: imageClassifyList
            anchors.margins: 10
            orientation: ListView.Horizontal
            spacing: 30
            clip: true


            boundsBehavior: Flickable.OvershootBounds

            model:ListModel{
                id: imageClassifyListModel
            }

            delegate: ImageListInReview{
                classifyID: id
                classifyName: name
                width: 500
                height: imageClassifyList.height

                onMoreImageByClassifyID: {
                    root_item.push(classify_more_panel_componet);
                }

                onSingelImageGroupClicked: {
                    root_item.push(image_detail_panel_component);
                    root_item.currentItem.title = title;
                    root_item.currentItem.itemID = itemID;
                }
            }

            APIRequest{
                id: classifies_request

                onClassifiesResponse: {
                    //console.log("Classifies data:", data);

                    var result = Global.resolveClassifiesData(data);

                    if(result[0])
                    {
                        imageClassifyListModel.clear();
                        imageClassifyListModel.append(result[1]);
                    }
                }

                onApiRequestError: {
                    console.warn("Catch error when reuqest api:", apiName, "code:", error);
                }
            }



            Component.onCompleted: {
                classifies_request.requestClassifiesData();
            }
        }
    }

    //图片组详情界面
    Component{
        id: image_detail_panel_component
        ImageDetailPanel{
            id: image_detail_panel
            anchors.margins: 10

            onBackButtonClicked: {
                root_item.pop();
            }
        }
    }

    //分类详情界面
    Component{
        id: classify_more_panel_componet
        ClassifyDetailPanel{
            id: classify_more_panel

            onBackButtonClicked: {
                root_item.pop();
            }

        }
    }
}
