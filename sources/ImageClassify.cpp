#include "ImageClassify.h"
#include <QtNetwork>
#include "common.h"

static const char* kRecordeFileName = "classifies_%1.json"; //分类json

ImageClassify::ImageClassify(QObject *parent)
    : QObject(parent)
{

}

QByteArray ImageClassify::classifies()
{
    if(m_cache.classifiesCache().isEmpty())
    {
        qDebug() << "Read image classify from network!";
        QEventLoop loop;
        QNetworkAccessManager network;
        QNetworkRequest reuest(requestUrl());
        QNetworkReply* reply = network.get(reuest);
        Caches& cache = m_cache;
        connect(reply, &QNetworkReply::finished, [=, &loop, &reply, &cache](){

            if(reply && QNetworkReply::NoError == reply->error())
            {
                QByteArray data = reply->readAll();
                cache.setClassifiesCache(data);
            }

            loop.quit();
        });
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), &loop, SLOT(quit()));

        loop.exec();

        delete reply;
        reply = 0;
    }

    return m_cache.classifiesCache();
}

QString ImageClassify::requestUrl()
{
    QString ret = kImageClassifyUrl;
    ret += QString("?showapi_appid=%1").arg(kAppID);
    ret += QString("&showapi_sign=%1").arg(kKey);

    return ret;
}
