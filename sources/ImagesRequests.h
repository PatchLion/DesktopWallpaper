//图片请求类
#ifndef IMAGESREQUESTS_H
#define IMAGESREQUESTS_H

#include <QtCore>
#include "Caches.h"

class ImagesRequests : public QObject
{
    Q_OBJECT

public:
    explicit ImagesRequests(QObject *parent = nullptr);

public:
    //请求图片
    Q_INVOKABLE QByteArray request(int classify, int page);

private:
    static QString requestUrl(int classify, int page);

private:
    Caches m_cache;
};

#endif // IMAGESREQUESTS_H
