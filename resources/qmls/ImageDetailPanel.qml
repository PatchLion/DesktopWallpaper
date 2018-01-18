import QtQuick 2.9
import QtQuick.Dialogs 1.2
import DesktopWallpaper.APIRequestEx 1.0
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

    APIRequestEx{id:api_request}

    Connections {
        target: Global.APIRequestEx
        onItemsDetailResponse: {

        }

        onAddPeferFinished: {
            root_item.cover.visible = false
            root_item.cover.destroy()

            var result = Global.resolveAddPeferData(data)

            if (result[0]) {
                Toast.showToast(Global.RootPanel, "图片收藏成功")
            } else {
                Toast.showToast(Global.RootPanel, "图片收藏失败:" + result[1])
            }
        }

        onApiRequestError: {
            console.warn("Catch error when reuqest api:", apiName,
                         "code:", error)
        }
    }

    function toModelData(data){
        var model_data = [];

        var childlist = data.images;

        for(var j = 0; j<childlist.length; j++)
        {
            var item = childlist[j];
            model_data.push({ "image": item.image, "imageid": item.id});
        }

        return model_data;
    }

    onItemIDChanged: {


        api_request.itemRequest(itemID, function(suc, msg, data){




            var result = Global.resolveItemsDetailData(data)

            if (result[0]) {
                images_list_model.clear()
                images_list_model.append(result[1])

                downloadall_button.enabled = true
                prefer_imagegroup_button.enabled = true
            }
        });
    }

    Rectangle {
        id: image_area

        anchors.fill: parent

        color: Qt.rgba(0.7, 0.7, 0.7, 0.3)

        ListView {
            id: listview_item
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 10

            spacing: 5

            clip: true
            boundsBehavior: Flickable.StopAtBounds

            orientation: ListView.Horizontal

            model: ListModel {
                id: images_list_model
            }

            delegate: Item {

                id: image_content_item

                height: listview_item.height
                width: image_item.status === Image.Ready ? image_item.width : loadding_image.width

                visible: !(image_item.status === Image.Error
                           || image_item.status === Image.Null)

                property int currentID: imageid

                Rectangle {
                    id: loadding_image

                    anchors.bottom: parent.bottom

                    //anchors.bottomMargin: 10
                    height: image_item.height

                    visible: !image_item.visible

                    width: 400

                    color: Qt.rgba(0.3, 0.3, 0.3, 0.3)


                    //border.color: Qt.rgba(0.6, 0.6, 0.6, 0.3)
                    //border.width: 1
                    PLTextWithDefaultFamily {
                        text: qsTr("Loadding......")

                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                        color: "white"

                        font.pointSize: 11
                    }
                }

                Image {

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

                    MouseArea {
                        id: image_mouse_area
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                    }

                    Rectangle{
                        anchors.right: parent.right
                        anchors.rightMargin: 20
                        anchors.top: parent.top
                        anchors.topMargin: 25
                        radius: 5
                        color: Qt.rgba(1, 1, 1, 0.6)
                        height: 40
                        width: 133

                        Row{
                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 24

                            spacing: 15

                            PLImageCheckButtonItem {

                                id: prefer_button

                                width: 24
                                height: 24

                                defaultIcon: isChecked ? "qrc:/images/pefer_default.png": "qrc:/images/no_pefer_default.png"
                                pressedIcon: isChecked ? "qrc:/images/pefer_hover.png": "qrc:/images/no_pefer_hover.png"
                                hoverIcon: isChecked ? "qrc:/images/pefer_hover.png": "qrc:/images/no_pefer_hover.png"
                                disableIcon: isChecked ? "qrc:/images/pefer_default.png": "qrc:/images/no_pefer_default.png"

                                PLTooltip {
                                    target: parent
                                    text: "收藏图片"
                                    mouseArea: prefer_button.mouseArea
                                    tipPosMode: 1
                                }

                                onClicked: {
                                    if (Global.User.token.length === 0)
                                    {
                                        var messagebox = MessageBox.showMessageBox(
                                                    Global.RootPanel, "收藏功能需要登录后才能使用!",
                                                    function () {
                                                        Global.RootPanel.showLoginPanel();
                                                        messagebox.visible = false;
                                                        messagebox.destroy();
                                                    })
                                    } else {

                                        var cover = CoverPanel.showLoadingCover(
                                                    Global.RootPanel, "添加收藏中...")
                                        //执行收藏操作
                                        api_request.addPeferRequest(Global.User.token, [image_content_item.currentID])

                                    }
                                }
                            }

                            PLImageButtonItem {
                                id: set_wallpaper_button

                                width: 24
                                height: 24

                                property var cover: null
                                onClicked: {
                                    cover = CoverPanel.showProgressBarCover(
                                                Global.RootPanel)
                                    wallpaper_item.setImageToDesktop(image_item.source)
                                }
                                PLTooltip {
                                    target: parent
                                    text: "设置壁纸"
                                    mouseArea: set_wallpaper_button.mouseArea
                                    tipPosMode: 1
                                }
                                defaultIcon: "qrc:/images/set_wallpaper_default.png"
                                pressedIcon: "qrc:/images/set_wallpaper_hover.png"
                                hoverIcon: "qrc:/images/set_wallpaper_hover.png"
                                disableIcon: "qrc:/images/set_wallpaper_default.png"
                                //visible: download_button.visible
                                WallpaperSetter {
                                    id: wallpaper_item

                                    onProgress: {
                                        if (set_wallpaper_button.cover) {
                                            CoverPanel.setProgressBarCoverProgress(
                                                        set_wallpaper_button.cover,
                                                        progress)
                                            CoverPanel.setProgressBarCoverTooltip(
                                                        set_wallpaper_button.cover,
                                                        text)
                                        }
                                    }

                                    onFinished: {

                                        if (set_wallpaper_button.cover) {
                                            set_wallpaper_button.cover.visible = false
                                        }

                                        if (success) {
                                            Toast.showToast(root_item, "壁纸已设置！")
                                        } else {
                                            Toast.showToast(root_item, "壁纸设置失败," + msg)
                                        }
                                    }
                                }
                            }

                            PLImageButtonItem {

                                id: download_button

                                width: 24
                                height: 24

                                PLTooltip {
                                    target: parent
                                    text: "下载"
                                    mouseArea: download_button.mouseArea
                                    tipPosMode: 1
                                }
                                defaultIcon: "qrc:/images/download_default.png"
                                pressedIcon: "qrc:/images/download_hover.png"
                                hoverIcon: "qrc:/images/download_hover.png"
                                disableIcon: "qrc:/images/download_default.png"


                                //visible: (image_mouse_area.containsMouse || download_button.isContainMouse)
                                Component {
                                    id: file_dialog_component
                                    FileDialog {
                                        id: file_dialog
                                        nameFilters: ["PNG(*.png)", "JPG(*.jpg)"]
                                        selectMultiple: false

                                        title: "Please choose a directory"
                                        selectFolder: true
                                        selectExisting: true
                                        folder: shortcuts.pictures

                                        onAccepted: {
                                            var source = image_item.source

                                            Global.APIRequestEx.addDownload(
                                                        fileUrl, Global.fixedDirName(
                                                            root_item.title), [source])
                                        }

                                        Component.onCompleted: visible = true
                                    }
                                }
                                onClicked: {
                                    var file_dialog = file_dialog_component.createObject(
                                                root_item)
                                }
                            }

                        }
                    }

                }
            }
        }
    }

    Item {
        id: top_area

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        height: 50

        PLTextButton {
            id: back_button
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: 24
            text: "返回"
            onClicked: {

                Global.RootPanel.back()
            }
        }

        PLTextButton {

            id: link_button

            anchors.right: downloadall_button.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 100
            height: back_button.height
            text: "跳转到源网页"

            onClicked: {
                console.log("Jump to", root_item.itemUrl)
                Qt.openUrlExternally(root_item.itemUrl)
            }
        }

        PLTextButton {

            id: prefer_imagegroup_button

            anchors.right: link_button.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 100
            height: back_button.height
            text: "收藏该图片组"
            enabled: false

            onClicked: {
                if (Global.User.token.length === 0) {
                    var messagebox = MessageBox.showMessageBox(
                                Global.RootPanel, "收藏功能需要登录后才能使用!",
                                function () {
                                    Global.RootPanel.showLoginPanel()
                                    messagebox.visible = false
                                    messagebox.destroy()
                                })
                } else {
                    //执行收藏操作
                    var imageids = []
                    for (var i = 0; i < images_list_model.count; i++) {
                        console.log("Image id---->",
                                    images_list_model.get(i)["imageid"])
                        imageids.push(images_list_model.get(i)["imageid"])
                    }

                    Global.APIRequestEx.tryToPefer(Global.User.token, imageids)

                    root_item.cover = CoverPanel.showLoadingCover(
                                Global.RootPanel, "添加收藏中...")
                }
            }
        }

        PLTextButton {
            id: downloadall_button
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            width: 80
            height: back_button.height
            text: "下载所有"
            enabled: false

            CircleTooltip {
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: -8
                anchors.topMargin: -8
                text: "VIP"
                visible: !Global.User.isVip
            }

            Component {
                id: dir_dialog_component
                FileDialog {
                    id: dir_dialog

                    title: "Please choose a directory"
                    selectFolder: true
                    selectExisting: true
                    folder: shortcuts.pictures
                    selectMultiple: false

                    onAccepted: {
                        //var dest = fileUrl;
                        var urls = []
                        for (var i = 0; i < images_list_model.count; i++) {
                            var obj = images_list_model.get(i)
                            if (obj) {
                                var image = obj["image"]
                                urls.push(image)
                                //console.log(image, urls.length)
                            }
                        }

                        //console.log(fileUrl, Global.fixedDirName(root_item.title))
                        Global.APIRequestEx.addDownload(fileUrl,
                                                      Global.fixedDirName(
                                                          root_item.title),
                                                      urls)
                    }

                    Component.onCompleted: visible = true
                }
            }

            onClicked: {

                if (!Global.User.isVip) {
                    var messagebox = MessageBox.showMessageBox(
                                Global.RootPanel, "该功能为VIP功能，如果需要使用请升级为VIP!",
                                function () {
                                    if (messagebox) {
                                        messagebox.visible = false
                                        messagebox.destroy()

                                        Global.RootPanel.showVIPUpgradePanel()
                                    }
                                })
                } else {
                    var dir_dialog = dir_dialog_component.createObject(
                                root_item)
                }
            }
        }
        PLTextWithDefaultFamily {
            id: text_item
            height: 30
            font.pointSize: 10
            color: "#EEEEEE"
            text: "Title"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: back_button.verticalCenter
        }
    }
}
