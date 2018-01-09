#include "WallpaperSetter.h"
#include <QtNetwork>

QString dirPath(){
    return QStandardPaths::standardLocations(QStandardPaths::PicturesLocation)[0] + "/" + kDirName;
}

WallpaperSetter::~WallpaperSetter()
{
    if(m_loop)
    {
        m_loop->quit();
    }
}

void WallpaperSetter::setImageToDesktop(const QString& url, Mode mode) {
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
    WallpaperSetter* object = this;
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


#ifdef Q_OS_WIN
#include <windows.h>
#include <shlobj.h>
#include <wininet.h>

QString WallpaperSetter::doImageToDesktop(const QString &localfile, WallpaperSetter::Mode mode)
{
    //if (argc > 1) {
        //wchar_t fullPath = reinterpret_cast<wchar_t *>(localfile.utf16());

        if (!QFile().exists(localfile)) {
            //fputs("Invalid path", stderr);
            return QString::fromLocal8Bit("无效的路径: %1").arg(localfile);
        }

        if (!SystemParametersInfoW(SPI_SETDESKWALLPAPER, 0, (TCHAR *)localfile.toStdWString().c_str(), SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE)) {
            fputs("Failed to set the desktop wallpaper", stderr);
            return QString::fromLocal8Bit("设置壁纸失败!");
        }
    /*} else {
        wchar_t imagePath[MAX_PATH];

        if (SystemParametersInfoW(SPI_GETDESKWALLPAPER, MAX_PATH, imagePath, 0)) {
            _setmode(_fileno(stdout), _O_U8TEXT);
            wprintf(L"%s\n", imagePath);
        } else {
            fputs("Failed to get the desktop wallpaper", stderr);
            return 1;
        }
    }
*/

    return "";
}

#endif

