#ifndef DownloadBox_h__
#define DownloadBox_h__

#include <QtCore>
#include <QtNetwork>

class DownloadBoxPrivate;
class DownloadBox : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int downloadingCount READ getDownloadingCount NOTIFY downloadingCountChanged)

private:
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

    typedef QMap<QByteArray, stImageGroupDownloadInfo> MapDownloadPictureGroup; //QStringList 0->保存根目录

public:
    explicit DownloadBox(QObject *parent = nullptr);

public:
    //发起图片组下载请求
    Q_INVOKABLE QString addDownload(const QString& savePath, const QString& name, const QStringList& urls);

    //构建下载信息
    Q_INVOKABLE static QByteArray buildDownloadInfo();

private:
    //统计下载中的请求
    static int getDownloadingCount();


    static QNetworkAccessManager* network();


Q_SIGNALS:
    //图片组下载信息
    void imageGroupDownloadProgress(const QString& key, int total, int finished, int error);

    //下载中总数改变
    void downloadingCountChanged(int count);

    //下载信息变化
    void downloadInfosChanged(const QByteArray& downloads);

private Q_SLOTS:
    void onReplyFinished();

private:
    static bool g_isInited;
    static QNetworkAccessManager* g_network; //网络对象
    static MapDownloadPictureGroup g_imageGroupDownloadInfos; //下载信息
    static DownloadBoxPrivate* g_private; //
};

class DownloadBoxPrivate : public QObject
{
    Q_OBJECT
public:
    DownloadBoxPrivate(QObject* parent=0)
        :QObject(parent){}

Q_SIGNALS:
    //图片组下载信息
    void imageGroupDownloadProgress(const QString& key, int total, int finished, int error);

    //下载中总数改变
    void downloadingCountChanged(int count);

    //下载信息变化
    void downloadInfosChanged(const QByteArray& downloads);
};

#endif // DownloadBox_h__
