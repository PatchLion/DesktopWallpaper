#include "APIRequestEx.h"
#include "APIRequestPrivate.h"
#include <QObject>


QNetworkAccessManager *APIRequestEX::g_network = 0;
void APIRequestEX::classifiesRequest(Functor functor)
{
    return APIRequestEX::post(kAPIClassifies, "", functor);
}

void APIRequestEX::pageRequest(const QString &classify, int pageindex, Functor functor)
{
    QVariantMap param;
    param.insert("classify", classify);
    param.insert("pageindex", pageindex);

    return post(kAPIPage, QJsonDocument::fromVariant(param).toJson(), functor);
}

void APIRequestEX::itemRequest(const QString &itemID, Functor functor)
{
    QVariantMap param;
    param.insert("itemid", itemID);

    return post(kAPIItem, QJsonDocument::fromVariant(param).toJson(), functor);
}

void APIRequestEX::searchRequest(const QString &key, Functor functor)
{
    QVariantMap param;
    param.insert("key", key);

    return post(kAPISearch, QJsonDocument::fromVariant(param).toJson(), functor);
}

void APIRequestEX::loginRequest(const QString &user, const QString &pwd, Functor functor)
{
    QVariantMap param;
    param.insert("user", user);
    param.insert("password", pwd);

    return post(kAPILogin, QJsonDocument::fromVariant(param).toJson(), functor);
}

void APIRequestEX::regeisterRequest(const QString &user, const QString &pwd, const QString &nickname, Functor functor)
{
    QVariantMap param;
    param.insert("user", user);
    param.insert("nickname", nickname);
    param.insert("password", pwd);

    return post(kAPIRegister, QJsonDocument::fromVariant(param).toJson(), functor);
}

void APIRequestEX::checkTokenRequest(const QString &token, Functor functor)
{
    QVariantMap param;
    param.insert("token", token);

    return post(kAPITokenCheck, QJsonDocument::fromVariant(param).toJson(), functor);
}

void APIRequestEX::addPeferRequest(const QString &token, const QList<int> &imageids, Functor functor)
{
    QVariantMap param;
    param.insert("token", token);
    //param.insert("imageids", imageids);

    return post(kAPIAddPefer, QJsonDocument::fromVariant(param).toJson(), functor);
}

void APIRequestEX::getPefersRequest(const QString &token, Functor functor)
{
    QVariantMap param;
    param.insert("token", token);

    return post(kAPIGetPefer, QJsonDocument::fromVariant(param).toJson(), functor);
}

void APIRequestEX::post(const QString &apiurl, const QString &param, Functor functor)
{
    QNetworkRequest request(apiurl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QNetworkReply* reply = APIRequestEX::network()->post(request, param.toUtf8());

    APIRequestPrivate* p = new APIRequestPrivate(reply, APIRequestEX::network());

    connect(p, &APIRequestPrivate::replyFinished, functor);

    return reply;
}

QNetworkAccessManager *APIRequestEX::network()
{
    if(!APIRequestEX::g_network){
        APIRequestEX::g_network = new QNetworkAccessManager;
    }

    Q_ASSERT(APIRequestEX::g_network);

    return g_network;
}
