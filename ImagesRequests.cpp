#include "ImagesRequests.h"
#include "common.h"
#include <QtNetwork>

ImagesRequests::ImagesRequests(QObject *parent)
    : QObject(parent)
{

}

QByteArray ImagesRequests::request(int classify, int page)
{
    const QByteArray data = m_cache.pageCache(classify, page);
    if(data.isEmpty())
    {
        qDebug() << "Read image data with (classify:" << classify << ", page:" << page << ") from network!";

        QEventLoop loop;
        QNetworkRequest reuest(requestUrl(classify, page));
        QNetworkAccessManager network;
        QNetworkReply* reply = network.get(reuest);
        Caches& cache = m_cache;
        connect(reply, &QNetworkReply::finished, [=, &loop, &reply, &cache, &classify, &page](){

            if(reply && QNetworkReply::NoError == reply->error())
            {
                QByteArray data = reply->readAll();
                cache.setPageCache(classify, page, data);
            }

            loop.quit();
        });
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), &loop, SLOT(quit()));

        loop.exec();

        delete reply;
        reply = 0;
    }


    return data;
}

QString ImagesRequests::requestUrl(int classify, int page)
{
    //http://route.showapi.com/852-2?showapi_appid=myappid&type=&page=&showapi_sign=mysecret
    QString ret = kImagesUrl;
    ret += QString("?showapi_appid=%1").arg(kAppID);
    ret += QString("&showapi_sign=%1").arg(kKey);
    ret += QString("&type=%1").arg(classify);
    ret += QString("&page=%1").arg(page);

    return ret;
}
