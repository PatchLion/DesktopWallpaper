import QtQuick 2.0
import QtQuick.Dialogs 1.2
import DesktopWallpaper.Downloader 1.0
import "./Toast.js" as Toast
import "./Global.js" as Global

Item {
    id: root_item

    property alias title: text_item.text
    property alias model: images_list_model

    signal backButtonClicked();

    Downloader{
        id: downloader

        onDownloadError: {
            Toast.showToast(Global.mainForm, errorInfo);
        }
        onDownloadFinished: {
            Toast.showToast(Global.mainForm, url + " download finished!");
        }
    }

    Rectangle{
        id: image_area

        anchors.fill: parent
        anchors.topMargin: 40
        anchors.bottomMargin: 40
        anchors.leftMargin: 5
        anchors.rightMargin: 5

        color: "#EEEEEE"

        ListView{
            id: listview_item
            anchors.fill: parent

            spacing: 20

            clip: true

            orientation: ListView.Horizontal

            model: ListModel{
                id: images_list_model
            }

            delegate: Item{

                height: listview_item.height
                width: image_item.width

                Image{

                    id: image_item
                    anchors.centerIn: parent

                    height: parent.height * 4 / 5

                    fillMode: Image.PreserveAspectFit

                    sourceSize.height: height

                    source: image

                    MouseArea{
                        id: image_mouse_area
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onPositionChanged: {
                            download_button.visible = true
                        }
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

                        visible:(image_mouse_area.containsMouse || isContainMouse)

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

    Button{
        id: back_button
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        width: 100
        height: 30
        buttonText: "返回"
        onButtonClicked: {
            root_item.backButtonClicked();
        }
    }


    Button{
        id: downloadall_button
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        width: 100
        height: 30
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

                    for(var i = 0; i<root_item.model.count; i++)
                    {
                        var obj = root_item.model.get(i);
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
        height: 40
        font.pointSize: 12
        font.family: "微软雅黑"
        color: "#222222"
        text: "Title"
        verticalAlignment:Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: back_button.verticalCenter
    }

}
