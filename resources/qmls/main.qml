import QtQuick 2.3
import QtQuick.Window 2.2
import DesktopWallpaper.APIRequest 1.0
import "./Global.js" as Global
import "./DataCache.js" as DataCache

FramelessAndMoveableWindow {
    id: root_window
    visible: true
    //visibility: Window.Windowed
    flags: Qt.FramelessWindowHint | Qt.Window
    width: 800
    height: 600
    title: qsTr("Beauty Finder")

    color: "transparent"

    dragArea: Qt.rect(0, 0, width, 50)


    Rectangle{
        id: bg_rect
        color: "black"
        radius: 5
        anchors.fill: parent

        smooth: true

        Rectangle{
            id: head_area

            color: Qt.rgba(1, 1, 1, 0.15)

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 30

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
                font.pointSize: 10
                font.family: "微软雅黑"
                text: root_window.title
            }

            Button{
                id: close_button
                width: 16
                height: 16
                buttonText: "X"
                anchors.right: parent.right
                anchors.rightMargin: 10

                anchors.verticalCenter: parent.verticalCenter

                radius: 2

                onButtonClicked: {
                    Qt.quit();
                }
            }
            Button{
                id: max_normal_button
                width: close_button.width
                height: close_button.height
                buttonText: (root_window.visibility === Window.Maximized) ? "=" : "口"
                anchors.right: close_button.left
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                radius: close_button.radius

                onButtonClicked: {
                    if(root_window.visibility === Window.Maximized)
                    {
                        root_window.visibility = Window.Windowed
                    }
                    else
                    {
                        root_window.visibility = Window.Maximized
                    }
                }
            }
            Button{
                id: min_button
                width: max_normal_button.width
                height: max_normal_button.height
                buttonText: "-"
                anchors.right: max_normal_button.left
                anchors.rightMargin: 5
                anchors.top: close_button.top

                radius: close_button.radius

                onButtonClicked: {
                    root_window.visibility = Window.Minimized
                }
            }
        }


        Component{
            id: wallpaper_list_component

            WallpaperList{
                anchors.top: head_area.bottom
                anchors.margins: 1
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }

        }


    }
    APIRequest{
        id: api_reqeuest
    }

    Component.onCompleted: {
        Global.safeUrl = api_reqeuest.refererUrl();
        Global.mainForm = this;
        timer.start()
    }

    //延时加载图片分类列表
    Timer{
        id: timer
        interval: 10
        repeat: false
        running: false
        onTriggered: {
            wallpaper_list_component.createObject(bg_rect);
        }
    }

}
