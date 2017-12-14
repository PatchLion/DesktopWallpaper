import QtQuick 2.0

Rectangle{
    property int classifyID: -1
    property string classifyName: ""

    color: "lightgray"

    signal moreImageByClassifyID(int id); //更多
    signal singelImageClicked(string url); //点击单张图片

    Text{
        id: text_item
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 10
        height: 40
        font.pointSize: 10
        font.family: "微软雅黑"
        color: "#666666"
        text: classifyName
        verticalAlignment:Text.AlignVCenter
    }

    Rectangle{
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.verticalCenter: text_item.verticalCenter
        color: "blue"
        width: 60
        height: 20

    }

    GridView{
        id: grid_view_item

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: text_item.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        property int rowCount: 3
        property int columnCount: 2

        model: rowCount * columnCount

        clip: true

        cellWidth: width/columnCount
        cellHeight: height/rowCount

        boundsBehavior: Flickable.StopAtBounds

        delegate:
            Item{
                width: grid_view_item.cellWidth
                height: grid_view_item.cellHeight
                Rectangle{
                    width: parent.width * 9/10
                    height: parent.height * 9/10
                    color: "red"
                    anchors.centerIn: parent
                }
            }
    }
}
