#ifndef APIREQUESTPRIVATE_H
#define APIREQUESTPRIVATE_H

#include <QObject>
#include <QNetworkReply>

class APIRequestPrivate : public QObject
{
    Q_OBJECT
public:
    explicit APIRequestPrivate(QNetworkReply* reply, QObject *parent = nullptr);

signals:
    void replyFinished(bool suc, const QString& msg, const QByteArrayData& data);

private slots:
    void onFinished();
};

#endif // APIREQUESTPRIVATE_H
