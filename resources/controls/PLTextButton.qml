import QtQuick 2.0

PLButtonBase{
    property alias text: text_item.text

    property string textDefaultColor: "#696969"
    property string textPressedColor: "white"
    property string textHoverColor: "#4F4F4F"
    property string textDisabledColor: "#363636"

    property alias textFontFamliy: text_item.font.family
    property alias textPixelSize: text_item.font.pixelSize


    PLTextWithDefaultFamily
    {
        id: text_item
        anchors.centerIn: parent
        //font.family: Configs.DefaultFontFamily
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        color: !enabled ? textDisabledColor :
                          (mouseArea.pressed ? textPressedColor :
                                                (mouseArea.containsMouse ? textHoverColor : textDefaultColor))

        clip: true
        font.pixelSize: 12
    }
}
