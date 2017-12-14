#include "ImagesRequests.h"
#include "common.h"

ImagesRequests::ImagesRequests(QObject *parent)
    : QObject(parent)
{

}

QByteArray ImagesRequests::getClassifies() const
{
    QJsonDocument docment;
    QJsonArray classifies;
    QVariantMap varMap;
    varMap["id"] = "0";
    varMap["name"] = "Classic";
    classifies.append(QJsonObject::fromVariantMap(varMap));
    varMap["id"] = "1";
    varMap["name"] = "Beauty Girls";
    classifies.append(QJsonObject::fromVariantMap(varMap));
    varMap["id"] = "2";
    varMap["name"] = "Games";
    classifies.append(QJsonObject::fromVariantMap(varMap));
    varMap["id"] = "3";
    varMap["name"] = "Photos";
    classifies.append(QJsonObject::fromVariantMap(varMap));
    varMap["id"] = "4";
    varMap["name"] = "Catons";
    classifies.append(QJsonObject::fromVariantMap(varMap));

    docment.setArray(classifies);
    return docment.toJson();
}

QByteArray ImagesRequests::images(int classifyid, int index, int count)
{
    return "{}";
}

void ImagesRequests::request(int type, int page)
{
    QNetworkRequest reuest(requestUrl(type, page));
    QNetworkReply* reply = m_network.get(reuest);
    connect(reply, &QNetworkReply::finished, this, &ImagesRequests::onReplyFinished);
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onReplyError(QNetworkReply::NetworkError)));

    reply->setParent(&m_network);
}

QString ImagesRequests::requestUrl(int type, int page) const
{
    //http://route.showapi.com/852-2?showapi_appid=myappid&type=&page=&showapi_sign=mysecret
    QString ret = kImagesUrl;
    ret += QString("?showapi_appid=%1").arg(kAppID);
    ret += QString("&showapi_sign=%1").arg(kKey);
    ret += QString("&type=%1").arg(type);
    ret += QString("&page=%1").arg(page);

    return ret;
}

void ImagesRequests::onReplyFinished()
{
    QNetworkReply* reply = dynamic_cast<QNetworkReply*>(sender());

    if(reply && QNetworkReply::NoError == reply->error())
    {
        QByteArray data = reply->readAll();

        Q_EMIT imagesResponse(data);
    }
}

void ImagesRequests::onReplyError(QNetworkReply::NetworkError error)
{
    Q_EMIT imagesRequestError(error);
}
