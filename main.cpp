#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "ImagesRequests.h"
#include "ImageClassify.h"
#include "Downloader.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<Downloader>("DesktopWallpaper.Downloader", 1, 0, "Downloader");
    qmlRegisterType<ImageClassify>("DesktopWallpaper.ImageClassify", 1, 0, "ImageClassify");
    qmlRegisterType<ImagesRequests>("DesktopWallpaper.ImagesRequests", 1, 0, "ImagesRequests");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
