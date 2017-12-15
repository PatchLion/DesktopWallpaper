#ifndef CACHES_H
#define CACHES_H

#include <QObject>

class Caches : public QObject
{
    Q_OBJECT
private:
    typedef QMap<QString, QByteArray> MapCache;

public:
    explicit Caches(QObject *parent = nullptr);

public:
    //分类缓存
    QByteArray classifiesCache() const;
    void setClassifiesCache(const QByteArray &classifiesCache);

    //页面缓存
    QByteArray pageCache(int classify, int page);
    void setPageCache(int classify, int page, const QByteArray& cache);

private:
    //分类缓存文件名称
    static QString cacheDirName();

    //
    static QString makePageKey(int classify, int page);

    //
    static QString pageCacheFileName(int classify, int page);


private:
    static QByteArray g_classifiesCache; //分类信息缓存
    static MapCache g_pageCache; //页面缓存
};

#endif // CACHES_H
