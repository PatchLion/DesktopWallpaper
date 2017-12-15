#include "Caches.h"
#include <QtCore>

static const char* kCacheDir = "cache_%1";
static const char* kRecordeFileName = "classifies.json"; //分类json

Caches::MapCache Caches::g_pageCache = Caches::MapCache();
QByteArray Caches::g_classifiesCache = "";

Caches::Caches(QObject *parent)
    : QObject(parent)
{
    if(g_classifiesCache.isEmpty())
    {
        const QString classifyPath = cacheDirName() +"/"+kRecordeFileName;
        QFile file(classifyPath);
        if(file.open(QIODevice::ReadOnly))
        {
            g_classifiesCache = file.readAll();
        }
    }
}

QByteArray Caches::classifiesCache() const
{
    return g_classifiesCache;
}

void Caches::setClassifiesCache(const QByteArray &classifiesCache)
{
    g_classifiesCache = classifiesCache;


    qDebug() << "Add classify cache!";

    if(!QDir().exists(cacheDirName()))
    {
        QDir().mkdir(cacheDirName());
    }

    const QString classifyPath = cacheDirName()+"/"+kRecordeFileName;
    QFile file(classifyPath);
    if(file.open(QIODevice::WriteOnly))
    {
        file.write(classifiesCache);
    }
}

QByteArray Caches::pageCache(int classify, int page)
{
    const QString key = makePageKey(classify, page);

    if(g_pageCache.contains(key))
    {
        return g_pageCache[key];
    }



    const QString pagePath = cacheDirName()+"/"+pageCacheFileName(classify, page);

    if(QDir().exists(pagePath))
    {
        QFile file(pagePath);
        if(file.open(QIODevice::ReadOnly))
        {
            const QByteArray data = file.readAll();
            if(!data.isEmpty())
            {
                g_pageCache[key] = data;

                return data;
            }
        }

    }


    return "";
}

void Caches::setPageCache(int classify, int page, const QByteArray &cache)
{
    if(!cache.isEmpty())
    {
        qDebug() << "Add page cache (classify:" << classify << ",page:" << page << ")";
        const QString key = makePageKey(classify, page);

        g_pageCache[key] = cache;


        if(!QDir().exists(cacheDirName()))
        {
            QDir().mkdir(cacheDirName());
        }

        const QString pagePath = cacheDirName()+"/"+pageCacheFileName(classify, page);
        QFile file(pagePath);
        if(file.open(QIODevice::WriteOnly))
        {
            file.write(cache);
        }
    }
}

QString Caches::cacheDirName()
{
    QDateTime dt = QDateTime::currentDateTime();
    const QString dtstring = dt.toString("yyyyMMdd");

    return QString(kCacheDir).arg(dtstring);
}

QString Caches::makePageKey(int classify, int page)
{
    return QString("%1_%2").arg(classify).arg(page);
}

QString Caches::pageCacheFileName(int classify, int page)
{
    return QString("page_%1.json").arg(makePageKey(classify, page));
}
