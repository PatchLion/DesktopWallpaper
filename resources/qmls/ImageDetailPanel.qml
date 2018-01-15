import QtQuick 2.9
import QtQuick.Dialogs 1.2
import DesktopWallpaper.WallpaperSetter 1.0

import "../controls"
import "../controls/PLToast.js" as Toast
import "./Global.js" as Global
import "../controls/PLCoverPanel.js" as CoverPanel
import "../controls/PLMessageBoxItem.js" as MessageBox

Item {
    id: root_item

    property alias title: text_item.text
    property string itemID: ""

    property string itemUrl: ""


    Connections{
        target: Global.APIRequest
        onItemsDetailResponse: {
            var result = Global.resolveItemsDetailData(data);


            if(result[0])
            {
                images_list_model.clear();
                images_list_model.append(result[1]);

                downloadall_button.enabled = true;
            }
        }


        onApiRequestError: {
            console.warn("Catch error when reuqest api:", apiName, "code:", error);
        }
    }

    onItemIDChanged: {
        Global.APIRequest.requestItemsDetailData(itemID);
    }

    Rectangle{
        id: image_area

        anchors.fill: parent


        color: Qt.rgba(0.7, 0.7, 0.7, 0.3)

        ListView{
            id: listview_item
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 10

            spacing: 5

            clip: true
            boundsBehavior: Flickable.StopAtBounds

            orientation: ListView.Horizontal

            model: ListModel{
                id: images_list_model
            }

            delegate: Item{

                height: listview_item.height
                width: image_item.status === Image.Ready ? image_item.width : loadding_image.width

                visible: !(image_item.status === Image.Error || image_item.status === Image.Null)

                Rectangle{
                    id: loadding_image

                    anchors.bottom: parent.bottom
                    //anchors.bottomMargin: 10

                    height: image_item.height

                    visible: !image_item.visible

                    width: 400

                    color: Qt.rgba(0.3, 0.3, 0.3, 0.3)

                    //border.color: Qt.rgba(0.6, 0.6, 0.6, 0.3)
                    //border.width: 1

                    PLTextWithDefaultFamily{
                        text: qsTr("Loadding......")

                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                        color: "white"

                        font.pointSize: 11

                    }


                }

                Image{

                    id: image_item
                    //anchors.centerIn: parent
                    anchors.bottom: parent.bottom
                    //anchors.bottomMargin: 10

                    cache: true

                    smooth: false
                    mipmap: false


                    height: parent.height * 0.93

                    visible: status === Image.Ready

                    fillMode: Image.PreserveAspectCrop

                    sourceSize.height: height

                    source: image

                    MouseArea{
                        id: image_mouse_area
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true


                    }

                    PLTextButton{
                        id: set_wallpaper_button


                        text: "设置为壁纸"
                        width: 130
                        height: download_button.height
                        anchors.right: download_button.left
                        anchors.rightMargin: 10
                        anchors.verticalCenter: download_button.verticalCenter
                        property var cover: null
                        onClicked: {
                            cover = CoverPanel.showProgressBarCover(Global.RootPanel);
                            wallpaper_item.setImageToDesktop(image_item.source);
                        }

                        //visible: download_button.visible

                        WallpaperSetter{
                            id: wallpaper_item

                            onProgress: {
                                if(set_wallpaper_button.cover){
                                    CoverPanel.setProgressBarCoverProgress(set_wallpaper_button.cover, progress);
                                    CoverPanel.setProgressBarCoverTooltip(set_wallpaper_button.cover, text);
                                }
                            }

                            onFinished: {

                                if(set_wallpaper_button.cover){
                                    set_wallpaper_button.cover.visible = false;
                                }

                                if(success){
                                    Toast.showToast(root_item, "壁纸已设置！")

                                }
                                else{
                                    Toast.showToast(root_item, "壁纸设置失败,"+msg)
                                }
                            }
                        }
                    }

                    PLTextButton{

                        id: download_button



                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        width: 60
                        height: 20
                        text: "下载"

                        //visible: (image_mouse_area.containsMouse || download_button.isContainMouse)

                        Component{
                            id: file_dialog_component
                            FileDialog
                            {
                                id: file_dialog
                                nameFilters: [ "PNG(*.png)", "JPG(*.jpg)" ]
                                selectMultiple: false

                                title: "Please choose a directory"
                                selectFolder: true
                                selectExisting: true
                                folder: shortcuts.pictures

                                onAccepted: {
                                    var source = image_item.source;

                                    Global.APIRequest.addDownload(fileUrl, Global.fixedDirName(root_item.title), [source]);
                                }

                                Component.onCompleted: visible=true
                            }
                        }
                        onClicked: {
                            var file_dialog = file_dialog_component.createObject(root_item);
                        }
                    }
                }
            }
        }
    }

    Item{
        id: top_area

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        height: 50

        PLTextButton{
            id: back_button
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: 20
            text: "返回"
            onClicked: {

                Global.RootPanel.back()
            }


        }

        PLTextButton{

            id: link_button

            anchors.right: downloadall_button.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 100
            height: 20
            text: "跳转到源网页"

            onClicked: {
                console.log("Jump to", root_item.itemUrl)
                Qt.openUrlExternally(root_item.itemUrl)
            }
        }


        PLTextButton{
            id: downloadall_button
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            width: 80
            height: 20
            text: "下载所有"
            enabled: false


            CircleTooltip{
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: -8
                anchors.topMargin: -8
                text:"VIP"
                visible: !Global.User.isVip
            }

            Component{
                id: dir_dialog_component
                FileDialog
                {
                    id: dir_dialog

                    title: "Please choose a directory"
                    selectFolder: true
                    selectExisting: true
                    folder: shortcuts.pictures
                    selectMultiple: false

                    onAccepted: {
                        //var dest = fileUrl;
                        var urls = []
                        for(var i = 0; i<images_list_model.count; i++)
                        {
                            var obj = images_list_model.get(i);
                            if(obj)
                            {
                                var image = obj["image"];
                                urls.push(image);
                                //console.log(image, urls.length)
                            }

                        }

                        //console.log(fileUrl, Global.fixedDirName(root_item.title))
                        Global.APIRequest.addDownload(fileUrl, Global.fixedDirName(root_item.title), urls)
                    }

                    Component.onCompleted: visible=true
                }
            }

            onClicked: {

                if(!Global.User.isVip){
                    var messagebox = MessageBox.showMessageBox(Global.RootPanel, "该功能为VIP功能，如果需要使用请升级为VIP!", function(){
                        if(messagebox){
                            messagebox.visible = false;
                            messagebox.destroy();

                            Global.RootPanel.showVIPUpgradePanel();
                        }
                    });
                }
                else{
                    var dir_dialog = dir_dialog_component.createObject(root_item);
                }
            }
        }
        PLTextWithDefaultFamily{
            id: text_item
            height: 30
            font.pointSize: 10
            color: "#EEEEEE"
            text: "Title"
            verticalAlignment:Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: back_button.verticalCenter
        }

    }
}

