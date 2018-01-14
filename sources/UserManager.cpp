#include "UserManager.h"

UserManager::UserManager(QObject *parent)
    : QObject(parent)
    , m_isVip(false)
{

}

bool UserManager::isVip() const
{
    return m_isVip;
}

void UserManager::setIsVip(bool isVip)
{
    if(isVip != m_isVip){
        m_isVip = isVip;
        Q_EMIT isVipChanged();
    }
}
