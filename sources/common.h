#ifndef COMMON_H
#define COMMON_H

#include <QString>

static const QString kDefaultHost = "http://www.patchlion.cn";
//static const QString kAPIHost = "/host"; //查询主机API
static const QString kAPIClassifies = "/classifies"; //图片分类查询API
static const QString kAPIItemsByClassifyIDAndPageIndex = "/classifies/%1/%2"; //图片分类分页查询API
//static const QString kAPIItems = "/items"; //图片分组列表API
static const QString kAPIItemsDetails = "/items/%1"; //图片分组详情API
static const QString kAPISafe = "/safe?url="; //反防盗链

#endif // COMMON_H
