#ifndef IMAGECLASSIFY_H
#define IMAGECLASSIFY_H

#include <QtCore>
#include <QtNetwork>

class ImageClassify : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString classifies READ classifies WRITE setClassifies NOTIFY classifiesChanged)

public:
    explicit ImageClassify(QObject *parent = nullptr);

public:
    QString classifies() const;
    void setClassifies(const QString &classifies);

private:
    QString todayFileName() const;
    QString requestUrl() const;

private Q_SLOTS:
    void onReplyFinished();
    void onReplyError(QNetworkReply::NetworkError error);

Q_SIGNALS:
    void classifiesChanged();

private:
    QString m_classifies;
    QNetworkAccessManager m_network;
};

#endif // IMAGECLASSIFY_H
