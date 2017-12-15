#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QtCore>
#include <QtNetwork>

class Downloader : public QObject
{
    Q_OBJECT
private:
    typedef QMap<QString, QString> MapUrlToLocal;

public:
    explicit Downloader(QObject *parent = nullptr);

public:
    Q_INVOKABLE void startDownload(const QString& url, const QString& local);

protected Q_SLOTS:
    void onReplyFinished();
    void onReplyError(QNetworkReply::NetworkError error);

Q_SIGNALS:
    void downloadFinished(const QString& url);
    void downloadError(const QString& errorInfo);

private:
    QNetworkAccessManager m_network;
    static MapUrlToLocal g_downloadInfo;
};

#endif // DOWNLOADER_H
