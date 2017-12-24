import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import DesktopWallpaper.APIRequest 1.0
import "./Global.js" as Global

FramelessAndMoveableWindow {
    id: root_window
    visible: true
    width: 1200
    height: 700
    title: qsTr("Beauty Finder")
    color: "transparent"
    dragArea: Qt.rect(0, 0, width, 50)
    //visibility: Window.Windowed



    //分类下更多的items classifyID：分类ID
    signal showAllItemByClassifyPanel(string title);

    //显示图片组详情 itemID: 图片组ID title: 图片组名称 source: 图片组源网址
    signal showItemDetailsPanel(string itemID, string title, string source);

    //显示搜索界面 keyword：关键词
    signal showSearchPanel(string keyword);

    //回退
    signal back();


    Rectangle{
        id: bg_rect
        color: "black"
        radius: 5
        anchors.fill: parent

        clip: true

        smooth: true

        Rectangle{
            id: top_area
            color: Qt.rgba(1, 1, 1, 0.15)
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 40
            border.width: 0


            SystemMenuPanel{

                window: root_window
                Component.onCompleted: {
                    //if (Qt.platform.os == "windows")
                    //{

                        anchors.right = parent.right;
                        anchors.rightMargin = 10;
                    //}
                    //else if (Qt.platform.os == "osx"){
                        //anchors.left = parent.left;
                        //anchors.leftMargin = 10;
                    //}
                }

                anchors.verticalCenter: parent.verticalCenter

            }

        }

        StackView{
            id: main_stackView

            anchors.fill: parent
            anchors.topMargin: top_area.height+1


            initialItem: mainpage_component
        }

        Keys.onEscapePressed: {
            root_window.back();

        }

        Keys.onBackPressed: {
            root_window.back();
        }

        focus: true
    }


    Component{
        id: mainpage_component

        MainPage{

        }

    }

    Component.onCompleted: {
        Global.RootPanel = root_window;

    }

    //搜索页面
    Component{
        id: search_page_component
        SearchPage{

        }
    }

    onShowSearchPanel: {
        main_stackView.push(search_page_component)
        //console.log("onShowSearchPanel: ", keyword)
        main_stackView.currentItem.startToSearch(keyword);
    }

    //分类详情界面
    Component{
        id: classify_more_panel_componet
        ClassifyDetailPanel{
            id: classify_more_panel


        }
    }

    onBack: {
        if (main_stackView.depth > 1)
        {
            main_stackView.pop();
        }
    }

    onShowAllItemByClassifyPanel: {
        main_stackView.push(classify_more_panel_componet);
        main_stackView.currentItem.classify = title;
    }



    //图片组详情界面
       Component{
           id: image_detail_panel_component
           ImageDetailPanel{
               id: image_detail_panel
               anchors.margins: 10
           }
       }

    onShowItemDetailsPanel: {
        main_stackView.push(image_detail_panel_component);
        main_stackView.currentItem.itemUrl = source
        main_stackView.currentItem.title = title;
        main_stackView.currentItem.itemID = itemID;
    }

}
