#ifndef IMAGECACHE_H
#define IMAGECACHE_H

#include <QObject>
#include <QtNetwork>

class ImageCachePrivate;
class ImageCache : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString safeUrl READ safeUrl NOTIFY safeUrlChanged)
    Q_PROPERTY(QString originUrl WRITE setOriginUrl)

public:
    explicit ImageCache(QObject *parent = nullptr);

public:
    //安全链接
    QString safeUrl() const;

    //原始地址
    void setOriginUrl(const QString &url);
    QString originUrl() const;

Q_SIGNALS:
    void safeUrlChanged();

private Q_SLOTS:
    void onImageLoadFinished(const QString& url, bool success);

private:
    QString m_url;
};


class ImageCachePrivate : public QObject
{
    Q_OBJECT

    struct stLocalInfo{
        stLocalInfo(){}
        stLocalInfo(const QString& s, const QString& l, const QByteArray& m){
            source = s;
            local = l;
            md5 = m;
        }
        QString source; //源地址
        QString local; //本地文件路径
        QByteArray md5; //文件md5

        QDataStream &operator<<(QDataStream &datastream);
        QDataStream &operator>>(QDataStream &datastream);
    };

    typedef QMap<QString, stLocalInfo> URLToLocalPath;

public:
    explicit ImageCachePrivate(QObject *parent = nullptr);

public:
    static QString safeUrl(const QString& originurl);

    static void addOriginUrl(const QString& url);


private:
    static void writeToLocalInfo();
    static void readFromLocalInfo();

Q_SIGNALS:
    void imageLoadFinished(const QString& url, bool success);

private Q_SLOTS:
    void onReplyFinished();

    void onRedirected(const QUrl &url);

private:
    static QNetworkAccessManager* g_network;
    static URLToLocalPath g_localinfo;
};

#endif // IMAGECACHE_H
