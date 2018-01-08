#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtGui>
#include "APIRequest.h"
#include "wallpaper.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon(":/images/icon.png"));

    qmlRegisterType<APIRequest>("DesktopWallpaper.APIRequest", 1, 0, "APIRequest");
    qmlRegisterType<Wallpaper>("DesktopWallpaper.Wallpaper", 1, 0, "Wallpaper");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qmls/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
