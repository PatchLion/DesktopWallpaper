import QtQuick 2.0
import DesktopWallpaper.UserManager 1.0

GridView{
    id: grid_view_item


    property int rowCount: 3
    property int columnCount: 2

    clip: true

    cellWidth: width/columnCount
    cellHeight: height/rowCount

    boundsBehavior: Flickable.StopAtBounds

    delegate: PefersImagesView{
        width: grid_view_item.cellWidth
        height: grid_view_item.cellHeight

        isNew: newOne
        currentID: itemID
        titleString: title
        source: image
        itemUrl: sourcePage
        //originReferer: referer
    }
}
