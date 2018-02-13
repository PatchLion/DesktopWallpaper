import QtQuick 2.0
import QtQuick.Window 2.2
import DesktopWallpaper.APIRequestEx 1.0
import DesktopWallpaper.DownloadBox 1.0
import "./Global.js" as Global
import "../controls"

Item{
    id: root_item
    property var window
    property bool enableDownloadBoxButton: true
    property bool enableSearchControl: true
    property bool enableUserPanel: true

    DownloadBox{
        id: downloader
    }

    APIRequestEx{id: api_request}
    onWindowChanged: {
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
    PLImageButtonItem{
        id: close_button
        width: Qt.platform.os === "windows" ? 24 : 0
        height: 24

        defaultIcon: "qrc:/images/button_24_0_2.png"
        pressedIcon: "qrc:/images/button_24_0_1.png"
        hoverIcon: "qrc:/images/button_24_0_1.png"
        disableIcon: "qrc:/images/button_24_0_0.png"

        anchors.right: parent.right
        anchors.rightMargin: Qt.platform.os === "windows" ? 0 : 0

        smooth: true

        anchors.verticalCenter: parent.verticalCenter
        visible: Qt.platform.os === "windows"


        radius: width/2

        onClicked: {
            Qt.quit();
        }
    }

    //最大化
    PLImageButtonItem{
        id: max_normal_button
        width: Qt.platform.os === "windows" ? close_button.width : 0
        height: close_button.height

        defaultIcon: (root_item.window.visibility === Window.Maximized) ? "qrc:/images/button_24_3_2.png" :  "qrc:/images/button_24_2_2.png"
        pressedIcon: (root_item.window.visibility === Window.Maximized) ? "qrc:/images/button_24_3_1.png" :  "qrc:/images/button_24_2_1.png"
        hoverIcon: (root_item.window.visibility === Window.Maximized) ? "qrc:/images/button_24_3_1.png" :  "qrc:/images/button_24_2_1.png"
        disableIcon: (root_item.window.visibility === Window.Maximized) ? "qrc:/images/button_24_3_0.png" :  "qrc:/images/button_24_2_0.png"

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
    PLImageButtonItem{
        id: min_button
        width: Qt.platform.os === "windows" ? close_button.width : 0
        height: max_normal_button.height

        defaultIcon: "qrc:/images/button_24_1_2.png"
        pressedIcon: "qrc:/images/button_24_1_1.png"
        hoverIcon: "qrc:/images/button_24_1_1.png"
        disableIcon: "qrc:/images/button_24_1_0.png"

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
            api_request.eventStatistics("downloadbox_button", "click", "1");
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
            visible: downloader.downloadingCount > 0

            text: (downloader.downloadingCount >= 10 ? "9+" : downloader.downloadingCount)

            fontPixelSize: 9

        }
    }

    //用户信息面板
    UserSimplePanel{
        id: user_panel
        height: 40
        anchors.right: download_box_button.left
        anchors.rightMargin: 40
        anchors.verticalCenter: download_box_button.verticalCenter

        enableUserPanel: root_item.enableUserPanel

    }
}
