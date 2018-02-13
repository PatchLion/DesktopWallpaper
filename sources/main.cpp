#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtGui>
#include <QtCore>
#include <QtNetwork>
#include "APIRequestEx.h"
#include "WallpaperSetter.h"
#include "DownloadBox.h"
#include "UserManager.h"
#include "Settings.h"
#include "Functions.h"
#include "ImageCache.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qDebug() << "Application cache root dir:" << Settings::appCacheRootDir();
    qDebug() << "Application client id:" << Settings::clientID();
    qDebug() << "Application settings file path:" << Settings::settingsFilePath();


    app.setWindowIcon(QIcon(":/images/icon.png"));
#ifdef Q_OS_WIN
    const QString path = QGuiApplication::applicationDirPath() + "/fonts";
#else
    const QString path = QGuiApplication::applicationDirPath() + "/../resources/fonts";
#endif
    loadFontsFromDir(app, path);
    /*
    Q_FOREACH(QString f, QFontDatabase().families())
    {
        qDebug() <<f;
    }
    */
    qDebug() << "Font families loadded!";
    qmlRegisterType<UserManager>("DesktopWallpaper.UserManager", 1, 0, "UserManager");
    qmlRegisterType<DownloadBox>("DesktopWallpaper.DownloadBox", 1, 0, "DownloadBox");
    qmlRegisterType<APIRequestEX>("DesktopWallpaper.APIRequestEx", 1, 0, "APIRequestEx");
    qmlRegisterType<WallpaperSetter>("DesktopWallpaper.WallpaperSetter", 1, 0, "WallpaperSetter");
    qmlRegisterType<ImageCache>("DesktopWallpaper.ImageCache", 1, 0, "ImageCache");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qmls/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
