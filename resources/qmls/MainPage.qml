import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import DesktopWallpaper.APIRequest 1.0
import "./Global.js" as Global

Item {
    id: root_item

    property var window //传入要控制放大缩小的Window对象

    Rectangle{
        id: head_area

        color: Qt.rgba(1, 1, 1, 0.15)

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 36

        Image{
            id: icon_image
            source: "qrc:/images/icon.png"
            width: 16
            height: 16
            fillMode: Image.PreserveAspectFit
            anchors.right: app_title_text.left
            anchors.rightMargin: 10

            smooth:true

            anchors.verticalCenter: parent.verticalCenter

        }

        Text{
            id: app_title_text
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            color: "white"
            font.pointSize: 11
            font.family: "微软雅黑"
            text: root_item.window.title
        }

        DefaultButton{
            id: close_button
            width: 18
            height: 18
            buttonText: "X"
            anchors.right: parent.right
            anchors.rightMargin: 10

            smooth: true

            anchors.verticalCenter: parent.verticalCenter

            radius: 2

            onButtonClicked: {
                Qt.quit();
            }
        }
        DefaultButton{
            id: max_normal_button
            width: close_button.width
            height: close_button.height
            buttonText: (root_item.window.visibility === Window.Maximized) ? "=" : "口"
            anchors.right: close_button.left
            anchors.rightMargin: 5

            smooth: true

            anchors.verticalCenter: close_button.verticalCenter

            radius: close_button.radius

            onButtonClicked: {
                if(root_item.window.visibility === Window.Maximized)
                {
                    root_item.window.visibility = Window.Windowed
                }
                else
                {
                    root_item.window.visibility = Window.Maximized
                }
            }
        }
        DefaultButton{
            id: min_button
            width: max_normal_button.width
            height: max_normal_button.height
            buttonText: "-"
            anchors.right: max_normal_button.left
            anchors.rightMargin: 5

            smooth: true

            anchors.verticalCenter: close_button.verticalCenter

            radius: close_button.radius

            onButtonClicked: {
                root_item.window.visibility = Window.Minimized
            }
        }

        SearchControl{
            id: search_button

            width: 160
            height: close_button.height
            anchors.right: min_button.left
            anchors.rightMargin: 10
            anchors.verticalCenter: close_button.verticalCenter


            smooth: true

            onStartSearch: {
                if (keyword.length>0){
                    //console.log("Search keyword =", keyword)
                    Global.RootPanel.showSearchPanel(keyword);
                }
            }
        }
    }

    ListView{
        id: imageClassifyList

        anchors.top: head_area.bottom
        anchors.topMargin: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        orientation: ListView.Horizontal
        spacing: 4
        clip: true


        boundsBehavior: Flickable.OvershootBounds

        model:ListModel{
            id: imageClassifyListModel
        }

        delegate: ImageListInReview{
            classify: name
            width: 500
            height: imageClassifyList.height
        }

        APIRequest{
            id: classifies_request

            onClassifiesResponse: {
                //console.log("Classifies data:", data);

                var result = Global.runFuncWithUseTime(Global.resolveClassifiesData, "Global.resolveClassifiesData", data);

                //console.log("UseTime:", start, end,  end-start);

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
            timer.start();
        }

        //延时加载图片分类列表
        Timer{
            id: timer
            interval: 1
            repeat: false
            running: false
            onTriggered: {
                classifies_request.requestClassifiesData();
            }
        }

    }
}
