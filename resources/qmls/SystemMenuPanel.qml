import QtQuick 2.0
import QtQuick.Window 2.2
import "./Global.js" as Global
import "../controls"

Item{
    id: root_item
    property var window
    property bool enableDownloadBoxButton: true
    property bool enableSearchControl: true

    property int downloadCount: 0

    onWindowChanged: {
        max_normal_button.text = ((root_item.window.visibility === Window.Maximized) ? "=" : "口");
        title_text_item.text = root_item.window.title
    }

    PLTextWithDefaultFamily{
        id: title_text_item
        anchors.verticalCenter: close_button.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        text: root_item.window.title
        font.pixelSize: 18
        visible: false
        color: "#87CEFA"

    }


    width: 260
    height: 30

    //关闭
    PLTextButton{
        id: close_button
        width: Qt.platform.os === "windows" ? 22 : 0
        height: 22
        text: "X"
        anchors.right: parent.right
        anchors.rightMargin: Qt.platform.os === "windows" ? 10 : 0

        smooth: true

        anchors.verticalCenter: parent.verticalCenter
        visible: Qt.platform.os === "windows"


        radius: width/2

        onClicked: {
            Qt.quit();
        }
    }

    //最大化
    PLTextButton{
        id: max_normal_button
        width: Qt.platform.os === "windows" ? close_button.width : 0
        height: close_button.height
        text: (root_item.window.visibility === Window.Maximized) ? "=" : "口"
        anchors.right: close_button.left
        anchors.rightMargin: Qt.platform.os === "windows" ? 5 : 0

        smooth: true

        anchors.verticalCenter: close_button.verticalCenter
        visible: close_button.visible


        radius: close_button.radius

        onClicked: {
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
    PLTextButton{
        id: min_button
        width: Qt.platform.os === "windows" ? close_button.width : 0
        height: max_normal_button.height
        text: "-"
        anchors.right: max_normal_button.left
        anchors.rightMargin: Qt.platform.os === "windows" ? 5 : 0

        smooth: true
        visible: close_button.visible

        anchors.verticalCenter: close_button.verticalCenter

        radius: close_button.radius

        onClicked: {
            root_item.window.visibility = Window.Minimized;
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
    PLTextButton{
        id: download_box_button
        width: 60
        height: search_control.height
        text: "下载盒子"
        anchors.right: search_control.left
        anchors.rightMargin: 10

        enabled: enableDownloadBoxButton

        radius: 3

        smooth: true

        anchors.verticalCenter: close_button.verticalCenter

        //radius: close_button.radius

        onClicked: {
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
