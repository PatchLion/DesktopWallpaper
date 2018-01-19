import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import DesktopWallpaper.APIRequestEx 1.0
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
    function showAllItemByClassifyPanel(title){
        main_stackView.push(classify_more_panel_componet);
        main_stackView.currentItem.classify = title;
        main_stackView.panelStackedPanel.push(DataType.PanelClassifyDetails);
        main_stackView.lastPage = DataType.PanelClassifyDetails;
    }

    //显示图片组详情 itemID: 图片组ID title: 图片组名称 source: 图片组源网址
    function showItemDetailsPanel(itemID, title, source){
        main_stackView.push(image_detail_panel_component);
        main_stackView.currentItem.itemUrl = source;
        main_stackView.currentItem.title = title;
        main_stackView.currentItem.itemID = itemID;
        main_stackView.panelStackedPanel.push(DataType.PanelImageDetails);
        main_stackView.lastPage = DataType.PanelImageDetails;
    }

    //显示搜索界面 keyword：关键词
    function showSearchPanel(keyword){
        main_stackView.push(search_page_component);
        //console.log("onShowSearchPanel: ", keyword);
        main_stackView.currentItem.startToSearch(keyword);
        main_stackView.panelStackedPanel.push(DataType.PanelSearchResult);
        main_stackView.lastPage = DataType.PanelSearchResult;
    }

    //显示下载盒子界面
    function showDownloadBoxButtonClicked(){
        main_stackView.push(download_box_component);
        main_stackView.panelStackedPanel.push(DataType.PanelDownloadBox);
        main_stackView.lastPage = DataType.PanelDownloadBox;
    }

    //显示VIP升级对话框
    function showVIPUpgradePanel(){
        var vippanel = vipupgrade_component.createObject(root_window, {"parent": bg_rect,
                                                    "anchors.fill": bg_rect,
                                                     "width": bg_rect.width,
                                                     "height": bg_rect.height});
    }

    //显示登录对话框
    function showLoginPanel(){
        var loginpanel = login_component.createObject(bg_rect);
        loginpanel.anchors.fill = bg_rect;
        loginpanel.width = bg_rect.width;
        loginpanel.height = bg_rect.height;
    }

    //显示我的收藏对话框
    function showPefersDetailsPanel(){
        main_stackView.push(pefers_details_component);
        main_stackView.panelStackedPanel.push(DataType.PanelPeferDetails);
        main_stackView.lastPage = DataType.PanelPeferDetails;
        main_stackView.currentItem.updatePefers();
    }
    //显示我的收藏Item详情对话框
    function showPefersImageDetailsPanel(itemID, title, source){
        main_stackView.push(pefers_image_details_component);
        main_stackView.panelStackedPanel.push(DataType.PanelPefersImageDetail);
        main_stackView.lastPage = DataType.PanelPefersImageDetail;
        main_stackView.currentItem.itemID=itemID;
        main_stackView.currentItem.title = title;
        main_stackView.currentItem.itemUrl = source;
    }
    //回退
    function back(){
        if (main_stackView.depth > 1){
            main_stackView.pop();
            main_stackView.panelStackedPanel.pop();
            main_stackView.lastPage = ((main_stackView.panelStackedPanel.length === 0) ? -1 : main_stackView.panelStackedPanel[main_stackView.panelStackedPanel.length-1])
        }
    }

    //更新用户信息
    function updateUserInfo(userinfo){
        user_information.updateUserInfo(userinfo.is_vip,
                                        userinfo.user,
                                        userinfo.headimage_url,
                                        userinfo.token,
                                        userinfo.nickname);

        Toast.showToast(root_window, "欢迎您:" + userinfo.nickname);

        api_request.getPefersRequest(userinfo.token, function(suc, msg, data){
            var result = Global.resolveAPIResponse(suc, msg, data);
            if(result[0]){
                user_information.clearPefers();

                //console.log("----------1");
                var pefers = result[1];
                //console.log("----------2");

                var keys = Object.keys(pefers);
                //console.log("ssss", keys);

                //console.log("----------3");
                for (var i = 0; i < keys.length; i++){

                    var key = keys[i];
                    //console.log("----------5");
                    //console.log("Addddddddddddddd: ", key, pefers[key]);
                    var imageIDs = pefers[key];

                    user_information.addPefer(key, imageIDs);


                }


            }
        });

    }

    //组件
    Component{ id: download_box_component; DownloadBox{}} //下载盒子组件
    Component{ id: mainpage_component; MainPage{}} //主页面组件
    Component{ id: search_page_component; SearchPage{}} //搜索页面组件
    Component{ id: classify_more_panel_componet; ClassifyDetailPanel{}} //分类详情界面组件
    Component{ id: image_detail_panel_component; ImageDetailPanel{ anchors.margins: 10 } }//图片组详情界面组件
    Component{ id: login_component; UserLoginPanel{}} //用户登录组件
    Component{ id: vipupgrade_component; VIPUpgrade{}} //VIP升级组件
    Component{ id: pefers_details_component; PefersDetailsPanel{}} //收藏详情
    Component{ id: pefers_image_details_component; PefersImageDetailPanel{}} //收藏Item详情

    //对象
    APIRequestEx{ id: api_request } //api请求对象
    UserManager {id: user_information } //用户信息对象

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

            z: 0

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



    Component.onCompleted: {

        Array.prototype.contains = function (obj) {
            var i = this.length;
            while (i--) {
                if (this[i] === obj) {
                    return true;
                }
            }
            return false;
        }

        Global.RootPanel = root_window;

        if (user_information.token.length > 0){
            //console.log("开始验证Token!")

            system_menu_panel.enableUserPanel = false;
            api_request.checkTokenRequest(user_information.token, function(suc, msg, data){
                var result = Global.resolveAPIResponse(suc, msg, data);
                system_menu_panel.enableUserPanel = true;
                if(result[0]){
                    var info = result[1];

                   updateUserInfo(info);

                }
                else{

                    Toast.showToast(root_window, "检测账户信息失败: " + result[1]);
                    user_information.clearUserInfo();
                }
            });
        }

        main_stackView.push(mainpage_component);
        main_stackView.panelStackedPanel.push(DataType.PanelMainPage) //页面栈类型记录
        main_stackView.lastPage = DataType.PanelMainPage

    }
}
