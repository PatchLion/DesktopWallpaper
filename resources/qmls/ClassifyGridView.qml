Kimport QtQuick 2.0

GridView{
    id: grid_view_item


    signal itemClicked(string currentID);


    property int rowCount: 3
    property int columnCount: 2

    clip: true


    cellWidth: width/columnCount
    cellHeight: height/rowCount

    boundsBehavior: Flickable.StopAtBounds

    delegate: ImagesView{
        width: grid_view_item.cellWidth
        height: grid_view_item.cellHeight

        currentID: itemID
        titleString: title
        source: image

        onItemClicked: {
            grid_view_item.itemClicked(currentID);
        }
    }
}
