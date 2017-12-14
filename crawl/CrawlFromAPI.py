#! /usr/bin/env python
# -*- coding: utf-8 -*-

import time, os, json
import requests
import sqlalchemy

appID = "52155"; #壁纸
key = "5244ffe2f59349988f42d9df39ebe0e9"; #秘钥
imageClassifyUrl = "http://route.showapi.com/852-1"; #图片分类查询Api
imagesUrl = "http://route.showapi.com/852-2"; #图片查询Api


#图片分类URL
def classifiesUrl():
    return imageClassifyUrl + "?showapi_appid=" + appID + "&showapi_sign="+key

#图片获取URL
def imagesRequestUrl(type, page):
    return imagesUrl + "?showapi_appid=" + appID + "&showapi_sign="+key +"&type="+str(type) + "&page="+str(page)

print(classifiesUrl())
print(imagesRequestUrl(4008, 1))


record_file_name = "classifies_{0}.json"
def todayRecordFileName():
    return record_file_name.format(time.strftime("%Y%m%d", time.localtime()))

def craw():
    classifies_data = ""
    # 判断图片分类记录文件是否存在
    if not os.path.exists("records"):
        os.mkdir("records")

    record_file = "records/" + todayRecordFileName()
    if not os.path.exists(record_file):
        print("没有找到今日图片分类数据！开始获取图片分类数据...")
        classifies_req = requests.get(classifiesUrl())
        print(classifies_req.status_code)

        if (classifies_req.status_code == 200):
            with open(record_file, "wb") as f:
                print("以获取图片分类数据，保存到本地")
                classifies_data = classifies_req.content
                f.write(classifies_data)

        else:
            print("请求图片分类数据失败！错误码:", classifies_req.status_code)
            return

    else:
        print("读取本地图片分类文件！")
        with open(record_file, "r", encoding="utf-8") as f:
            classifies_data = f.read()

    #print(classifies_data)
    json_obj = json.loads(classifies_data, encoding="utf-8")
    #print(json_obj)
    list_data = json_obj["showapi_res_body"]["list"]
    #print(list_data)

    #获取所有分类
    classifies = {}
    for types in list_data:
        for data in types["list"]:
            classifies[data["id"]] = data["name"]

    print(classifies)



if "__main__" == __name__:
    #print(todayRecordFileName())
    craw()