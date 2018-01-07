import QtQuick 2.0
import QtQuick.Window 2.2
import "./Global.js" as Global

Item{
    id: root_item
    property var window
    property bool enableDownloadBoxButton: true
    property bool enableSearchControl: true

    property int downloadCount: 0


    width: 260
    height: 30

    //关闭
    DefaultButton{
        id: close_button
        width: 18
        height: 18
        buttonText: "X"
        anchors.right: parent.right
        anchors.rightMargin: 10

        smooth: true

        anchors.verticalCenter: parent.verticalCenter

        radius: width/2

        onButtonClicked: {
            Qt.quit();
        }
    }

    //最大化
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

    //最小化
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

    //搜索框
    SearchControl{
        id: search_control

        width: 160
        height: close_button.height
        anchors.right: min_button.left
        anchors.rightMargin: 10
        anchors.verticalCenter: close_button.verticalCenter

        enabled: enableSearchControl

        smooth: true

        onStartSearch: {
            if (keyword.length>0){
                //console.log("Search keyword =", keyword)
                Global.RootPanel.showSearchPanel(keyword);
                //root_item.searchButtonClicked(keyword)
            }
        }
    }

    //下载盒子按钮
    DefaultButton{
        id: download_box_button
        width: 60
        height: search_control.height
        buttonText: "下载盒子"
        anchors.right: search_control.left
        anchors.rightMargin: 10

        enabled: enableDownloadBoxButton

        radius: 3

        smooth: true

        anchors.verticalCenter: close_button.verticalCenter

        //radius: close_button.radius

        onButtonClicked: {
            Global.RootPanel.showDownloadBoxButtonClicked();
        }

        CircleTooltip{
            id: downloading_count_item

            width: 16
            height: 16

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: -6
            anchors.topMargin: -6
            visible: root_item.downloadCount > 0

            text: (downloadCount >= 10 ? "9+" : downloadCount)

            fontPixelSize: 9

        }
    }
}
