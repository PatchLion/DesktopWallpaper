#include "Functions.h"
#include <QtGui>

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
