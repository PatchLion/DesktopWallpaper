#include "APIRequestPrivate.h"

APIRequestPrivate::APIRequestPrivate(QNetworkReply* reply, QJSValue jsObj, QObject *parent)
    : QObject(parent)
{
    Q_ASSERT(jsObj.isCallable());
    Q_ASSERT(reply);

    m_jsFunctionObject = new QJSValue(jsObj);
    connect(reply, &QNetworkReply::finished, this, &APIRequestPrivate::onFinished, Qt::DirectConnection);
    reply->setParent(this);

}

void APIRequestPrivate::onFinished()
{
    QNetworkReply *reply = dynamic_cast<QNetworkReply*>(sender());

   QNetworkReply::NetworkError error = reply->error();
   QList<QJSValue> listValue;


   const QByteArray data = reply->readAll();
   if (error == QNetworkReply::NoError)
   {
       //qDebug() << "onFinished: " << true << "" << data;

       listValue << QJSValue(true);
       listValue << QJSValue("");
       listValue << QJSValue(QString::fromUtf8(data));
   }
   else
   {

       //qDebug() << "onFinished: " << false << QString("Network error: %1").arg(error) << "";

       listValue << QJSValue(false);
       listValue << QJSValue(QString("Network error: %1").arg(error));
       listValue << QJSValue("");
   }

   m_jsFunctionObject->call(listValue);
}
