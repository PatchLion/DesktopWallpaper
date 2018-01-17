#ifndef USERMANAGER_H
#define USERMANAGER_H

#include <QObject>

class UserManagerPrivate : public QObject
{
    Q_OBJECT
public:
    UserManagerPrivate(QObject* parent=0);

Q_SIGNALS:
    void isVipChanged();
    void tokenChanged();
    void headerImageChanged();
    void userNameChanged();
    void nickNameChanged();
};

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

    Q_INVOKABLE static void updateUserInfo(bool isVip,
                                    const QString& user,
                                    const QString& image,
                                    const QString& token,
                                    const QString& nickName);

    Q_INVOKABLE static void clearUserInfo();

    Q_INVOKABLE static void writeToHistory();
private:
    static void readHistory();

    static QString cacheFilePath();

Q_SIGNALS:
    void isVipChanged();
    void tokenChanged();
    void headerImageChanged();
    void userNameChanged();
    void nickNameChanged();

private:
    static bool isInited;
    static bool isVip; //是否是vip
    static QString userName; //用户名
    static QString nickName; //昵称
    static QString headerImage; //头像
    static QString token; //token
    static UserManagerPrivate* userPrivate;
};

#endif // USERMANAGER_H
