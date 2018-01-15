#include "APIRequest.h"
#include "common.h"

#define RequestTypeRole "RequestTypeRole"
#define RequestArgsRole "RequestArgsRole"


APIRequest::MapDownloadPictureGroup APIRequest::g_imageGroupDownloadInfos = APIRequest::MapDownloadPictureGroup();
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

void APIRequest::requestItemsByClassify(const QString& classify, int pageindex)
{
    QVariantList args;
    args<<classify;
    args<<pageindex;
    //qDebug() << "Request items by classify and pageindex:" << classify << " " << pageindex;
    doRequest(RequestType_ItemsByClassify, args);
}

void APIRequest::requestItemsDetailData(const QString& itemID)
{
    QVariantList args;
    args<<itemID;
    doRequest(RequestType_ItemDetail, args);
}

void APIRequest::searchKeyWord(const QString &key)
{
    QVariantList args;
    args<<key;
    doRequest(RequestType_Search, args);
}
/*
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
*/
QString buildKey(const QString& savePath, const QString& name)
{
    const QString& absDir = QUrl(savePath).toLocalFile();

    const QString& key = name + "<>" + absDir;

    return key.toLocal8Bit().toBase64().data();
}
QString urlToFileName(const QString& url)
{
    return QString("%1.jpg").arg(url.toLocal8Bit().toBase64().data());
}
QString APIRequest::addDownload(const QString &savePath, const QString &name, const QStringList &urls)
{
    qDebug() << savePath << " " << name << " " << urls.length();
    if(savePath.isEmpty() || name.isEmpty() || urls.isEmpty())
    {
        qWarning() << QString::fromLocal8Bit("APIRequest::addDownload 参数无效!");
        return "";
    }

    const QString& key = buildKey(savePath, name);
    if(!g_imageGroupDownloadInfos.contains(key)){
        //
        stImageGroupDownloadInfo downloadInfo;
        downloadInfo.savePath = QUrl(savePath).toLocalFile() + "/" + name;
        Q_FOREACH(QString url, urls)
        {
            const QString& filename = urlToFileName(url);
            const QString& fullpath = QDir(downloadInfo.savePath).absoluteFilePath(filename);
            QFileInfo fileInfo(fullpath);
            if(fileInfo.exists() && fileInfo.size() > 0)
            {
                downloadInfo.downloads[fullpath] = Downloaded;
            }
            else
            {
                downloadInfo.downloads[fullpath] = Downloading;

                QVariantList args;
                args << key;
                args << url;
                args << fullpath;
                doRequest(RequestType_Download, args);
            }
        }

        g_imageGroupDownloadInfos[key] = downloadInfo;
    }

    Q_EMIT downloadingCountChanged(getDownloadingCount());

    Q_EMIT downloadInfosChanged(buildDownloadInfo());
    //Q_EMIT downloadingCountChanged(20);

    return key;
}
/*
QString APIRequest::refererUrl()
{
    return kDefaultHost + kAPISafe;
}
*/
void APIRequest::doRequest(RequestType requestType, const QVariantList &args, bool post)
{
    //qDebug() << "--->" << requestType << " " << args << " " << post;

    QString url;

    QString post_param = "";

    switch (requestType)
    {
    case RequestType_Classifies:
    {
        url = kDefaultHost + kAPIClassifies;
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
        url = kDefaultHost + kAPIItemsDetails.arg(args[0].toString());
    }
        break;

    case RequestType_Download:
    {
        Q_ASSERT(args.size() == 3);
        Q_ASSERT(args[0].isValid()); //key
        Q_ASSERT(args[1].isValid()); //url
        Q_ASSERT(args[2].isValid()); //fullpath
        url = args[1].toString();
    }
        break;

    case RequestType_Search:
    {
        Q_ASSERT(args.size() == 1);
        Q_ASSERT(args[0].isValid());
        url = kDefaultHost + kAPISearch.arg(QUrl::toPercentEncoding(args[0].toString()).data());
    }
        break;
    case RequestType_ItemsByClassify:
    {
        Q_ASSERT(args.size() == 2);
        Q_ASSERT(args[0].isValid());
        Q_ASSERT(args[1].isValid());
        url = kDefaultHost + kAPIItemsByClassifyAndPageIndex.arg(args[0].toString()).arg(args[1].toInt());
    }
        break;
    case RequestTpye_Login:
    {
        Q_ASSERT(args.size() == 2);
        Q_ASSERT(args[0].isValid());
        Q_ASSERT(args[1].isValid());

        QVariantMap map;
        map.insert("user", args[0]);
        map.insert("password", args[1]);
        QJsonDocument doc = QJsonDocument::fromVariant(map);
        post_param = doc.toJson();
        url = kDefaultLoginHost + kAPILogin;
    }
        break;
    case RequestTpye_Regeister:
    {
        Q_ASSERT(args.size() == 3);
        Q_ASSERT(args[0].isValid());
        Q_ASSERT(args[1].isValid());
        Q_ASSERT(args[2].isValid());

        QVariantMap map;
        map.insert("user", args[0]);
        map.insert("password", args[1]);
        if (args[2].toString().size() > 0)
        {
            map.insert("nickname", args[2]);
        }
        QJsonDocument doc = QJsonDocument::fromVariant(map);
        post_param = doc.toJson();
        url = kDefaultLoginHost + kAPIRegister;
    }
        break;
    case RequestTpye_CheckToken:
    {
        Q_ASSERT(args.size() == 1);
        Q_ASSERT(args[0].isValid());

        QVariantMap map;
        map.insert("token", args[0]);
        QJsonDocument doc = QJsonDocument::fromVariant(map);
        post_param = doc.toJson();
        url = kDefaultLoginHost + kAPITokenCheck;
    }
        break;

    case RequestTpye_AddPefer:
    {
        Q_ASSERT(args.size() == 2);
        Q_ASSERT(args[0].isValid());
        Q_ASSERT(args[1].isValid());

        QVariantMap map;
        map.insert("token", args[0]);

        QString ids;
        QList<int> listIDs = args[1].value<QList<int>>();
        if(listIDs.size() > 0)
        {
            ids = QString::number(listIDs[0]);

            for(int i = 1; i<listIDs.size();i++){
                ids+=",";
                ids+=QString::number(listIDs[i]);
            }
        }

        qDebug() << "Add pefer:" << ids;
        map.insert("imageids", ids);
        QJsonDocument doc = QJsonDocument::fromVariant(map);
        post_param = doc.toJson();
        url = kDefaultLoginHost + kAPIAddPefer;
    }
        break;
    default:
    {
        Q_ASSERT(false);
    }
        break;
    }

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    //request.setRawHeader("Referer", "http://www.mzitu.com/");

    QNetworkReply* reply = 0;
    if(post)
    {
        reply = m_network.post(request, post_param.toUtf8());

    }
    else
    {
        reply = m_network.get(request);
    }

    reply->setProperty(RequestTypeRole, requestType);
    reply->setProperty(RequestArgsRole, args);

    connect(reply, SIGNAL(finished()), this, SLOT(onReplyFinished()));

    reply->setParent(this);
}

