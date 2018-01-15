import QtQuick 2.0
import "../controls"

Rectangle {
    width: 160
    height: 30

    color: Qt.rgba(1, 1, 1, 0.8)

    property alias tipString: title_item.text
    property alias text: text_item.text
    property alias echoMode: text_item.echoMode

    property alias inputItem: text_item

    radius: 5

    TextInput{
        id: text_item
        anchors.margins: 3
        anchors.fill: parent
        font.family: title_item.font.family
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft




        focus: true

        PLTextWithDefaultFamily{
            id: title_item
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            color: "gray"
            font.pixelSize: 14

            visible: text_item.text.length === 0
        }

    }
}
