#include "Settings.h"
#include <QtCore>


const static char* kGroupName = "BeautyFinder";

const static char* kClienIDKey = "ClientID";

Settings::Settings(QObject *parent)
    : QObject(parent)
{

}

QString Settings::appCacheRootDir()
{
    QString path;
#ifdef Q_OS_WIN
  const QStringList listPath = QStandardPaths::standardLocations(QStandardPaths::GenericDataLocation);
  path = QString("%1:/ProgramData/").arg(listPath[0].mid(0, 1)) + "beautyfinder/";
#else //Q_OS_MAC
  path = QStandardPaths::writableLocation(QStandardPaths::DataLocation) +"/beautyfinder/";
#endif

  //qDebug() << "appCacheRootDir:" << path;

  if (!QDir(path).exists())
  {
      QDir().mkpath(path);
  }

  return path;
}

QString Settings::clientID()
{
    QString id = readConfigFromSettingFile(kGroupName, kClienIDKey);

    if (id.isEmpty()){
        id = QUuid::createUuid().toString();
        writeConfigToSettingFile(kGroupName, kClienIDKey, id);
    }

    return id;
}

QString Settings::settingsFilePath()
{
#ifdef Q_OS_WIN
    return "HKEY_CURRENT_USER\\Software";
#else //Q_OS_MACreturn
    return QDir(QStandardPaths::standardLocations(QStandardPaths::ConfigLocation)[0]).absoluteFilePath("beautyfinder.plist");
#endif
}

bool Settings::isKeyExistedInSettingFile(const QString& group, const QString &key)
{
    QSettings appSetting(settingsFilePath(), QSettings::NativeFormat);
    appSetting.beginGroup(group);
    const bool exist = appSetting.contains(key);
    appSetting.endGroup();
    return exist;
}

void Settings::writeConfigToSettingFile(const QString& group, const QString &key, const QString &value)
{
    QSettings appSetting(settingsFilePath(), QSettings::NativeFormat);
    appSetting.beginGroup(group);
    appSetting.setValue(key, value);
    appSetting.endGroup();
}

QString Settings::readConfigFromSettingFile(const QString& group, const QString &key)
{
    QSettings appSetting(settingsFilePath(), QSettings::NativeFormat);
    appSetting.beginGroup(group);
    const QString value = appSetting.value(key).toString();
    appSetting.endGroup();

    return value;
}
