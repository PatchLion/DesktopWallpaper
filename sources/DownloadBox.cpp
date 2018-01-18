#include "DownloadBox.h"


#define RequestArgsRole "RequestArgsRole"

QNetworkAccessManager* DownloadBox::g_network = 0; //网络对象
DownloadBoxPrivate* DownloadBox::g_private = 0; //
DownloadBox::MapDownloadPictureGroup DownloadBox::g_imageGroupDownloadInfos = DownloadBox::MapDownloadPictureGroup();
bool DownloadBox::g_isInited = false;
DownloadBox::DownloadBox(QObject *parent)
    : QObject(parent)
{
    if(!DownloadBox::g_isInited){
        DownloadBox::g_private = new DownloadBoxPrivate;
        DownloadBox::g_isInited = true;
    }


    connect(DownloadBox::g_private, &DownloadBoxPrivate::downloadInfosChanged, this, &DownloadBox::downloadInfosChanged);
    connect(DownloadBox::g_private, &DownloadBoxPrivate::downloadingCountChanged, this, &DownloadBox::downloadingCountChanged);
    connect(DownloadBox::g_private, &DownloadBoxPrivate::imageGroupDownloadProgress, this, &DownloadBox::imageGroupDownloadProgress);
}

QByteArray buildKey(const QString& savePath, const QString& name)
{
    const QString& absDir = QUrl(savePath).toLocalFile();

    const QString& key = name + "<>" + absDir;

    return key.toLocal8Bit().toBase64();
}
QString urlToFileName(const QString& url)
{
    return QString("%1.jpg").arg(url.toLocal8Bit().toBase64().data());
}
QString DownloadBox::addDownload(const QString &savePath, const QString &name, const QStringList &urls)
{
    qDebug() << savePath << " " << name << " " << urls.length();
    if(savePath.isEmpty() || name.isEmpty() || urls.isEmpty())
    {
        qWarning() << QString::fromLocal8Bit("APIRequest::addDownload 参数无效!");
        return "";
    }

    const QByteArray& key = buildKey(savePath, name);
    if(!g_imageGroupDownloadInfos.contains(key)){
        //
        stImageGroupDownloadInfo downloadInfo;
        downloadInfo.savePath = QUrl(savePath).toLocalFile() + "/" + name;
        Q_FOREACH(QString url, urls)
        {
            const QString& filename = urlToFileName(url);
            const QString& fullpath = QDir(downloadInfo.savePath).absoluteFilePath(filename);
            QFileInfo fileInfo(fullpath);
            if(fileInfo.exists() && fileInfo.size() > 0)
            {
                downloadInfo.downloads[fullpath] = Downloaded;
            }
            else
            {
                downloadInfo.downloads[fullpath] = Downloading;

                QVariantList args;
                args << key;
                args << url;
                args << fullpath;

                QNetworkRequest request(url);
                request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

                QNetworkReply* reply = network()->get(request);
                reply->setProperty(RequestArgsRole, args);
                connect(reply, SIGNAL(finished()), this, SLOT(onReplyFinished()));
                reply->setParent(this);
            }
        }

        g_imageGroupDownloadInfos[key] = downloadInfo;
    }

    Q_EMIT g_private->downloadingCountChanged(getDownloadingCount());

    Q_EMIT g_private->downloadInfosChanged(buildDownloadInfo());

    return key;
}

int DownloadBox::getDownloadingCount()
{
    //return 20;
    int downloading = 0;
    MapDownloadPictureGroup::const_iterator groupItor = g_imageGroupDownloadInfos.begin();

    for(groupItor; g_imageGroupDownloadInfos.end() != groupItor; groupItor++)
    {
        MapDownloadState::const_iterator downloadItor = groupItor.value().downloads.begin();

        for(downloadItor; groupItor.value().downloads.end()!=downloadItor; downloadItor++)
        {
            if(downloadItor.value() == Downloading)
            {
                downloading++;
                break;
            }
        }
    }

    return downloading;
}

QNetworkAccessManager *DownloadBox::network()
{
    if (!DownloadBox::g_network){
        DownloadBox::g_network = new QNetworkAccessManager;
    }

    return DownloadBox::g_network;
}

