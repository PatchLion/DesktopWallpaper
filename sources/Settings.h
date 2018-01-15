#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = nullptr);

public:
    //缓存根目录
    static QString appCacheRootDir();

    //客户端ID
    static QString clientID();

    //注册表文件路劲
    static QString settingsFilePath();
private:
    //注册表文件
    static bool isKeyExistedInSettingFile(const QString& group, const QString& key);
    static void writeConfigToSettingFile(const QString& group, const QString& key, const QString& value);
    static QString readConfigFromSettingFile(const QString& group, const QString& key);

};

#endif // SETTINGS_H
