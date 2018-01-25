import QtQuick 2.0
import DesktopWallpaper.APIRequestEx 1.0
import "../../controls/PLToast.js" as Toast
import "../../controls/PLCoverPanel.js" as Cover
import "../../controls"
import "../Global.js" as Global
import ".."

Rectangle{
    id: root_item

    APIRequestEx{ id: api_request } //api请求对象

    color: Qt.rgba(0.7, 0.7, 0.7, 0.3)
}
