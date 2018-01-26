#include "APIRequestEx.h"
#include "APIRequestPrivate.h"
#include <QObject>
#include "VersionDefine.h"
#include "Settings.h"

#define kStatisticsKey "90efc7e6011d11e89e73787b8ab9b5fd90f3bd24011d11e8afa5787b8ab9b5fd"


QNetworkAccessManager *APIRequestEX::g_network = 0;

void APIRequestEX::defaultHeadImagesRequest(QVariant jsFunc)
{
    return APIRequestEX::post(kAPIDefaultHeaders, "", jsFunc);
}

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

void APIRequestEX::itemsRequest(const QStringList &itemIDs, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("itemids", itemIDs);

    return post(kAPIItems, QJsonDocument::fromVariant(param).toJson(), jsFunc);
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

void APIRequestEX::regeisterRequest(const QString &user, const QString &pwd, const QString &nickname, const QString& headerimage, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("user", user);
    param.insert("nickname", nickname);
    param.insert("password", pwd);
    param.insert("headerimage", headerimage);

    return post(kAPIRegister, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::modifyUserRequest(const QString &token, QVariant jsFunc, const QString &pwd, const QString &nickname, const QString &headerimage)
{
    QVariantMap param;
    param.insert("token", token);
    if(!nickname.isEmpty()){
        param.insert("nickname", nickname);
    }

    if(!pwd.isEmpty()){
        param.insert("password", pwd);
    }

    if(!headerimage.isEmpty()){
        param.insert("headerimage", headerimage);
    }

    return post(kAPIModifyUser, QJsonDocument::fromVariant(param).toJson(), jsFunc);
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

void APIRequestEX::removePefersRequest(const QString &token, const QVariantList &imageids, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("token", token);
    param.insert("imageids", imageids);

    //qDebug() << "|||||||||||||addPeferRequest: " << QJsonDocument::fromVariant(param).toJson();

    return post(kAPIRemovePefer, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::viewStatistics(const QString &page, const QString &title)
{
    QVariantMap param;
    param.insert("key", kStatisticsKey);
    param.insert("page", page);
    param.insert("title", title);
    param.insert("appversion", Version);
    param.insert("clientid", Settings::clientID());

    return post(kAPIViewStatistics, QJsonDocument::fromVariant(param).toJson(), QVariant());
}

void APIRequestEX::eventStatistics(const QString &category, const QString &action, const QString &label)
{
    QVariantMap param;
    param.insert("key", kStatisticsKey);
    param.insert("category", category);
    param.insert("action", action);
    param.insert("label", label);
    param.insert("appversion", Version);
    param.insert("clientid", Settings::clientID());

    qDebug() << "Event statistics:" << category << action << label;


    return post(kAPIEventStatistics, QJsonDocument::fromVariant(param).toJson(), QVariant());
}

void APIRequestEX::setImagesVisibleRequest(const QString &token, const QVariantList &hideimageids, const QVariantList &showimageids, QVariant jsFunc)
{
    QVariantMap param;
    param.insert("token", token);

    QVariantList checksParam;
    Q_FOREACH(QVariant id, hideimageids){
        QVariantMap temp;
        temp.insert("imageid", id);
        temp.insert("checked", true);
        temp.insert("shown", false);
        checksParam.append(temp);
    }
    Q_FOREACH(QVariant id, showimageids){
        QVariantMap temp;
        temp.insert("imageid", id);
        temp.insert("checked", true);
        temp.insert("shown", true);
        checksParam.append(temp);
    }

    param.insert("checks", checksParam);

    //qDebug() << "--->" <<  QJsonDocument::fromVariant(param).toJson();
    return post(kAPISetImagesVisible, QJsonDocument::fromVariant(param).toJson(), jsFunc);
}

void APIRequestEX::post(const QString &apiurl, const QString &param, QVariant jsFunc)
{
    //Q_ASSERT(jsFunc.canConvert<QJSValue>());

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
