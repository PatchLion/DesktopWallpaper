//.pragma library

//带Loadding遮罩窗体显示
var com = null
function showLoadingCover(parent, text) {
    if (null === com) {
        com = Qt.createComponent("PLCoverPanel.qml")
    }

    if (com.status === Component.Ready) {
        var cover = com.createObject(parent, {
                                         "anchors.fill": parent,
                                         "width": parent.width,
                                         "height": parent.height,
                                         "text": text,
                                         "type": 0
                                     });
        return cover;
    } else {
        console.log("创建CoverPanel失败")
    }

    return null;
}

//带进度条遮罩窗体显示
function showProgressBarCover(parent){
    if (null === com) {
        com = Qt.createComponent("PLCoverPanel.qml")
    }

    if (com.status === Component.Ready) {
        var cover = com.createObject(parent, {
                                         "anchors.fill": parent,
                                         "width": parent.width,
                                         "height": parent.height,
                                         "type": 1
                                     });
        return cover;
    } else {
        console.log("创建CoverPanel失败")
    }

    return null;
}

//设置进度条遮罩提示文字
function setProgressBarCoverTooltip(cover, tooltip){
    cover.text = tooltip;
}

//设置进度条遮罩进度
function setProgressBarCoverProgress(cover, progress){
    cover.progress = progress;
}
