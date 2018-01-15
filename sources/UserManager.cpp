#include "UserManager.h"
#include <QtCore>
#include "Settings.h"
#include "qaeswrap.h"

const static char* kUserInfoCacheFileName = "ucache.dat";

UserManager::UserManager(QObject *parent)
    : QObject(parent)
    , isVip(false)
{
    readHistory();
}

bool UserManager::getIsVip() const
{
    return isVip;
}

void UserManager::setIsVip(bool isVip)
{
    //if(isVip != this->isVip)
    {
        this->isVip = isVip;
        Q_EMIT isVipChanged();
    }
}

QString UserManager::getToken() const
{
    return token;
}

void UserManager::setToken(const QString &value)
{
    //if(value != this->token)
    {
        this->token = value;
        Q_EMIT tokenChanged();
    }
}

QString UserManager::getNickName() const
{
    return nickName;
}

void UserManager::setNickName(const QString &value)
{
    nickName = value;
    Q_EMIT nickNameChanged();
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
    //if(value != this->headerImage)
    {
        this->headerImage = value;
        Q_EMIT headerImageChanged();
     }
}

QString UserManager::getUserName() const
{
    return userName;
}

void UserManager::setUserName(const QString &value)
{
    //if(value != this->userName)
    {
        userName = value;
        Q_EMIT userNameChanged();
    }
}
