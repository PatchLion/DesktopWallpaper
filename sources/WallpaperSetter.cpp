#include "WallpaperSetter.h"
#include <QtNetwork>

#define FullPathRole "FullPathRole"
#define ModeRole "ModeRole"

QString dirPath(){
    return QStandardPaths::standardLocations(QStandardPaths::PicturesLocation)[0] + "/" + kDirName;
}
QNetworkAccessManager *WallpaperSetter::g_network = 0;
WallpaperSetter::~WallpaperSetter()
{
    /*
    if(m_loop)
    {
        m_loop->quit();
    }
    */
}

void WallpaperSetter::setImageToDesktop(const QString& url, QVariant processfunc, QVariant finishedfunc, Mode mode) {

    m_jsProcessFunc = processfunc.value<QJSValue>();
    m_jsFinshedFunc = finishedfunc.value<QJSValue>();


    Q_ASSERT(m_jsProcessFunc.isCallable());
    Q_ASSERT(m_jsFinshedFunc.isCallable());

    QJSValueList listParam;

    if(url.isEmpty())
    {
        //Q_EMIT finished(false, QString::fromLocal8Bit("无效的Url"));
        listParam.clear();
        listParam << false;
        listParam << QString::fromLocal8Bit("无效的Url");

        m_jsFinshedFunc.call(listParam);

        return;
    }

    const QString fullpath = dirPath() + "/" + url.toUtf8().toBase64() + ".png";


    if (QFile().exists(fullpath)){
        const QString res = doImageToDesktop(fullpath, mode);

        listParam.clear();
        listParam << res.isEmpty();
        listParam << res;

        m_jsFinshedFunc.call(listParam);

        return;
    }

    QNetworkReply* reply = network()->get(QNetworkRequest(url));
    reply->setProperty(FullPathRole, fullpath);
    reply->setProperty(ModeRole, mode);
    connect(reply, &QNetworkReply::finished, this, &WallpaperSetter::onReplyFinished);
    connect(reply, &QNetworkReply::downloadProgress, this, &WallpaperSetter::onDownloadProgress);
}



QNetworkAccessManager *WallpaperSetter::network()
{
    if(!WallpaperSetter::g_network){
        WallpaperSetter::g_network = new QNetworkAccessManager;
    }

    return WallpaperSetter::g_network;
}

void WallpaperSetter::onReplyFinished()
{
    if (!QDir().exists(dirPath())){
        QDir().mkpath(dirPath());
    }

    QNetworkReply *reply = dynamic_cast<QNetworkReply*>(sender());

    Q_ASSERT(m_jsProcessFunc.isCallable());
    Q_ASSERT(m_jsFinshedFunc.isCallable());
    Q_ASSERT(reply);

    QJSValueList listParam;



    const QNetworkReply::NetworkError error = reply->error();
    if(error == QNetworkReply::NoError){
        const QByteArray data = reply->readAll();

        const QString fullpath = reply->property(FullPathRole).toString();

       QFile file(fullpath);

       if(file.open(QIODevice::WriteOnly))
       {
           file.write(data);
           file.close();

           listParam.clear();
           listParam << 0.5;
           listParam << QString::fromLocal8Bit("壁纸设置中...");

           m_jsProcessFunc.call(listParam);

           WallpaperSetter::Mode mode = static_cast<WallpaperSetter::Mode>(reply->property(ModeRole).toInt());

            const QString res = doImageToDesktop(fullpath, mode);

            listParam.clear();
            listParam << res.isEmpty();
            listParam << res;
       }
       else{
           listParam.clear();
           listParam << false;
           listParam << QString::fromLocal8Bit("写入文件到:")+fullpath+QString::fromLocal8Bit("时发生异常! 异常提示:")+file.errorString();
       }
    }
    else{
        listParam.clear();
        listParam << false;
        listParam << QString::fromLocal8Bit("网络请求出现异常，错误代码:%1").arg(error);
    }

    m_jsFinshedFunc.call(listParam);
}

void WallpaperSetter::onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    Q_ASSERT(m_jsProcessFunc.isCallable());

    qDebug() << "Wallpaper downloading: " << (double)bytesReceived/(double)bytesTotal << bytesReceived << bytesTotal;

    QJSValueList listParam;

    listParam.clear();
    listParam << 0.5 * (double)bytesReceived/(double)bytesTotal;
    listParam << QString::fromLocal8Bit("壁纸下载中...");

    m_jsProcessFunc.call(listParam);
}

#ifdef Q_OS_WINRT
QString WallpaperSetter::doImageToDesktop(const QString &localfile, WallpaperSetter::Mode mode) {
	return QString::fromLocal8Bit("Not implemented!");
}
#else

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

#endif

