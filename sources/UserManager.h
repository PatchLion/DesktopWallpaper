#ifndef USERMANAGER_H
#define USERMANAGER_H

#include <QObject>

class UserManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isVip READ isVip NOTIFY isVipChanged)

public:
    explicit UserManager(QObject *parent = nullptr);

public:
    bool isVip() const;

private:
    void setIsVip(bool vip);

Q_SIGNALS:
    void isVipChanged();

private:
    bool m_isVip; //是否是vip
};

#endif // USERMANAGER_H
