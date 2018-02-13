import QtQuick 2.9
import DesktopWallpaper.ImageCache 1.0

Image {
    id: root_item

    property alias originUrl: cache.originUrl
    //property alias originReferer: cache.originReferer
    source: cache.safeUrl

    ImageCache{ id: cache }
}
