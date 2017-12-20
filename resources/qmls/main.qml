import QtQuick 2.3
import QtQuick.Window 2.2
import DesktopWallpaper.APIRequest 1.0
import "./Global.js" as Global
import "./DataCache.js" as DataCache

Window {
    visible: true
    visibility: Window.Windowed
    width: 800
    height: 600
    title: qsTr("Beauty Finder")

    color: "black"

    APIRequest{
        id: api_reqeuest
    }

    Component.onCompleted: {
        Global.safeUrl = api_reqeuest.refererUrl();
    }


    WallpaperList{
        anchors.fill: parent
        anchors.margins: 5

        Component.onCompleted: {
            Global.mainForm = this;
        }
    }

}
