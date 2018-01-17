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
UserManager::UserManager(QObject *parent)
    : QObject(parent)
{
    if(!UserManager::isInited)
    {
       readHistory();
       UserManager::isInited = true;
    }
}

bool UserManager::getIsVip() const
{
    return isVip;
}

void UserManager::setIsVip(bool isVip)
{
    this->isVip = isVip;
    writeToHistory();
    Q_EMIT isVipChanged();
}

QString UserManager::getToken() const
{
    return token;
}

void UserManager::setToken(const QString &value)
{
    this->token = value;
    writeToHistory();
    Q_EMIT tokenChanged();
}

QString UserManager::getNickName() const
{
    return nickName;
}

void UserManager::setNickName(const QString &value)
{
    nickName = value;
    writeToHistory();
    Q_EMIT nickNameChanged();
}

void UserManager::updateUserInfo(bool isVip, const QString &user, const QString &image, const QString &token, const QString &nickName)
{
    qDebug() << "Update user information: " << isVip << user << image << token << nickName;
    this->isVip = isVip;
    this->userName = user;
    this->headerImage = image;
    this->token = token;
    this->nickName = nickName;
    Q_EMIT isVipChanged();
    Q_EMIT userNameChanged();
    Q_EMIT headerImageChanged();
    Q_EMIT tokenChanged();
    Q_EMIT nickNameChanged();
    writeToHistory();
}

void UserManager::clearUserInfo()
{
    updateUserInfo(false, "", "", "", "");
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
        dataStream >> userName;
        dataStream >> nickName;
        dataStream >> isVip;
        dataStream >> headerImage;
        dataStream >> token;


        qDebug() << "History readed:"<<userName << ", "
                 << nickName << ", "
                 << isVip << ", "
                 << headerImage  << ", "
                 << token;


        Q_EMIT userNameChanged();
        Q_EMIT nickNameChanged();
        Q_EMIT isVipChanged();
        Q_EMIT headerImageChanged();
        Q_EMIT tokenChanged();
    }

}

void UserManager::writeToHistory()
{
    QFile file(cacheFilePath());
    if (file.open(QIODevice::WriteOnly)){

        const QString clientid = Settings::clientID();


        QBuffer buffer;
        buffer.open(QIODevice::WriteOnly);
        QDataStream dataStream(&buffer);
        dataStream << userName;
        dataStream << nickName;
        dataStream << isVip;
        dataStream << headerImage;
        dataStream << token;


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
    return headerImage;
}

void UserManager::setHeaderImage(const QString &value)
{

    this->headerImage = value;
    writeToHistory();
    Q_EMIT headerImageChanged();

}

QString UserManager::getUserName() const
{
    return userName;
}

void UserManager::setUserName(const QString &value)
{

    userName = value;
    writeToHistory();
    Q_EMIT userNameChanged();

}
