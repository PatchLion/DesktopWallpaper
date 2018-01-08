import QtQuick 2.0
import "./Global.js" as Global
import "../controls"
import "../controls/PLToast.js" as Toast

Rectangle{
    id: root_item
    signal startSearch(string keyword);

    width: 150
    height: 20
    color: enabled ? "white" : "#BBBBBB"
    radius: 2

    smooth: true

    PLTextWithDefaultFamily{
        id: default_text_item
        anchors.fill: parent
        anchors.rightMargin: search_button.width
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft

        font.pointSize: 9
        color: "#999999"


        smooth: true

        text: " 请输入关键词"

        visible: textinput_keyword.text.length === 0
    }


    TextInput{

        id: textinput_keyword
        anchors.fill: parent
        anchors.rightMargin: search_button.width
        color: "#666666"
        selectByMouse: true

        font.pointSize: 9

        smooth: true


        clip: true

        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignLeft

        Keys.onPressed: {
              if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                  search_button.buttonClicked();
              }
          }

    }



    PLTextButton{
        id: search_button
        width: 40
        height: root_item.height
        text: qsTr("搜索")
        anchors.right: parent.right

        smooth: true
        textPixelSize: 10

        radius: 0
        anchors.verticalCenter: parent.verticalCenter

        onClicked: {
            var keyword = textinput_keyword.text
            if ( keyword.length>0){
                root_item.startSearch(keyword);
                textinput_keyword.text = "";
            }
            else{
                Toast.showToast(Global.RootView, "关键词不能为空")
            }
        }
    }



}
