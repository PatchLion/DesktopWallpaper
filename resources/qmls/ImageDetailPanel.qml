import QtQuick 2.9
import QtQuick.Dialogs 1.2
import DesktopWallpaper.APIRequest 1.0
import "./Toast.js" as Toast
import "./Global.js" as Global

Item {
    id: root_item

    property bool isUseReferer: false
    property alias title: text_item.text
    property int itemID: -1

    property string itemUrl: ""
    //property alias model: images_list_model

    signal backButtonClicked();



    APIRequest{
        id: downloader

        onItemsDetailResponse: {
            var result = Global.resolveItemsDetailData(data, root_item.isUseReferer);

            if(result[0])
            {
                images_list_model.clear();
                images_list_model.append(result[1]);
            }
        }

        onDownloadError: {
            Toast.showToast(Global.mainForm, msg);
        }

        onDownloadFinished: {
            Toast.showToast(Global.mainForm, url+" downloaded!");
        }

        onApiRequestError: {
            console.warn("Catch error when reuqest api:", apiName, "code:", error);
        }
    }

    onItemIDChanged: {
        downloader.requestItemsDetailData(itemID);
    }

    Rectangle{
        id: image_area

        anchors.fill: parent


        color: Qt.rgba(0.7, 0.7, 0.7, 0.3)

        ListView{
            id: listview_item
            anchors.fill: parent

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
                    anchors.bottomMargin: 10

                    height: image_item.height

                    visible: !image_item.visible

                    width: 300

                    color: Qt.rgba(0.3, 0.3, 0.3, 0.5)

                    Text{
                        text: qsTr("Loadding......")

                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter

                        color: "white"

                        font.pointSize: 11
                        font.family: "微软雅黑"

                    }


                }

                Image{

                    id: image_item
                    //anchors.centerIn: parent
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10

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

                    Button{

                        id: download_button

                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        width: 50
                        height: 30
                        buttonText: "下载"

                        visible: (image_mouse_area.containsMouse || isContainMouse)

                        Component{
                            id: file_dialog_component
                            FileDialog
                            {
                                id: file_dialog
                                title: "Please choose a file"
                                nameFilters: [ "PNG(*.png)", "JPG(*.jpg)" ]
                                selectFolder: false
                                selectMultiple: false
                                selectExisting: false
                                folder: shortcuts.pictures


                                onAccepted: {
                                    var source = image_item.source;
                                    var dest = fileUrl;
                                    Toast.showToast(Global.mainForm, "开始下载: " + source + "\n到: "+dest);
                                    downloader.startDownload(source, dest);
                                }

                                Component.onCompleted: visible=true
                            }
                        }
                        onButtonClicked: {
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

        height: 30

        Button{
            id: back_button
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: 20
            buttonText: "返回"
            onButtonClicked: {
                root_item.backButtonClicked();
            }
        }

        Button{

            id: link_button

            anchors.right: downloadall_button.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 100
            height: 20
            buttonText: "跳转到源网页"

            onButtonClicked: {
                console.log("Jump to", root_item.itemUrl)
                Qt.openUrlExternally(root_item.itemUrl)
            }
        }


        Button{
            id: downloadall_button
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            width: 80
            height: 20
            buttonText: "下载所有"

            Component{
                id: dir_dialog_component
                FileDialog
                {
                    id: dir_dialog

                    title: "Please choose a directory"
                    selectFolder: true
                    selectExisting: true
                    folder: shortcuts.pictures

                    onAccepted: {
                        var dest = fileUrl;
                        //Toast.showToast(Global.mainForm, "开始下载所有图片到: "+dest);

                        console.log(images_list_model.count)
                        for(var i = 0; i<images_list_model.count; i++)
                        {
                            var obj = images_list_model.get(i);
                            if(obj)
                            {
                                var image = obj["image"];
                                var destpath = fileUrl+ "/" + Global.fixedDirName(root_item.title) +"/"+i+".png";
                                console.log(image, destpath);
                                downloader.startDownload(image, destpath);
                            }

                        }
                    }

                    Component.onCompleted: visible=true
                }
            }

            onButtonClicked: {
                var dir_dialog = dir_dialog_component.createObject(root_item);
            }
        }
        Text{
            id: text_item
            height: 30
            font.pointSize: 12
            font.family: "微软雅黑"
            color: "#EEEEEE"
            text: "Title"
            verticalAlignment:Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: back_button.verticalCenter
        }

    }
}

