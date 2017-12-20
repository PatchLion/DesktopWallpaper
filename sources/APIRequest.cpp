#include "APIRequest.h"
#include "common.h"

#define RequestTypeRole "RequestTypeRole"
#define RequestArgsRole "RequestArgsRole"


APIRequest::MapUrlToLocal APIRequest::g_downloadInfo = APIRequest::MapUrlToLocal();
APIRequest::APIRequest(QObject *parent)
    : QObject(parent)
{

}

void APIRequest::requestClassifiesData()
{
    doRequest(RequestType_Classifies);
}

/*
void APIRequest::requestItemsData()
{
    doRequest(RequestType_Items);
}
*/

void APIRequest::requestItemsByClassifyID(int classifyID, int pageindex)
{
    QVariantList args;
    args<<classifyID;
    args<<pageindex;
    qDebug() << "Request items by classify and pageindex:" << classifyID << " " << pageindex;
    doRequest(RequestType_ItemsByClassifyID, args);
}

void APIRequest::requestItemsDetailData(int itemID)
{
    QVariantList args;
    args<<itemID;
    doRequest(RequestType_ItemDetail, args);
}

void APIRequest::startDownload(const QString &url, const QString &destDir)
{
    if(url.isEmpty())
    {
        Q_EMIT downloadError(url, "Url is empty!");
        return;
    }

    if(g_downloadInfo.contains(url))
    {
        Q_EMIT downloadError(url, "Already downloading...");
        return;
    }
    else
    {
        QVariantList args;
        args<<url;
        doRequest(RequestType_Download, args);
        g_downloadInfo[url] = destDir;
    }
}

QString APIRequest::refererUrl() const
{
    return kDefaultHost + kAPISafe;
}

void APIRequest::doRequest(RequestType requestType, const QVariantList &args)
{

    QString url = kDefaultHost;

    switch (requestType)
    {
    case RequestType_Classifies:
    {
        url += kAPIClassifies;
    }
        break;

    /*
    case RequestType_Items:
    {
        url += kAPIItems;
    }
        break;
    */

    case RequestType_ItemDetail:
    {
        Q_ASSERT(args.size() == 1);
        Q_ASSERT(args[0].isValid());
        url += kAPIItemsDetails.arg(args[0].toInt());
    }
        break;

    case RequestType_Download:
    {
        Q_ASSERT(args.size() == 1);
        Q_ASSERT(args[0].isValid());
        url = args[0].toString();
    }
        break;

    case RequestType_ItemsByClassifyID:
    {
        Q_ASSERT(args.size() == 2);
        Q_ASSERT(args[0].isValid());
        Q_ASSERT(args[1].isValid());
        url += kAPIItemsByClassifyIDAndPageIndex.arg(args[0].toInt()).arg(args[1].toInt());
    }
        break;
    default:
    {
        Q_ASSERT(false);
    }
        break;
    }

    QNetworkRequest request(url);
    //request.setRawHeader("Referer", "http://www.mzitu.com/");
    QNetworkReply* reply = m_network.get(request);

    reply->setProperty(RequestTypeRole, requestType);
    reply->setProperty(RequestArgsRole, args);

    connect(reply, SIGNAL(finished()), this, SLOT(onReplyFinished()));

    reply->setParent(this);
}


void APIRequest::onReplyFinished()
{
    QNetworkReply *reply = dynamic_cast<QNetworkReply*>(sender());

    if(reply)
    {
        const int requestType = reply->property(RequestTypeRole).toInt();
        const QVariantList args = reply->property(RequestArgsRole).value<QVariantList>();

        QNetworkReply::NetworkError error = reply->error();

        const bool success = (error == QNetworkReply::NoError);
        const QByteArray data = reply->readAll();

        switch (requestType)
        {
        case RequestType_Classifies:
        {
            if(success)
            {
                Q_EMIT classifiesResponse(data);
            }
            else
            {
                Q_EMIT apiRequestError(kAPIClassifies, error);
            }
        }
            break;

        /*
        case RequestType_Items:
        {
            if(success)
            {
                Q_EMIT itemsResponse(data);

            }
            else
            {
                Q_EMIT apiRequestError(kAPIItems, error);

            }
        }
            break;
        */

        case RequestType_ItemDetail:
        {
            Q_ASSERT(args.size() == 1);
            Q_ASSERT(args[0].isValid());
            if(success)
            {
                Q_EMIT itemsDetailResponse(args[0].toInt(), data);
            }
            else
            {

                Q_EMIT apiRequestError(kAPIItemsDetails.arg(args[0].toInt()), error);
            }
        }
            break;
        case RequestType_ItemsByClassifyID:
        {
            Q_ASSERT(args.size() == 2);
            Q_ASSERT(args[0].isValid());
            Q_ASSERT(args[1].isValid());
            if(success)
            {
                Q_EMIT itemsByClassifyIDResponse(args[0].toInt(), args[1].toInt(),data);
            }
            else
            {

                Q_EMIT apiRequestError(kAPIItemsByClassifyIDAndPageIndex.arg(args[0].toInt()).arg(args[1].toInt()), error);
            }
        }
            break;
        case RequestType_Download:
        {
            Q_ASSERT(args.size() == 1);
            Q_ASSERT(args[0].isValid());
            if(success)
            {
                QString url = args[0].toString();
                if(g_downloadInfo.contains(url))
                {
                    qDebug() << "Download finished: " << url << " data length: " << data.count();

                    const QString dest = g_downloadInfo[url];

                    const QString tempDest = QUrl(dest).toLocalFile();
                    QFileInfo fileInfo(tempDest);
                    if(!fileInfo.absoluteDir().exists())
                    {
                        qDebug() << "Make path: " << fileInfo.absolutePath();
                        fileInfo.absoluteDir().mkpath(fileInfo.absolutePath());
                    }

                    QFile file(tempDest);
                    if(file.open(QIODevice::WriteOnly))
                    {
                        file.write(data);
                        file.close();

                        Q_EMIT downloadFinished(url);
                    }
                    else
                    {
                        const QString msg = "Failed to write to file: " + tempDest + "! reason: " + file.errorString();
                        qWarning() <<msg;
                        Q_EMIT downloadError(url, msg);
                    }
                }
            }
            else
            {
                Q_EMIT downloadError(args[0].toString(), "Failed to download! Error code:" + error);

            }
        }
            break;

        default:
        {
            Q_ASSERT(false);
        }
            break;
        }

    }
}

