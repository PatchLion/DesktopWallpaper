import QtQuick 2.3

PLCheckButtonBase
{
    id: root_item

    property string defaultIcon: ""
    property string pressedIcon: ""
    property string hoverIcon: ""
    property string disableIcon: ""

    defaultBorderColor: "transparent"
    pressedBorderColor: "transparent"
    hoverBorderColor: "transparent"
    disabledBorderColor: "transparent"

    defaultColor: "transparent"
    pressedColor: "transparent"
    hoverColor: "transparent"
    disabledColor: "transparent"

    Image
    {
        smooth: true
        antialiasing: true
        //z: 0
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: !root_item.enabled ? disableIcon :
                           (root_item.mouseArea.pressed ? pressedIcon :
                                                 (root_item.mouseArea.containsMouse ? hoverIcon : defaultIcon))
    }
}
