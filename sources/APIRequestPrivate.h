#ifndef APIREQUESTPRIVATE_H
#define APIREQUESTPRIVATE_H

#include <QObject>
#include <QNetworkReply>
#include <QJSValue>

class APIRequestPrivate : public QObject
{
    Q_OBJECT
public:
    explicit APIRequestPrivate(QNetworkReply* reply, QJSValue jsObj, QObject *parent = nullptr);

signals:
    void replyFinished(bool suc, const QString& msg, const QByteArray& data);

private slots:
    void onFinished();

private:
    QJSValue* m_jsFunctionObject;
};

#endif // APIREQUESTPRIVATE_H
