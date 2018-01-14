#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtGui>
#include <QtCore>
#include "APIRequest.h"
#include "WallpaperSetter.h"
#include "UserManager.h"

void loadFontsFromDir(QGuiApplication& app, const QString& path)
{
    qDebug() << "Load font families from: " << path;

    QDir dir(path);
    if (dir.exists())
    {
        //读取目录下的文件
        QFileInfoList fileInfoList = dir.entryInfoList(QDir::Files | QDir::Dirs);

        for (int nIndex = 0; nIndex < fileInfoList.size(); nIndex++)
        {
            const QFileInfo& fileInfo = fileInfoList[nIndex];

            if (fileInfo.isDir())
            {
                if(fileInfo.fileName() != "." && fileInfo.fileName() != "..")
                {
                    loadFontsFromDir(app, fileInfo.absoluteFilePath());
                }
            }
            else
            {
                //读取字体文件
                const int nFamilyID = QFontDatabase::addApplicationFont(fileInfo.absoluteFilePath());

                if (-1 == nFamilyID)
                {
                    qWarning() << QString("Failed to install font file: %1").arg(fileInfo.fileName());
                }
                else
                {
                    qDebug() << "Font file loaded: " << fileInfo.fileName();
                }
            }

        }
    }
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

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
    qmlRegisterType<APIRequest>("DesktopWallpaper.APIRequest", 1, 0, "APIRequest");
    qmlRegisterType<WallpaperSetter>("DesktopWallpaper.WallpaperSetter", 1, 0, "WallpaperSetter");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qmls/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
