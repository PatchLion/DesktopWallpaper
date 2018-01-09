#ifndef WallpaperSetter_h__
#define WallpaperSetter_h__

#include <QtCore>


const static char* kDirName = "beautyfinder_wallpaper";

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
    WallpaperSetter(QObject* parent = 0)
        : QObject(parent)
        , m_loop(0){}
    ~WallpaperSetter();

public:
    //
    Q_INVOKABLE void setImageToDesktop(const QString& url, Mode mode = Fit);

private:
    QString doImageToDesktop(const QString& localfile, Mode mode = Fit);

Q_SIGNALS:
    void progress(double progress, const QString& text);
    void finished(bool success, const QString& msg);

private:
    QEventLoop* m_loop;
};
#endif
