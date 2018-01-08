#ifndef Wallpaper_h__
#define Wallpaper_h__

#include <QtCore>


const static char* kDirName = "beautyfinder_wallpaper";

class Wallpaper : public QObject
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
    Wallpaper(QObject* parent = 0)
        :m_loop(0){}
    ~Wallpaper();

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
