#include "ImageClassify.h"
#include <QtCore>
#include "common.h"

static const char* kRecordeFileName = "classifies_%1.json"; //分类json

ImageClassify::ImageClassify(QObject *parent)
    : QObject(parent)
{
    QFile file(todayFileName());
    if(file.open(QIODevice::ReadOnly))
    {
        setClassifies(file.readAll());
        file.close();
    }
    else
    {
        QNetworkRequest reuest(requestUrl());
        QNetworkReply* reply = m_network.get(reuest);
        connect(reply, &QNetworkReply::finished, this, &ImageClassify::onReplyFinished);
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onReplyError(QNetworkReply::NetworkError)));

        reply->setParent(&m_network);
    }
}

QString ImageClassify::classifies() const
{
    return m_classifies;
}

void ImageClassify::setClassifies(const QString &classifies)
{
    if(classifies != m_classifies)
    {
        m_classifies = classifies;
        Q_EMIT classifiesChanged();
    }
}

QString ImageClassify::todayFileName() const
{
    QDateTime dt = QDateTime::currentDateTime();
    const QString dtstring = dt.toString("yyyyMMdd");

    return QString(kRecordeFileName).arg(dtstring);
}

QString ImageClassify::requestUrl() const
{
    QString ret = kImageClassifyUrl;
    ret += QString("?showapi_appid=%1").arg(kAppID);
    ret += QString("&showapi_sign=%1").arg(kKey);

    return ret;
}

void ImageClassify::onReplyFinished()
{
    QNetworkReply* reply = dynamic_cast<QNetworkReply*>(sender());

    if(reply && QNetworkReply::NoError == reply->error())
    {
        QByteArray data = reply->readAll();
        setClassifies(data);

        QFile file(todayFileName());
        if(file.open(QIODevice::WriteOnly))
        {
            file.write(data);
            file.close();
        }
    }
}

void ImageClassify::onReplyError(QNetworkReply::NetworkError error)
{
    qWarning() << "Failed to get " << requestUrl() << "! error code: " << error;
}