QByteArray DownloadBox::buildDownloadInfo()
{
    QVariantList downloadinfos;
    MapDownloadPictureGroup::const_iterator groupItor = g_imageGroupDownloadInfos.begin();

    for(groupItor; g_imageGroupDownloadInfos.end() != groupItor; groupItor++)
    {
        QVariantMap download;
        QString temp = QString::fromLocal8Bit(QByteArray::fromBase64(groupItor.key()));
        QString name = temp.split("<>")[0];
        qDebug() << "Download info" << temp.split("<>")[0] << name;
        download.insert("name", name);
        download.insert("path", groupItor.value().savePath);

        int downloading = 0, downloaded = 0, downloadFailed = 0;
        MapDownloadState::const_iterator downloadItor = groupItor.value().downloads.begin();
        for(downloadItor; groupItor.value().downloads.end()!=downloadItor; downloadItor++)
        {
            if(downloadItor.value() == Downloading)
            {
                downloading++;
            }
            else if(downloadItor.value() == Downloaded)
            {
                downloaded++;
            }
            else if(downloadItor.value() == DownloadFailed)
            {
                downloadFailed++;
            }
        }

        download.insert("downloading", downloading);
        download.insert("downloaded", downloaded);
        download.insert("downloadFailed", downloadFailed);

        if(downloading > 0)
        {
            downloadinfos << download;
        }
    }

    QString ret = "[]";
    QJsonDocument jsonDocument = QJsonDocument::fromVariant(downloadinfos);
    if (!jsonDocument.isNull()) {
        ret = jsonDocument.toJson(QJsonDocument::Compact);
    }
    //qDebug() << "Download info json --->" << ret;
    return ret.toUtf8();
}

void DownloadBox::onReplyFinished()
{
    QNetworkReply *reply = dynamic_cast<QNetworkReply*>(sender());

    if(reply)
    {
        const QVariantList args = reply->property(RequestArgsRole).value<QVariantList>();

        QNetworkReply::NetworkError error = reply->error();

        const bool success = (error == QNetworkReply::NoError);
        const QByteArray data = reply->readAll();

        Q_ASSERT(args.size() == 3);
        Q_ASSERT(args[0].isValid()); //key
        Q_ASSERT(args[1].isValid()); //url
        Q_ASSERT(args[2].isValid()); //fullpath
        if(success)
        {
            QByteArray key = args[0].toByteArray();
            QString url = args[1].toString();
            QString fullpath = args[2].toString();
            if(!key.isEmpty() && g_imageGroupDownloadInfos.contains(key))
            {
                //qDebug() << "Download finished: " << url << " data length: " << data.count();

                stImageGroupDownloadInfo& downloadInfo = g_imageGroupDownloadInfos[key];

                //const QString tempDest = QUrl(fullpath).toLocalFile();
                QFileInfo fileInfo(fullpath);
                if(!fileInfo.absoluteDir().exists())
                {
                    //qDebug() << "Make path: " << fileInfo.absolutePath();
                    fileInfo.absoluteDir().mkpath(fileInfo.absolutePath());
                }

                QFile file(fullpath);
                if(file.open(QIODevice::WriteOnly))
                {
                    file.write(data);
                    file.close();

                    downloadInfo.downloads[fullpath] = Downloaded;

                }
                else
                {

                    downloadInfo.downloads[fullpath] = DownloadFailed;

                    const QString msg = "Failed to write to file: " + fullpath + "! reason: " + file.errorString();
                    qWarning() <<msg;
                }

                int finished = 0, error = 0;

                MapDownloadState::const_iterator downloadItor = downloadInfo.downloads.begin();

                for(downloadItor; downloadInfo.downloads.end()!=downloadItor; downloadItor++)
                {
                    if(downloadItor.value() == Downloaded)
                    {
                        finished++;
                    }
                    else if(downloadItor.value() == DownloadFailed)
                    {
                        error++;
                    }
                }

                Q_EMIT g_private->imageGroupDownloadProgress(key, downloadInfo.downloads.size(), finished, error);
            }
        }


        Q_EMIT g_private->downloadingCountChanged(getDownloadingCount());
        Q_EMIT g_private->downloadInfosChanged(buildDownloadInfo());


    }
}

