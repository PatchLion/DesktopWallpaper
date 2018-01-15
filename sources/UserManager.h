#ifndef USERMANAGER_H
#define USERMANAGER_H

#include <QObject>

class UserManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isVip READ getIsVip WRITE setIsVip  NOTIFY isVipChanged)
    Q_PROPERTY(QString userName READ getUserName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString headerImage READ getHeaderImage WRITE setHeaderImage NOTIFY headerImageChanged)
    Q_PROPERTY(QString token READ getToken WRITE setToken NOTIFY tokenChanged)
    Q_PROPERTY(QString nickName READ getNickName WRITE setNickName NOTIFY nickNameChanged)

public:
    explicit UserManager(QObject *parent = nullptr);

public:
    bool getIsVip() const;
    void setIsVip(bool vip);

    QString getUserName() const;
    void setUserName(const QString &value);

    QString getHeaderImage() const;
    void setHeaderImage(const QString &value);

    QString getToken() const;
    void setToken(const QString &value);

    QString getNickName() const;
    void setNickName(const QString &value);


    Q_INVOKABLE void writeToHistory();
private:
    void readHistory();

    static QString cacheFilePath();

Q_SIGNALS:
    void isVipChanged();
    void tokenChanged();
    void headerImageChanged();
    void userNameChanged();
    void nickNameChanged();

private:
    bool isVip; //是否是vip
    QString userName; //用户名
    QString nickName; //昵称
    QString headerImage; //头像
    QString token; //token
};

#endif // USERMANAGER_H
