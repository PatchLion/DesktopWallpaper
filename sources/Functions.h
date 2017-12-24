#ifndef Functions_h__
#define Functions_h__

#include <QtCore>

class Functions : public QObject
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
    Functions(QObject* parent = 0){}

public:
    //
    Q_INVOKABLE void setImageToDesktop(const QString& url, Mode mode = Fit);

private:
    QString doImageToDesktop(const QString& localfile, Mode mode = Fit);

Q_SIGNALS:
    void finished(bool success, const QString& msg);
};
#endif
