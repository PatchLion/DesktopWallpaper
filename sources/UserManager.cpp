#include "UserManager.h"
#include <QtCore>
#include "Settings.h"
#include "qaeswrap.h"

const static char* kUserInfoCacheFileName = "ucache.dat";

bool UserManager::isInited = false; //是否已初始化
bool UserManager::isVip = false; //是否是vip
QString UserManager::userName = ""; //用户名
QString UserManager::nickName = ""; //昵称
QString UserManager::headerImage = ""; //头像
QString UserManager::token = ""; //token
UserManagerPrivate* UserManager::userPrivate = 0; //
UserManager::MapItemIDToImageIDs UserManager::pefers = UserManager::MapItemIDToImageIDs(); //

UserManager::UserManager(QObject *parent)
    : QObject(parent)
{
    if(!UserManager::isInited)
    {
       UserManager::userPrivate = new UserManagerPrivate;

       readHistory();

       UserManager::isInited = true;
    }

    connect(UserManager::userPrivate, &UserManagerPrivate::isVipChanged, this, &UserManager::isVipChanged);
    connect(UserManager::userPrivate, &UserManagerPrivate::tokenChanged, this, &UserManager::tokenChanged);
    connect(UserManager::userPrivate, &UserManagerPrivate::headerImageChanged, this, &UserManager::headerImageChanged);
    connect(UserManager::userPrivate, &UserManagerPrivate::userNameChanged, this, &UserManager::userNameChanged);
    connect(UserManager::userPrivate, &UserManagerPrivate::nickNameChanged, this, &UserManager::nickNameChanged);
    connect(UserManager::userPrivate, &UserManagerPrivate::pefersChanged, this, &UserManager::pefersChanged);
}

bool UserManager::getIsVip() const
{
    return UserManager::isVip;
}

void UserManager::setIsVip(bool isVip)
{
    UserManager::isVip = isVip;
    writeToHistory();
    Q_EMIT UserManager::userPrivate->isVipChanged();
}

QString UserManager::getToken() const
{
    return UserManager::token;
}

void UserManager::setToken(const QString &value)
{
    UserManager::token = value;
    writeToHistory();
    Q_EMIT UserManager::userPrivate->tokenChanged();
}

QString UserManager::getNickName() const
{
    return UserManager::nickName;
}

void UserManager::setNickName(const QString &value)
{
    UserManager::nickName = value;
    writeToHistory();
    Q_EMIT UserManager::userPrivate->nickNameChanged();
}

QStringList UserManager::getPeferItemIDs() const
{
    return UserManager::pefers.keys();
}

QStringList UserManager::getPeferImageIDs() const
{
    QStringList listIDs;
    Q_FOREACH(QStringList ids, UserManager::pefers.values())
    {
        listIDs += ids;
    }

    return listIDs;
}

void UserManager::setPefers(const UserManager::MapItemIDToImageIDs &pefers)
{
    UserManager::pefers = pefers;

    Q_EMIT UserManager::userPrivate->pefersChanged();

    writeToHistory();

}

void UserManager::updateUserInfo(bool isVip,
                                 const QString &user,
                                 const QString &image,
                                 const QString &token,
                                 const QString &nickName)
{
    qDebug() << "Update user information: " << isVip << user << image << token << nickName;
    UserManager::isVip = isVip;
    UserManager::userName = user;
    UserManager::headerImage = image;
    UserManager::token = token;
    UserManager::nickName = nickName;
    Q_EMIT UserManager::userPrivate->isVipChanged();
    Q_EMIT UserManager::userPrivate->userNameChanged();
    Q_EMIT UserManager::userPrivate->headerImageChanged();
    Q_EMIT UserManager::userPrivate->tokenChanged();
    Q_EMIT UserManager::userPrivate->nickNameChanged();
    writeToHistory();
}

void UserManager::addPefer(const QString &itemID, const QStringList &imageIDs)
{
    if(itemID.isEmpty() || imageIDs.isEmpty()){
        return;
    }

    //qDebug() << "Add pefer: " << itemID << imageIDs;

    UserManager::pefers[itemID] += imageIDs;

    Q_EMIT UserManager::userPrivate->pefersChanged();

    writeToHistory();
}

