import QtQuick 2.0
import QtQuick.Window 2.2
import "./Global.js" as Global

Item{
    id: root_item
    property var window



    width: 260
    height: 30
    DefaultButton{
        id: close_button
        width: 18
        height: 18
        buttonText: "X"
        anchors.right: parent.right
        anchors.rightMargin: 10

        smooth: true

        anchors.verticalCenter: parent.verticalCenter

        radius: width/2

        onButtonClicked: {
            Qt.quit();
        }
    }
    DefaultButton{
        id: max_normal_button
        width: close_button.width
        height: close_button.height
        buttonText: (root_item.window.visibility === Window.Maximized) ? "=" : "口"
        anchors.right: close_button.left
        anchors.rightMargin: 5

        smooth: true

        anchors.verticalCenter: close_button.verticalCenter

        radius: close_button.radius

        onButtonClicked: {
            if(root_item.window.visibility === Window.Maximized)
            {
                root_item.window.visibility = Window.Windowed
            }
            else
            {
                root_item.window.visibility = Window.Maximized
            }
        }
    }
    DefaultButton{
        id: min_button
        width: max_normal_button.width
        height: max_normal_button.height
        buttonText: "-"
        anchors.right: max_normal_button.left
        anchors.rightMargin: 5

        smooth: true

        anchors.verticalCenter: close_button.verticalCenter

        radius: close_button.radius

        onButtonClicked: {
            root_item.window.visibility = Window.Minimized
        }
    }

    SearchControl{
        id: search_button

        width: 160
        height: close_button.height
        anchors.right: min_button.left
        anchors.rightMargin: 10
        anchors.verticalCenter: close_button.verticalCenter


        smooth: true

        onStartSearch: {
            if (keyword.length>0){
                //console.log("Search keyword =", keyword)
                Global.RootPanel.showSearchPanel(keyword);
            }
        }
    }
}
