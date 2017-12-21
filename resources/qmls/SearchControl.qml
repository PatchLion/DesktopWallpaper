import QtQuick 2.0

Row{
    id: root_item
    signal startSearch(string keyword);

    width: 200
    height: 20
    spacing: 10

    Rectangle{

        color: "white"

        radius: 2

        anchors.left: parent.left
        anchors.right: search_button.left
        anchors.rightMargin: 5
        height: parent.height

        smooth: true

        Text{
            id: default_text_item
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            font.pointSize: 9
            font.family: "微软雅黑"
            color: "#999999"


            smooth: true

            text: " 请输入关键词"


            visible: textinput_keyword.text.length === 0

        }


        TextInput{

            id: textinput_keyword
            anchors.fill: parent
            color: "#666666"
            selectByMouse: true

            font.pointSize: 9
            font.family: "微软雅黑"



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
    }


    DefaultButton{
        id: search_button
        width: 60
        height: 20
        buttonText: qsTr("搜索")
        anchors.right: parent.right

        smooth: true
        buttonTextPointSize: 8

        radius: close_button.radius
        anchors.verticalCenter: parent.verticalCenter

        onButtonClicked: {
            var keyword = textinput_keyword.text
            if ( keyword.length>0){
                root_item.startSearch(keyword);
                textinput_keyword.text = "";
            }
        }
    }

}
