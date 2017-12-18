#ifndef APIREQUEST_H
#define APIREQUEST_H

#include <QtCore>
#include <QtNetwork>

class APIRequest : public QObject
{
    Q_OBJECT
private:
    enum RequestType
    {
        RequestType_Classifies,
        RequestType_Items,
        RequestType_ItemDetail,
        RequestType_Download,
        RequestType_ItemsByClassifyID,
    };


    typedef QMap<QString, QString> MapUrlToLocal;

public:
    explicit APIRequest(QObject *parent = nullptr);

public:
    //获取分类数据
    Q_INVOKABLE void requestClassifiesData();

    //获取分组数据
    Q_INVOKABLE void requestItemsData();

    //获取分类下的所有分组
    Q_INVOKABLE void requestItemsByClassifyID(int classifyID);

    //获取单个图片分组数据
    Q_INVOKABLE void requestItemsDetailData(int itemID);

    //发起下载请求
    Q_INVOKABLE void startDownload(const QString& url, const QString& destDir);

private:
    //发起api请求
    void doRequest(RequestType apitype, const QVariantList& args = QVariantList());

Q_SIGNALS:
    //分类请求返回
    void classifiesResponse(const QByteArray& data);

    //分类下图片分组返回
    void itemsByClassifyIDResponse(int itemID, const QByteArray& data);

    //图片分组请求返回
    void itemsResponse(const QByteArray& data);

    //图片组返回
    void itemsDetailResponse(int itemID, const QByteArray& data);

    //API请求错误
    void apiRequestError(const QString& apiName, QNetworkReply::NetworkError error);

    //下载完成
    void downloadFinished(const QString& url);
    void downloadError(const QString& url, const QString& msg);

private Q_SLOTS:
    void onReplyFinished();

private:
    QNetworkAccessManager m_network; //网络对象
    static MapUrlToLocal g_downloadInfo;
};

#endif // APIREQUEST_H
