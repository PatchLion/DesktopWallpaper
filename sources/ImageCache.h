#ifndef IMAGECACHE_H
#define IMAGECACHE_H

#include <QObject>

class ImageCache : public QObject
{
    Q_OBJECT
public:
    explicit ImageCache(QObject *parent = nullptr);

private:
};

#endif // IMAGECACHE_H
