#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtGui>
#include <QtCore>
#include <QtNetwork>
#include "APIRequestEx.h"
#include "Settings.h"
#include "Functions.h"

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
    qmlRegisterType<APIRequestEX>("DesktopWallpaper.APIRequestEx", 1, 0, "APIRequestEx");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qmls/admin/main_admin.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
