import QtQuick 2.0
import QtQuick.Controls 2.2
import DesktopWallpaper.ImageClassify 1.0
import "./Global.js" as Global

StackView {
    id: root_item

    ImageClassify{
        id: classifies_item
    }


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
                width: 600
                height: imageClassifyList.height

                onMoreImageByClassifyID: {
                    root_item.push(classify_more_panel_componet);


                    if(pagebean)
                    {
                        var contentlist = pagebean.contentlist;

                        var first_page_data = []
                        for(var i = 0; i < contentlist.length; i++){

                            var content = contentlist[i];
                            first_page_data.push({"itemID": content.itemId, "title":content.title, "image": content.list[0].middle});

                            console.log(content.title, content.itemId, content.list[0].middle)
                        }

                        root_item.currentItem.model.clear();
                        root_item.currentItem.model.append(first_page_data);
                    }
                }

                onSingelImageGroupClicked: {
                    root_item.push(image_detail_panel_component);
                    root_item.currentItem.title = title;
                    root_item.currentItem.model.clear();
                    root_item.currentItem.model.append(imagelist)
                }
            }


            Component.onCompleted: {
                updateClassifiesListView();
            }


            //刷新分类数据列表
            function updateClassifiesListView(){
                var classifies_string = classifies_item.classifies();

                var result = Global.resolveClassifiesData(classifies_string);

                if(result[0])
                {
                    imageClassifyListModel.clear();
                    imageClassifyListModel.append(result[1]);
                }
                else
                {
                    console.warn("解析分类数据出现异常");
                }
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
