import QtQuick 2.0
import DesktopWallpaper.APIRequestEx 1.0
import DesktopWallpaper.DownloadBox 1.0
import "./Global.js" as Global
import "../controls"

Rectangle {
    id: root_item

    //property alias model: downloadlist_model
    signal backButtonClicked();

    DownloadBox{
        id: downloader
        onDownloadInfosChanged:{
            //console.log("onDownloadInfosChanged:", downloads)
            var jsondata = JSON.parse(downloads);

            downloadlist_model.clear();
            downloadlist_model.append(jsondata);
        }
    }

    APIRequestEx{id:api_request}

    color: Qt.rgba(0.7, 0.7, 0.7, 0.3)

    Component.onCompleted: {

        api_request.viewStatistics("/downloadboxpage", "downloadbox");
        var data = downloader.buildDownloadInfo();

        var jsonData = JSON.parse(data)

        downloadlist_model.clear();
        downloadlist_model.append(jsonData);
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
            height: 24
            text: "返回"
            onClicked: {

                Global.RootPanel.back();

                root_item.backButtonClicked();
            }


        }
    }

    Item{
        anchors.left: top_area.left
        anchors.right: top_area.right
        anchors.top: top_area.bottom
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        GridView{
            id: downloadlist_item

            anchors.fill: parent

            cellWidth: width / 2
            cellHeight: 70
            clip: true

            model: ListModel{
                id: downloadlist_model
            }

            delegate: Item{
                width: downloadlist_item.cellWidth
                height: downloadlist_item.cellHeight


                property string groupName: name
                property int groupDownloading: downloading
                property int groupDownloaded: downloaded
                property int groupDownloadFailed: downloadFailed

                DownloadBoxItem{
                    anchors.centerIn: parent
                    width: parent.width-1
                    height: parent.height-10

                    title: groupName

                    downloaded: groupDownloaded
                    failed: groupDownloadFailed

                    downloading:groupDownloading
                }
            }
        }
    }
}
