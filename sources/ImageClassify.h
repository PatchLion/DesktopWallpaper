#ifndef IMAGECLASSIFY_H
#define IMAGECLASSIFY_H

#include <QtCore>
#include "Caches.h"

class ImageClassify : public QObject
{
    Q_OBJECT

public:
    explicit ImageClassify(QObject *parent = nullptr);

public:
    Q_INVOKABLE QByteArray classifies();

private:
    static QString requestUrl();

private:
    Caches m_cache;
};

#endif // IMAGECLASSIFY_H