int APIRequest::getDownloadingCount()
{
    //return 20;
    int downloading = 0;
    MapDownloadPictureGroup::const_iterator groupItor = g_imageGroupDownloadInfos.begin();

    for(groupItor; g_imageGroupDownloadInfos.end() != groupItor; groupItor++)
    {
        MapDownloadState::const_iterator downloadItor = groupItor.value().downloads.begin();

        for(downloadItor; groupItor.value().downloads.end()!=downloadItor; downloadItor++)
        {
            if(downloadItor.value() == Downloading)
            {
                downloading++;
                break;
            }
        }
    }

    return downloading;
}

QByteArray APIRequest::buildDownloadInfo()
{
    QVariantList downloadinfos;
    MapDownloadPictureGroup::const_iterator groupItor = g_imageGroupDownloadInfos.begin();

    for(groupItor; g_imageGroupDownloadInfos.end() != groupItor; groupItor++)
    {
        QVariantMap download;
        QString temp = QByteArray::fromBase64(groupItor.key().toLocal8Bit()).data();
        QString name = temp.split("<>")[0];
        download.insert("name", name);
        download.insert("path", groupItor.value().savePath);

        int downloading = 0, downloaded = 0, downloadFailed = 0;
        MapDownloadState::const_iterator downloadItor = groupItor.value().downloads.begin();
        for(downloadItor; groupItor.value().downloads.end()!=downloadItor; downloadItor++)
        {
            if(downloadItor.value() == Downloading)
            {
                downloading++;
            }
            else if(downloadItor.value() == Downloaded)
            {
                downloaded++;
            }
            else if(downloadItor.value() == DownloadFailed)
            {
                downloadFailed++;
            }
        }

        download.insert("downloading", downloading);
        download.insert("downloaded", downloaded);
        download.insert("downloadFailed", downloadFailed);

        if(downloading > 0)
        {
            downloadinfos << download;
        }
    }

    QString ret = "[]";
    QJsonDocument jsonDocument = QJsonDocument::fromVariant(downloadinfos);
    if (!jsonDocument.isNull()) {
        ret = jsonDocument.toJson(QJsonDocument::Compact);
    }
    //qDebug() << "Download info json --->" << ret;
    return ret.toLocal8Bit();
}

void APIRequest::tryToLogin(const QString &user, const QString &pwd)
{
    QVariantList args;
    args<<user;
    args<<pwd;
    //qDebug() << "Request items by classify and pageindex:" << classify << " " << pageindex;
    doRequest(RequestTpye_Login, args, true);
}

void APIRequest::tryToRegeister(const QString &user, const QString &pwd, const QString &nickname)
{
    QVariantList args;
    args<<user;
    args<<pwd;
    args<<nickname;
    doRequest(RequestTpye_Regeister, args, true);
}

void APIRequest::tryToCheckToken(const QString &token)
{
    QVariantList args;
    args<<token;
    doRequest(RequestTpye_CheckToken, args, true);
}

