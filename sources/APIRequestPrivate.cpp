#include "APIRequestPrivate.h"

APIRequestPrivate::APIRequestPrivate(QNetworkReply* reply, QObject *parent)
    : QObject(parent)
{
    if(reply){
        connect(reply, &QNetworkReply::finished, this, &APIRequestPrivate::onFinished);
        reply->setParent(this);
    }
}

void APIRequestPrivate::onFinished()
{
    QNetworkReply *reply = dynamic_cast<QNetworkReply*>(sender());

       if(reply){
           QNetworkReply::NetworkError error = reply->error();

           if (error == QNetworkReply::NoError){
               const QByteArray data = reply->readAll();
               Q_EMIT replyFinished(true, "", data);
           }
           else{
               Q_EMIT replyFinished(false, QString::fromLocal8Bit("网络请求异常：%1").arg(error), "");
           }
    }
}
