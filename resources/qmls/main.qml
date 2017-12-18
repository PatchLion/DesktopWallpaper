import QtQuick 2.3
import QtQuick.Window 2.2
import "./Global.js" as Global
import "./DataCache.js" as DataCache

Window {
    visible: true
    visibility: Window.Windowed
    width: 800
    height: 600
    title: qsTr("Desktop Wallpaper")


    WallpaperList{
        anchors.fill: parent;

        Component.onCompleted: {
            Global.mainForm = this;
        }
    }
}
