#include "ImagesRequests.h"
#include <QtCore>

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
