#include "Downloader.h"

Downloader::MapUrlToLocal Downloader::g_downloadInfo = Downloader::MapUrlToLocal();

Downloader::Downloader(QObject *parent)
    : QObject(parent)
{

}

void Downloader::startDownload(const QString &url, const QString &local)
{
    if(g_downloadInfo.contains(url))
    {
        Q_EMIT downloadError("Already downloading......");
        return;
    }
    else
    {
        if(!url.isEmpty() && !local.isEmpty())
        {
            QNetworkReply* reply = m_network.get(QNetworkRequest(url));

            connect(reply, &QNetworkReply::finished, this, &Downloader::onReplyFinished);
            connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onReplyError(QNetworkReply::NetworkError)));

            reply->setParent(&m_network);

            g_downloadInfo[url] = local;
        }
    }

}

void Downloader::onReplyFinished()
{
    QNetworkReply* reply = dynamic_cast<QNetworkReply*>(sender());

    if(reply && QNetworkReply::NoError == reply->error())
    {
        QByteArray data = reply->readAll();
        const QString url = reply->url().toString();

        if(g_downloadInfo.contains(url))
        {
            qDebug() << "Download finished: " << url << " data length: " << data.count();

            const QString dest = g_downloadInfo[url];

            const QString tempDest = QUrl(dest).toLocalFile();
            QFileInfo fileInfo(tempDest);
            if(!fileInfo.absoluteDir().exists())
            {
                qDebug() << "Make path: " << fileInfo.absolutePath();
                fileInfo.absoluteDir().mkpath(fileInfo.absolutePath());
            }

            QFile file(tempDest);
            if(file.open(QIODevice::WriteOnly))
            {
                file.write(data);
                file.close();

                Q_EMIT downloadFinished(url);
            }
            else
            {
                const QString msg = "Failed to write to file: " + tempDest + "! reason: " + file.errorString();
                qWarning() <<msg;
                Q_EMIT downloadError(msg);
            }
        }
    }
}

void Downloader::onReplyError(QNetworkReply::NetworkError error)
{
    QNetworkReply* reply = dynamic_cast<QNetworkReply*>(sender());

    if(reply)
    {
        const QString msg = QString("Failed to download: ") + reply->url().toString() + QString("; code: ") + error;
        Q_EMIT downloadError(msg);
    }
}
