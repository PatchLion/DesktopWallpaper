#ifndef APIREQUESTEX_H
#define APIREQUESTEX_H

#include <QtCore>
#include <QtNetwork>


static const QString kImagesHost = "http://www.patchlion.cn:5000";
static const QString kAuthHost = "http://www.patchlion.cn:8200";
static const QString kAPIClassifies =  kImagesHost + "/api/classifies"; //图片分类查询API
static const QString kAPICacheVersion = kImagesHost + "/api/cacheversion"; //缓存版本号
static const QString kAPIPage = kImagesHost + "/api/page"; //图片分类分页
static const QString kAPIItem = kImagesHost + "/api/item"; //图片分组
static const QString kAPISearch = kImagesHost + "/api/search"; //搜索
static const QString kAPILogin = kAuthHost + "/api/login"; //登录
static const QString kAPIRegister = kAuthHost + "/api/register"; //注册
static const QString kAPITokenCheck = kAuthHost + "/api/tokencheck"; //token校验
static const QString kAPIAddPefer = kAuthHost + "/api/addpefer"; //添加个人收藏
static const QString kAPIGetPefer = kAuthHost + "/api/getpefer"; //获取个人收藏


class APIRequestEX : public QObject
{
    Q_OBJECT
public:
    //获取分类数据
    Q_INVOKABLE static void classifiesRequest(Functor functor) ;

    //获取分类下的所有分组
    Q_INVOKABLE static void pageRequest(const QString& classify, int pageindex, Functor functor);

    //获取单个图片分组数据
    Q_INVOKABLE static void itemRequest(const QString& itemID, Functor functor);

    //搜索关键词
    Q_INVOKABLE static void searchRequest(const QString& key, Functor functor);

    //发起登录请求
    Q_INVOKABLE static void loginRequest(const QString& user, const QString& pwd, Functor functor);

    //发起注册请求
    Q_INVOKABLE static void regeisterRequest(const QString& user, const QString& pwd, const QString& nickname, Functor functor);

    //发起token校验请求
    Q_INVOKABLE static void checkTokenRequest(const QString& token, Functor functor);

    //尝试收藏图片
    Q_INVOKABLE static void addPeferRequest(const QString& token, const QList<int>& imageids, Functor functor);

    //尝试收藏图片
    Q_INVOKABLE static void getPefersRequest(const QString& toke, Functor functorn);

private:
    //发起api请求
    static void post(const QString& apiurl, const QString& param, Functor functor);

private:
    static QNetworkAccessManager *network();

private:
    static QNetworkAccessManager *g_network; //网络对象
};

#endif // APIREQUESTEX_H
