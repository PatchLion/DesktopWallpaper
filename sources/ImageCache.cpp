#include "ImageCache.h"
#include "Settings.h"

ImageCachePrivate* g_private = 0;
QNetworkAccessManager* ImageCachePrivate::g_network = 0;
ImageCachePrivate::URLToLocalPath ImageCachePrivate::g_localinfo = ImageCachePrivate::URLToLocalPath();

ImageCache::ImageCache(QObject *parent)
    : QObject(parent)
{
    if(!g_private){
        g_private = new ImageCachePrivate;
    }

    connect(g_private, &ImageCachePrivate::imageLoadFinished, this, &ImageCache::onImageLoadFinished);
}

QString ImageCache::safeUrl() const
{
    return g_private->safeUrl(originUrl());
}

void ImageCache::setOriginUrl(const QString &url)
{
    m_url = url;
    g_private->addOriginUrl(url);
    Q_EMIT safeUrlChanged();
}

QString ImageCache::originUrl() const
{
    return m_url;
}

void ImageCache::onImageLoadFinished(const QString &url, bool success)
{
    if(originUrl() == url){
        Q_EMIT safeUrlChanged();
    }
}

#define URLRole "URLRole"

ImageCachePrivate::ImageCachePrivate(QObject *parent)
    : QObject(parent)
{
    readFromLocalInfo();
}

QString ImageCachePrivate::safeUrl(const QString &originurl)
{

    if(g_localinfo.contains(originurl)){
        qDebug() << "Local Image:"<< g_localinfo[originurl].local;
        return "file:///"+g_localinfo[originurl].local;
    }
    return "";
}

void ImageCachePrivate::addOriginUrl(const QString &url)
{
    if(g_localinfo.contains(url)){
        Q_EMIT g_private->imageLoadFinished(url, true);
    }
    else
    {
        //启动网络下载
        if(!g_network){
            g_network = new QNetworkAccessManager;
        }


        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

        QString referstring;
        if (url.contains("&referer="))
        {
            QStringList list = url.split("&referer=");

            if(list.size() >=2){
                referstring = list[1];
                request.setUrl(list[0]);
            }
        }
        //QString referstring = QUrl(url).scheme() + "://" +QUrl(url).host().toLocal8Bit();

        qDebug() << "Start request----->" << request.url().toString() << " referer---->" << referstring;
        if (!referstring.isEmpty())
        {
            request.setRawHeader("referer", referstring.toLocal8Bit());
        }

        QNetworkReply* reply = g_network->get(request);
        reply->setProperty(URLRole, url);
        connect(reply, SIGNAL(finished()), g_private, SLOT(onReplyFinished()));
        reply->setParent(g_network);
    }
}

#define CacheFileName "cache.dat"

void ImageCachePrivate::writeToLocalInfo()
{
    const QString& fullpath = Settings::appCacheRootDir() + CacheFileName;
    QFile file(fullpath);
    if(file.open(QIODevice::WriteOnly)){
        QDataStream ds(&file);

        ds << g_localinfo.size();
        URLToLocalPath::iterator infoItor = g_localinfo.begin();

        for(infoItor; g_localinfo.end() != infoItor; infoItor++){
           infoItor.value().operator<<(ds) ;
        }
    }
}

void ImageCachePrivate::readFromLocalInfo()
{
    g_localinfo.clear();
    const QString& fullpath = Settings::appCacheRootDir() + CacheFileName;
    QFile file(fullpath);
    if(file.open(QIODevice::ReadOnly)){
        QDataStream ds(&file);

        int size = 0;
        ds >> size;

        for(int i=0; i<size; i++){
            stLocalInfo local;
            local.operator >>(ds);

            if(!local.local.isEmpty() && !local.source.isEmpty() && !local.md5.isEmpty()){
                if(QFile::exists(local.local)){
                    QFile file(local.local);
                    if(file.open(QIODevice::ReadOnly)){
                        const QByteArray md5 = QCryptographicHash::hash(file.readAll(), QCryptographicHash::Md5);

                        if(md5 == local.md5){
                            g_localinfo[local.source] = local;
                        }
                    }
                }
            }
        }
    }
}


void ImageCachePrivate::onReplyFinished()
{
    QNetworkReply* reply = dynamic_cast<QNetworkReply*>(sender());
    if(reply){
        QNetworkReply::NetworkError error = reply->error();

        const bool success = (error == QNetworkReply::NoError);
        const QByteArray data = reply->readAll();

        const QString url = reply->property(URLRole).toString();
        const QString filename = url.toLocal8Bit().toBase64()+".dat";

        const QString fullpath = Settings::appCacheRootDir() + filename;

        qDebug() << "Cache filepath:" << fullpath << error;

        if(success && data.length() > 0 && !url.isEmpty()){
            QFile file(fullpath);
            if(file.open(QIODevice::WriteOnly)){
                file.write(data);

                QByteArray md5 = QCryptographicHash::hash(data, QCryptographicHash::Md5);
                stLocalInfo localInfo(url, fullpath, md5);

                g_localinfo[url] = localInfo;

                writeToLocalInfo();
            }
        }
        Q_EMIT imageLoadFinished(url, success);
    }

}

void ImageCachePrivate::onRedirected(const QUrl &url)
{

}

QDataStream &ImageCachePrivate::stLocalInfo::operator<<(QDataStream &datastream)
{
    datastream << source;
    datastream << local;
    datastream << md5;
    return datastream;
}

QDataStream &ImageCachePrivate::stLocalInfo::operator>>(QDataStream &datastream)
{

    datastream >> source;
    datastream >> local;
    datastream >> md5;
    return datastream;
}
