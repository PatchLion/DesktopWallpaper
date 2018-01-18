#ifndef WallpaperSetter_h__
#define WallpaperSetter_h__

#include <QtCore>
#include <QJSValue>


const static char* kDirName = "beautyfinder_wallpaper";

class QNetworkAccessManager;
class WallpaperSetter : public QObject
{
    Q_OBJECT
public:
    enum Mode{
        Fill,
        Fit,
        Stretch,
        Center,
    };
    Q_ENUMS(Mode)
public:
    explicit WallpaperSetter(QObject* parent = 0)
        : QObject(parent)
        //, m_loop(0)
        {}
    virtual ~WallpaperSetter();

public:
    //
    Q_INVOKABLE void setImageToDesktop(const QString& url, QVariant processfunc, QVariant finishedfunc, Mode mode = Fit);

private:
    QString doImageToDesktop(const QString& localfile, Mode mode = Fit);

    static QNetworkAccessManager* network();

protected Q_SLOTS:
    void onReplyFinished();
    void onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);

Q_SIGNALS:
    //void progress(double progress, const QString& text);
    //void finished(bool success, const QString& msg);

private:
    //QEventLoop* m_loop;

    static QNetworkAccessManager *g_network;

    QJSValue m_jsProcessFunc; //function(progress, msg)
    QJSValue m_jsFinshedFunc; //function(progress, msg)
};
#endif