void UserManager::removePeferByItemID(const QString &itemID)
{
    if(itemID.isEmpty()){
        return;
    }
    UserManager::pefers.remove(itemID);
    Q_EMIT UserManager::userPrivate->pefersChanged();
}

void UserManager::removePeferByImageID(const QString& itemID, const QString &imageID)
{
    if(itemID.isEmpty() || imageID.isEmpty()){
        return;
    }

    if(UserManager::pefers.contains(itemID)){
        UserManager::pefers[itemID].removeOne(imageID);
    }
    Q_EMIT UserManager::userPrivate->pefersChanged();
}

void UserManager::clearUserInfo()
{
    updateUserInfo(false, "", "", "", "");

    clearPefers();
}

void UserManager::readHistory()
{
    QFile file(cacheFilePath());
    if (file.open(QIODevice::ReadOnly)){
        const QString clientid = Settings::clientID();

        QAesWrap aes(clientid.toUtf8(), clientid.toUtf8(), QAesWrap::AES_256);

        QByteArray data = file.readAll();
        QByteArray out;


        aes.decrypt(data,out,QAesWrap::AES_CTR,QAesWrap::PKCS7);

        QDataStream dataStream(out);
        dataStream >> UserManager::userName;
        dataStream >> UserManager::nickName;
        dataStream >> UserManager::isVip;
        dataStream >> UserManager::headerImage;
        dataStream >> UserManager::token;
        dataStream >> UserManager::pefers;


        qDebug() << "History readed:"<<UserManager::userName << ", "
                 << UserManager::nickName << ", "
                 << UserManager::isVip << ", "
                 << UserManager::headerImage  << ", "
                 << UserManager::token << ", "
                 << UserManager::pefers;


        Q_EMIT UserManager::userPrivate->userNameChanged();
        Q_EMIT UserManager::userPrivate->nickNameChanged();
        Q_EMIT UserManager::userPrivate->isVipChanged();
        Q_EMIT UserManager::userPrivate->headerImageChanged();
        Q_EMIT UserManager::userPrivate->tokenChanged();
        Q_EMIT UserManager::userPrivate->pefersChanged();
    }

}

void UserManager::clearPefers()
{
    qDebug() << "Clear pefers";

    UserManager::pefers =  MapItemIDToImageIDs();

    writeToHistory();

    Q_EMIT UserManager::userPrivate->pefersChanged();

    qDebug() << "After clear pefers";

}

void UserManager::writeToHistory()
{
    QFile file(cacheFilePath());
    if (file.open(QIODevice::WriteOnly)){

        const QString clientid = Settings::clientID();


        QBuffer buffer;
        buffer.open(QIODevice::WriteOnly);
        QDataStream dataStream(&buffer);
        dataStream << UserManager::userName;
        dataStream << UserManager::nickName;
        dataStream << UserManager::isVip;
        dataStream << UserManager::headerImage;
        dataStream << UserManager::token;
        dataStream << UserManager::pefers;


        QAesWrap aes(clientid.toUtf8(), clientid.toUtf8(), QAesWrap::AES_256);

        QByteArray mdata = aes.encrypt(buffer.data(),QAesWrap::AES_CTR);

        file.write(mdata);
    }
}

QString UserManager::cacheFilePath()
{
    return QDir(Settings::appCacheRootDir()).absoluteFilePath(kUserInfoCacheFileName);
}

QString UserManager::getHeaderImage() const
{
    return UserManager::headerImage;
}

void UserManager::setHeaderImage(const QString &value)
{

    UserManager::headerImage = value;
    writeToHistory();
    Q_EMIT UserManager::userPrivate->headerImageChanged();

}

QString UserManager::getUserName() const
{
    return UserManager::userName;
}

void UserManager::setUserName(const QString &value)
{

    UserManager::userName = value;
    writeToHistory();
    Q_EMIT UserManager::userPrivate->userNameChanged();

}

UserManagerPrivate::UserManagerPrivate(QObject *parent)
    : QObject(parent)
{

}
