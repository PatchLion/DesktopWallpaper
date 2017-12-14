//图片请求类
#ifndef IMAGESREQUESTS_H
#define IMAGESREQUESTS_H

#include <QObject>

class ImagesRequests : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString imageClassifies READ getClassifies)

public:
    explicit ImagesRequests(QObject *parent = nullptr);

public:
    //获取图片分类 json格式
    QByteArray getClassifies() const;

    //获取图片信息
    //classify:分类 index:最后图片索引 count:获取数量
    Q_INVOKABLE QByteArray images(int classifyid, int index, int count=20);
};

#endif // IMAGESREQUESTS_H
