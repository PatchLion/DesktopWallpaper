#ifndef COMMON_H
#define COMMON_H

#include <QString>

static const QString kDefaultHost = "http://www.patchlion.cn:5000";
static const QString kDefaultLoginHost = "http://www.patchlion.cn:8200";
//static const QString kAPIHost = "/host"; //查询主机API
static const QString kAPIClassifies = "/classifies"; //图片分类查询API
static const QString kAPIItemsByClassifyAndPageIndex = "/classifies/%1/%2"; //图片分类分页查询API
//static const QString kAPIItems = "/items"; //图片分组列表API
static const QString kAPIItemsDetails = "/items/%1"; //图片分组详情API
//static const QString kAPISafe = "/safe?url="; //反防盗链
static const QString kAPISearch = "/search?key=%1"; //搜索
static const QString kAPILogin = "/login"; //登录
static const QString kAPIRegister = "/register"; //注册
static const QString kAPITokenCheck = "/tokencheck"; //token校验
static const QString kAPIAddPefer = "/addpefer"; //添加收藏

#endif // COMMON_H
