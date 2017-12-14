//图片请求类
#ifndef IMAGESREQUESTS_H
#define IMAGESREQUESTS_H

#include <QtCore>
#include <QtNetwork>

class ImagesRequests : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString imageClassifies READ getClassifies)

public:
    explicit ImagesRequests(QObject *parent = nullptr);

public:
    //获取图片分类 json格式
    QByteArray getClassifies() const;

    //获取图片信息
    //classify:分类 index:最后图片索引 count:获取数量
    Q_INVOKABLE QByteArray images(int classifyid, int index, int count=20);

    //请求图片
    Q_INVOKABLE void request(int type, int page);

private:
    QString requestUrl(int type, int page) const;

Q_SIGNALS:
    void imagesResponse(const QString& data);
    void imagesRequestError(QNetworkReply::NetworkError error);

private Q_SLOTS:
    void onReplyFinished();
    void onReplyError(QNetworkReply::NetworkError error);

private:
    int m_pageindex;
    int m_type;

    QNetworkAccessManager m_network;
};

#endif // IMAGESREQUESTS_H