void APIRequest::tryToPefer(const QString &token, const QList<int>& imageids)
{
    QVariantList args;
    args<<token;
    args<<QVariant::fromValue(imageids);
    doRequest(RequestTpye_AddPefer, args, true);
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
                Q_EMIT itemsDetailResponse(args[0].toString(), data);
            }
            else
            {

                Q_EMIT apiRequestError(kAPIItemsDetails.arg(args[0].toString()), error);
            }
        }
            break;
        case RequestType_ItemsByClassify:
        {
            Q_ASSERT(args.size() == 2);
            Q_ASSERT(args[0].isValid());
            Q_ASSERT(args[1].isValid());
            if(success)
            {
                Q_EMIT itemsByClassifyResponse(args[0].toString(), args[1].toInt(),data);
            }
            else
            {

                Q_EMIT apiRequestError(kAPIItemsByClassifyAndPageIndex.arg(args[0].toString()).arg(args[1].toInt()), error);
            }
        }
            break;

        case RequestType_Search:
        {
            Q_ASSERT(args.size() == 1);
            Q_ASSERT(args[0].isValid());
            if(success)
            {
                //qDebug() << "Search result-->" <<data.data();
                Q_EMIT searchResponse(data);
            }
            else
            {

                Q_EMIT apiRequestError(kAPISearch.arg(args[0].toString().toUtf8().toBase64().data()), error);
            }
        }
            break;
       case RequestTpye_Login:
        {
            Q_ASSERT(args.size() == 2);
            Q_ASSERT(args[0].isValid());
            Q_ASSERT(args[1].isValid());
            if(success)
            {
                //qDebug() << "Search result-->" <<data.data();
                Q_EMIT loginFinished(data);
            }
            else
            {

                Q_EMIT apiRequestError(kAPILogin, error);
            }
        }
            break;
        case RequestTpye_AddPefer:
         {
             Q_ASSERT(args.size() == 2);
             Q_ASSERT(args[0].isValid());
             Q_ASSERT(args[1].isValid());
             if(success)
             {
                 //qDebug() << "Search result-->" <<data.data();
                 Q_EMIT addPeferFinished(data);
             }
             else
             {

                 Q_EMIT apiRequestError(kAPIAddPefer, error);
             }
         }
             break;
        case RequestTpye_Regeister:
        {
            Q_ASSERT(args.size() == 3);
            Q_ASSERT(args[0].isValid());
            Q_ASSERT(args[1].isValid());
            Q_ASSERT(args[2].isValid());
            if(success)
            {
                //qDebug() << "Search result-->" <<data.data();
                Q_EMIT registerFinished(data);
            }
            else
            {

                Q_EMIT apiRequestError(kAPIRegister, error);
            }
        }
            break;
        case RequestTpye_CheckToken:
        {
            Q_ASSERT(args.size() == 1);
            Q_ASSERT(args[0].isValid());
            if(success)
            {
                //qDebug() << "Search result-->" <<data.data();
                Q_EMIT tokenCheckFinished(data);
            }
            else
            {

                Q_EMIT apiRequestError(kAPITokenCheck, error);
            }
        }
            break;
        case RequestType_Download:
        {
            Q_ASSERT(args.size() == 3);
            Q_ASSERT(args[0].isValid()); //key
            Q_ASSERT(args[1].isValid()); //url
            Q_ASSERT(args[2].isValid()); //fullpath
            if(success)
            {
                QString key = args[0].toString();
                QString url = args[1].toString();
                QString fullpath = args[2].toString();
                if(!key.isEmpty() && g_imageGroupDownloadInfos.contains(key))
                {
                    //qDebug() << "Download finished: " << url << " data length: " << data.count();

                    stImageGroupDownloadInfo& downloadInfo = g_imageGroupDownloadInfos[key];

                    //const QString tempDest = QUrl(fullpath).toLocalFile();
                    QFileInfo fileInfo(fullpath);
                    if(!fileInfo.absoluteDir().exists())
                    {
                        //qDebug() << "Make path: " << fileInfo.absolutePath();
                        fileInfo.absoluteDir().mkpath(fileInfo.absolutePath());
                    }

                    QFile file(fullpath);
                    if(file.open(QIODevice::WriteOnly))
                    {
                        file.write(data);
                        file.close();

                        downloadInfo.downloads[fullpath] = Downloaded;

                    }
                    else
                    {

                        downloadInfo.downloads[fullpath] = DownloadFailed;

                        const QString msg = "Failed to write to file: " + fullpath + "! reason: " + file.errorString();
                        qWarning() <<msg;
                    }

                    int finished = 0, error = 0;

                    MapDownloadState::const_iterator downloadItor = downloadInfo.downloads.begin();

                    for(downloadItor; downloadInfo.downloads.end()!=downloadItor; downloadItor++)
                    {
                        if(downloadItor.value() == Downloaded)
                        {
                            finished++;
                        }
                        else if(downloadItor.value() == DownloadFailed)
                        {
                            error++;
                        }
                    }

                    Q_EMIT imageGroupDownloadProgress(key, downloadInfo.downloads.size(), finished, error);
                }
            }


            Q_EMIT downloadingCountChanged(getDownloadingCount());
            Q_EMIT downloadInfosChanged(buildDownloadInfo());
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

