import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import DesktopWallpaper.APIRequest 1.0
import DesktopWallpaper.UserManager 1.0
import "../controls/"
import "./Global.js" as Global
import "../controls/PLToast.js" as Toast
import "../controls/PLCoverPanel.js" as CoverPanel
import "./DataType.js" as DataType

PLFrameLessAndMoveableWindow
{
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

    //显示下载盒子界面
    signal showDownloadBoxButtonClicked();

    //显示VIP升级对话框
    signal showVIPUpgradePanel();

    //显示登录对话框
    signal showLoginPanel();


    //回退
    signal back();


    Component{
        id: api_request_component
        APIRequest{
            id: api_request
            onTokenCheckFinished: {
                var result = Global.resolveTokenCheckData(data);

                if(result[0]){
                    updateUserInformation(result[1]);
                }
                else{
                    clearUserInformation();
                    Toast.showToast(Global.RootPanel, "登录信息已过期, 请重新登录!");
                }
            }
        }
    }

    function clearUserInformation(){
        Global.User.isVip = false;
        Global.User.userName = "";
        Global.User.nickName = "";
        Global.User.token = "";
        Global.User.headerImage ="";

        Global.User.writeToHistory();
    }

    function updateUserInformation(data){

        Global.User.isVip = data["is_vip"];
        Global.User.userName = data["user"];
        Global.User.nickName = ((data["nickname"].length === 0) ? data["user"] : data["nickname"]);
        Global.User.token = data["token"];
        Global.User.headerImage = data["headimage_url"];

        console.log("nickname ----- > ", Global.User.nickName)
        Global.User.writeToHistory();
    }


    Rectangle{
        id: bg_rect
        color: "black"
        radius: Qt.platform.os === "windows" ? 5 : 0
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
                id: system_menu_panel
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
                anchors.left: parent.left
                anchors.right: parent.right

                enableDownloadBoxButton: main_stackView.lastPage !== DataType.PanelDownloadBox
                enableSearchControl: main_stackView.lastPage !== DataType.PanelSearchResult
            }

        }

        StackView{
            id: main_stackView

            //页面栈
            property var panelStackedPanel: []
            property int lastPage: -1

            anchors.fill: parent
            anchors.topMargin: top_area.height+1
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
        id: download_box_component

        DownloadBox{

        }
    }

    Component{
        id: mainpage_component


        MainPage{
        }

    }

    Component{
        id: user_component

        UserManager{

        }
    }

    Component.onCompleted: {
        Global.User = user_component.createObject();
        Global.APIRequest = api_request_component.createObject();
        //console.log("1-->", Global.APIRequest);
        Global.APIRequest.downloadingCountChanged.connect(function(count){
            console.log("Downloading count:", count);
            system_menu_panel.downloadCount = count;
        });
        Global.RootView = main_stackView;
        Global.RootPanel = root_window;


        user_connection_component.createObject();

        main_stackView.push(mainpage_component);
        main_stackView.panelStackedPanel.push(DataType.PanelMainPage)
        main_stackView.lastPage = DataType.PanelMainPage

        //var cover = CoverPanel.showLoadingCover(root_window, "加载中........");

        //var cover = CoverPanel.showProgressBarCover(root_window);
        //console.log("Cover-------->", cover);
        //if(0 !== cover)
        //{
            //CoverPanel.setProgressBarCoverProgress(cover, 0.35);
            //CoverPanel.setProgressBarCoverTooltip(cover, "测试进度");
        //}


        if (Global.User.token.length > 0){
            Global.APIRequest.tryToCheckToken(Global.User.token);
        }
    }

    //搜索页面
    Component{
        id: search_page_component
        SearchPage{

        }
    }

    onShowDownloadBoxButtonClicked: {
        main_stackView.push(download_box_component)
        main_stackView.panelStackedPanel.push(DataType.PanelDownloadBox)
        main_stackView.lastPage = DataType.PanelDownloadBox
    }

    onShowSearchPanel: {
        main_stackView.push(search_page_component)
        //console.log("onShowSearchPanel: ", keyword)
        main_stackView.currentItem.startToSearch(keyword);
        main_stackView.panelStackedPanel.push(DataType.PanelSearchResult)
        main_stackView.lastPage = DataType.PanelSearchResult
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
            main_stackView.panelStackedPanel.pop();
            main_stackView.lastPage = ((main_stackView.panelStackedPanel.length === 0) ? -1 : main_stackView.panelStackedPanel[main_stackView.panelStackedPanel.length-1])
        }

    }

    onShowAllItemByClassifyPanel: {
        main_stackView.push(classify_more_panel_componet);
        main_stackView.currentItem.classify = title;
        main_stackView.panelStackedPanel.push(DataType.PanelClassifyDetails)
        main_stackView.lastPage = DataType.PanelClassifyDetails
    }



    //图片组详情界面
       Component{
           id: image_detail_panel_component
           ImageDetailPanel{
               id: image_detail_panel
               anchors.margins: 10
           }
       }

       Component{
           id: login_component
           UserLoginPanel{

           }
       }

       onShowLoginPanel: {
           var loginpanel = login_component.createObject(root_window);

           loginpanel.anchors.fill = loginpanel.parent;
           loginpanel.width = root_window.width;
           loginpanel.height = loginpanel.height;

       }

     Component{
         id: vipupgrade_component
         VIPUpgrade{

         }
     }

     Component{
         id: user_connection_component
         Connections{
             id: user_connection
             target: Global.User
             onIsVipChanged:{

             }

             onTokenChanged:{

             }
             onHeaderImageChanged:{
                 system_menu_panel.headSource = Global.User.headerImage;
             }
             onUserNameChanged:{
                 //system_menu_panel.userName = Global.User.userName;

             }
             onNickNameChanged:{
                system_menu_panel.userName = Global.User.nickName;

                if(Global.User.nickName.length > 0){
                    Toast.showToast(Global.RootPanel, "欢迎你: "+Global.User.nickName);
                }
             }
         }
     }

    onShowVIPUpgradePanel: {
         var vippanel = vipupgrade_component.createObject(root_window, {"parent": root_window,
                                                         "anchors.fill": root_window,
                                                          "width": root_window.width,
                                                          "height": root_window.height});

    }

    onShowItemDetailsPanel: {
        main_stackView.push(image_detail_panel_component);
        main_stackView.currentItem.itemUrl = source
        main_stackView.currentItem.title = title;
        main_stackView.currentItem.itemID = itemID;
        main_stackView.panelStackedPanel.push(DataType.PanelImageDetails)
        main_stackView.lastPage = DataType.PanelImageDetails
    }

}
