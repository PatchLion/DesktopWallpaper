#include "APIRequestEx.h"
#include "APIRequestPrivate.h"
#include <QObject>


QNetworkAccessManager *APIRequestEX::g_network = 0;

void APIRequestEX::classifiesRequest(QVariant jsFunc)
{
    return APIRequestEX::post(kAPIClassifies, "", jsFunc);
}

void APIRequestEX::pageRequest(const QString &classify, int pageindex, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("classify", classify);
    param.insert("pageindex", pageindex);

    return post(kAPIPage, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::itemRequest(const QString &itemID, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("itemid", itemID);

    return post(kAPIItem, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::searchRequest(const QString &key, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("key", key);

    return post(kAPISearch, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::loginRequest(const QString &user, const QString &pwd, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("user", user);
    param.insert("password", pwd);

    return post(kAPILogin, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::regeisterRequest(const QString &user, const QString &pwd, const QString &nickname, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("user", user);
    param.insert("nickname", nickname);
    param.insert("password", pwd);

    return post(kAPIRegister, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::checkTokenRequest(const QString &token, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("token", token);

    return post(kAPITokenCheck, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::addPeferRequest(const QString &token, const QVariantList &imageids, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("token", token);
    param.insert("imageids", imageids);

    //qDebug() << "|||||||||||||addPeferRequest: " << QJsonDocument::fromVariant(param).toJson();

    return post(kAPIAddPefer, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::getPefersRequest(const QString &token, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("token", token);

    return post(kAPIGetPefer, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::post(const QString &apiurl, const QString &param, QVariant jsFunc)
{
    Q_ASSERT(jsFunc.canConvert<QJSValue>());

    QNetworkRequest request(apiurl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QNetworkReply* reply = APIRequestEX::network()->post(request, param.toUtf8());

    APIRequestPrivate* p = new APIRequestPrivate(reply, jsFunc.value<QJSValue>(), APIRequestEX::network());
}

QNetworkAccessManager *APIRequestEX::network()
{
    if(!APIRequestEX::g_network){
        APIRequestEX::g_network = new QNetworkAccessManager;
    }

    Q_ASSERT(APIRequestEX::g_network);

    return g_network;
}
