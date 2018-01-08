#include "Wallpaper.h"
#include <QtNetwork>

QString dirPath(){
    return QStandardPaths::standardLocations(QStandardPaths::PicturesLocation)[0] + "/" + kDirName;
}

Wallpaper::~Wallpaper()
{
    if(m_loop)
    {
        m_loop->quit();
    }
}

void Wallpaper::setImageToDesktop(const QString& url, Mode mode) {
    if(url.isEmpty())
    {
        Q_EMIT finished(false, QString::fromLocal8Bit("无效的Url"));
    }

    const QString fullpath = dirPath() + "/" + url.toUtf8().toBase64() + ".png";


    if (QFile().exists(fullpath)){
        const QString res = doImageToDesktop(fullpath, mode);

        if(res.isEmpty()){
            Q_EMIT finished(true, "");
        }
        else{
            Q_EMIT finished(false, res);
        }

        return;
    }

    QNetworkAccessManager network;
    QNetworkReply* reply = network.get(QNetworkRequest(url));

    QEventLoop loop;
    Wallpaper* object = this;
    connect(reply, &QNetworkReply::downloadProgress, [=, &object](qint64 bytesReceived, qint64 bytesTotal){
        Q_EMIT object->progress((double)bytesReceived/(double)bytesTotal,  tr("Wallpaper downloading..."));
    } );

    connect(reply, &QNetworkReply::finished, [=, &loop, &reply, &object](){
        if (!QDir().exists(dirPath())){
            QDir().mkpath(dirPath());
        }

        const QNetworkReply::NetworkError error = reply->error();
        if(error == QNetworkReply::NoError){
            const QByteArray data = reply->readAll();

           QFile file(fullpath);

           if(file.open(QIODevice::WriteOnly))
           {
               file.write(data);
               file.close();

               Q_EMIT object->progress(1.0, QString::fromLocal8Bit("壁纸设置中..."));
                const QString res = doImageToDesktop(fullpath, mode);

                if(res.isEmpty()){
                    Q_EMIT finished(true, "");
                    Q_EMIT object->progress(1.0, QString::fromLocal8Bit("壁纸设置完成"));
                }
                else{
                    Q_EMIT finished(false, res);
                }
           }
           else{
               Q_EMIT finished(false, QString::fromLocal8Bit("写入文件到:")+fullpath+QString::fromLocal8Bit("时发生异常! 异常提示:")+file.errorString());
           }
        }
        else{
            Q_EMIT finished(false, QString::fromLocal8Bit("网络请求出现异常，错误代码:%1").arg(error));
        }

        m_loop = 0;
        loop.quit();
    });

    m_loop = &loop;
    loop.exec();
}
