#ifndef APIREQUEST_H
#define APIREQUEST_H

#include <QtCore>
#include <QtNetwork>

class APIRequest : public QObject
{
    Q_OBJECT

    //Q_PROPERTY(QString refererUrl READ refererUrl)

private:
    //请求类型
    enum RequestType
    {
        RequestType_Classifies,
        //RequestType_Items,
        RequestType_ItemDetail,
        RequestType_Download,
        RequestType_ItemsByClassify,
        RequestType_Search,
        RequestTpye_Login,
        RequestTpye_Regeister,
        RequestTpye_CheckToken,
        RequestTpye_AddPefer,
    };

    //下载状态
    enum DownloadState
    {
        Downloading,
        DownloadFailed,
        Downloaded,
    };

    //下载状态映射
    typedef QMap<QString, DownloadState> MapDownloadState;

    struct stImageGroupDownloadInfo
    {
        QString savePath;
        MapDownloadState downloads;
    };

    //typedef QMap<QString, QString> MapUrlToLocal;

    typedef QMap<QString, stImageGroupDownloadInfo> MapDownloadPictureGroup; //QStringList 0->保存根目录

public:
    explicit APIRequest(QObject *parent = nullptr);

public:
    //获取分类数据
    Q_INVOKABLE static void requestClassifiesData();

    //获取分组数据
    //Q_INVOKABLE void requestItemsData();

    //获取分类下的所有分组
    Q_INVOKABLE void requestItemsByClassify(const QString& classify, int pageindex);

    //获取单个图片分组数据
    Q_INVOKABLE void requestItemsDetailData(const QString& itemID);

    //搜索关键词
    Q_INVOKABLE void searchKeyWord(const QString& key);

    //发起下载请求
    //Q_INVOKABLE void startDownload(const QString& url, const QString& destDir);

    //发起图片组下载请求
    Q_INVOKABLE QString addDownload(const QString& savePath, const QString& name, const QStringList& urls);

    //反防盗链地址
    //Q_INVOKABLE static QString refererUrl();

    //构建下载信息
    Q_INVOKABLE QByteArray buildDownloadInfo();

    //发起登录请求
    Q_INVOKABLE void tryToLogin(const QString& user, const QString& pwd);

    //发起注册请求
    Q_INVOKABLE void tryToRegeister(const QString& user, const QString& pwd, const QString& nickname);

    //发起token校验请求
    Q_INVOKABLE void tryToCheckToken(const QString& token);

    //尝试收藏图片
    Q_INVOKABLE void tryToPefer(const QString& token, const QList<int>& imageids);

private:
    //发起api请求
    void doRequest(RequestType apitype, const QVariantList& args = QVariantList(), bool post=false);

    //统计下载中的请求
    int getDownloadingCount();


Q_SIGNALS:
    //分类请求返回
    void classifiesResponse(const QByteArray& data);

    //分类下图片分组返回
    void itemsByClassifyResponse(const QString& classify, int pageindex, const QByteArray& data);

    //图片分组请求返回
    void itemsResponse(const QByteArray& data);

    //图片组返回
    void itemsDetailResponse(const QString& itemID, const QByteArray& data);

    //API请求错误
    void apiRequestError(const QString& apiName, QNetworkReply::NetworkError error);

    //搜索完成
    void searchResponse(const QByteArray& data);

    //登录完成
    void loginFinished(const QByteArray& data);

    //token校验完成
    void tokenCheckFinished(const QByteArray& data);

    //注册完成
    void registerFinished(const QByteArray& data);

    //添加收藏完成
    void addPeferFinished(const QByteArray& data);

    //下载完成
    //void downloadFinished(const QString& url);
    //void downloadError(const QString& url, const QString& msg);

    //图片组下载信息
    void imageGroupDownloadProgress(const QString& key, int total, int finished, int error);

    //下载中总数改变
    void downloadingCountChanged(int count);

    //下载信息变化
    void downloadInfosChanged(const QByteArray& downloads);

private Q_SLOTS:
    void onReplyFinished();

private:
    QNetworkAccessManager m_network; //网络对象
    //static MapUrlToLocal g_downloadInfo;
    static MapDownloadPictureGroup g_imageGroupDownloadInfos; //下载信息
};

#endif // APIREQUEST_H
