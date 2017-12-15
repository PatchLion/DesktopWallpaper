import QtQuick 2.0
import QtQuick.Dialogs 1.2
import "./Toast.js" as Toast
import "./Global.js" as Global

Item {
    id: root_item

    signal itemClicked(string currentID);

    signal backButtonClicked();
    property alias model: grid_view_model

    Rectangle{
        id: image_area

        anchors.fill: parent
        anchors.topMargin: 40
        anchors.bottomMargin: 40
        anchors.leftMargin: 5
        anchors.rightMargin: 5

        color: "#EEEEEE"

        ClassifyGridView{
            anchors.fill: parent
            columnCount: 3

            flow: GridView.FlowTopToBottom

            model: ListModel{
                id: grid_view_model
            }

            onItemClicked: {
                root_item.itemClicked(currentID);
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


}
