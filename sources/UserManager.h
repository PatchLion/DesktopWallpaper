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
    void peferItemIDsChanged();
    void peferImageIDsChanged();
};

class UserManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isVip READ getIsVip WRITE setIsVip  NOTIFY isVipChanged)
    Q_PROPERTY(QString userName READ getUserName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString headerImage READ getHeaderImage WRITE setHeaderImage NOTIFY headerImageChanged)
    Q_PROPERTY(QString token READ getToken WRITE setToken NOTIFY tokenChanged)
    Q_PROPERTY(QString nickName READ getNickName WRITE setNickName NOTIFY nickNameChanged)
    Q_PROPERTY(QStringList peferItemIDs READ getPeferItemIDs NOTIFY peferItemIDsChanged)
    Q_PROPERTY(QList< int > peferImageIDs READ getPeferImageIDs NOTIFY peferImageIDsChanged)
    //Q_PROPERTY(int peferCountByItemID READ getPeferCountByItemID NOTIFY pefersChanged)
    //Q_PROPERTY(QList< int > testIDs READ getTestIDs NOTIFY pefersChanged)

    typedef QMap<QString, QList< int >> MapItemIDToImageIDs;
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

    QStringList getPeferItemIDs() const;

    QList< int > getPeferImageIDs() const;

    Q_INVOKABLE int getPeferCountByItemID(const QString& itemID);

    /*
    Q_INVOKABLE QList< int > getTestIDs() const {
        QList< int > list ;
        list.append( 10159)  ;
        list.append( 5555)  ;
        return list;
    }*/

    Q_INVOKABLE static void setPefers(const MapItemIDToImageIDs& pefers);

    Q_INVOKABLE static void updateUserInfo(bool isVip,
                                    const QString& user,
                                    const QString& image,
                                    const QString& token,
                                    const QString& nickName);

    Q_INVOKABLE static void addPefer(const QString& itemID, const QList< int >& imageIDs);
    Q_INVOKABLE static void removePeferByItemID(const QString& itemID);
    Q_INVOKABLE static void removePeferByImageID(const QString& itemID, const QList< int >& imageIDs);

    Q_INVOKABLE static void clearUserInfo();

    Q_INVOKABLE static void writeToHistory();


    Q_INVOKABLE static void clearPefers();
private:
    static void readHistory();

    static QString cacheFilePath();

Q_SIGNALS:
    void isVipChanged();
    void tokenChanged();
    void headerImageChanged();
    void userNameChanged();
    void nickNameChanged();
    void peferItemIDsChanged();
    void peferImageIDsChanged();

private:
    static bool isInited;
    static bool isVip; //是否是vip
    static QString userName; //用户名
    static QString nickName; //昵称
    static QString headerImage; //头像
    static QString token; //token
    static UserManagerPrivate* userPrivate;
    static MapItemIDToImageIDs pefers; //收藏
};

#endif // USERMANAGER_H
