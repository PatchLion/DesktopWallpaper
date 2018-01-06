//
//  wallpaper.m
//  wallpaper
//
//  Copyright © Sindre Sorhus
//
#include "Functions.h"
//@import AppKit;
//#import <sqlite3.h>
#import <Cocoa/Cocoa.h>
#include <QtNetwork>

const static char* kDirName = "beautyfinder";

QString dirPath(){
    return QStandardPaths::standardLocations(QStandardPaths::PicturesLocation)[0] + "/" + kDirName;
}

Functions::~Functions()
{
    if(m_loop)
    {
        m_loop->quit();
    }
}

void Functions::setImageToDesktop(const QString& url, Mode mode) {
    if(url.isEmpty())
    {
        Q_EMIT finished(false, QString::fromLocal8Bit("无效的Url"));
    }

    const QString fullpath = dirPath() + "/" + url.toUtf8().toBase64() + ".png";


    if (QFile().exists(fullpath)){
        const QString res = doImageToDesktop(fullpath, mode);

        if(res.isEmpty()){
            Q_EMIT finished(true, "");
        }
        else{
            Q_EMIT finished(false, res);
        }

        return;
    }

    QNetworkAccessManager network;
    QNetworkReply* reply = network.get(QNetworkRequest(url));

    QEventLoop loop;
    Functions* object = this;
    connect(reply, &QNetworkReply::downloadProgress, [=, &object](qint64 bytesReceived, qint64 bytesTotal){
        Q_EMIT object->progress((double)bytesReceived/(double)bytesTotal, QString::fromLocal8Bit("壁纸下载中"));
    } );

    connect(reply, &QNetworkReply::finished, [=, &loop, &reply, &object](){
        if (!QDir().exists(dirPath())){
            QDir().mkpath(dirPath());
        }

        const QNetworkReply::NetworkError error = reply->error();
        if(error == QNetworkReply::NoError){
            const QByteArray data = reply->readAll();

           QFile file(fullpath);

           if(file.open(QIODevice::WriteOnly))
           {
               file.write(data);
               file.close();

               Q_EMIT object->progress(1.0, QString::fromLocal8Bit("壁纸设置中..."));
                const QString res = doImageToDesktop(fullpath, mode);

                if(res.isEmpty()){
                    Q_EMIT finished(true, "");
                    Q_EMIT object->progress(1.0, QString::fromLocal8Bit("壁纸设置完成"));
                }
                else{
                    Q_EMIT finished(false, res);
                }
           }
           else{
               Q_EMIT finished(false, QString::fromLocal8Bit("写入文件到:")+fullpath+QString::fromLocal8Bit("时发生异常! 异常提示:")+file.errorString());
           }
        }
        else{
            Q_EMIT finished(false, QString::fromLocal8Bit("网络请求出现异常，错误代码:%1").arg(error));
        }

        m_loop = 0;
        loop.quit();
    });

    m_loop = &loop;
    loop.exec();
}

QString Functions::doImageToDesktop(const QString &localfile, Functions::Mode mode)
{
    @autoreleasepool {
            NSWorkspace *sw = [NSWorkspace sharedWorkspace];
            //NSArray *args = [NSProcessInfo processInfo].arguments;
            NSScreen *screen = [NSScreen screens].firstObject;
            NSMutableDictionary *so = [[sw desktopImageOptionsForScreen:screen] mutableCopy];
/*
            if (args.count > 1) {
                    if ([args[1] isEqualToString: @"--version"]) {
                            puts("1.3.0");
                            return 0;
                    }

                    if ([args[1] isEqualToString: @"--help"]) {
                            puts("\n  Get or set the desktop wallpaper\n\n  Usage: wallpaper [file] [scale]\n\n  `scale` can be either: fill fit stretch center\n  If not specified, it will use your current setting\n\n  Created by Sindre Sorhus");
                            return 0;
                    }
*/
                    //if (args.count > 2) {
                            //if ([args[2] isEqualToString: @"fill"]) {
                            if(Fill == mode){
                                    [so setObject:[NSNumber numberWithInt:NSImageScaleProportionallyUpOrDown] forKey:NSWorkspaceDesktopImageScalingKey];
                                    [so setObject:[NSNumber numberWithBool:YES] forKey:NSWorkspaceDesktopImageAllowClippingKey];
                            }
                            else if(Fit == mode){
                            //if ([args[2] isEqualToString: @"fit"]) {
                                    [so setObject:[NSNumber numberWithInt:NSImageScaleProportionallyUpOrDown] forKey:NSWorkspaceDesktopImageScalingKey];
                                    [so setObject:[NSNumber numberWithBool:NO] forKey:NSWorkspaceDesktopImageAllowClippingKey];
                            }
                            else if(Stretch == mode){
                            //if ([args[2] isEqualToString: @"stretch"]) {
                                    [so setObject:[NSNumber numberWithInt:NSImageScaleAxesIndependently] forKey:NSWorkspaceDesktopImageScalingKey];
                                    [so setObject:[NSNumber numberWithBool:YES] forKey:NSWorkspaceDesktopImageAllowClippingKey];
                            }
                            else if(Center == mode){
                            //if ([args[2] isEqualToString: @"center"]) {
                                    [so setObject:[NSNumber numberWithInt:NSImageScaleNone] forKey:NSWorkspaceDesktopImageScalingKey];
                                    [so setObject:[NSNumber numberWithBool:NO] forKey:NSWorkspaceDesktopImageAllowClippingKey];
                            }
    //		}

                    NSError *err;

                    bool success = [sw
                            setDesktopImageURL:[NSURL fileURLWithPath:localfile.toNSString()]
                            forScreen:screen
                            options:so
                            error:&err];

                    if (!success) {
                            fprintf(stderr, "%s\n", err.localizedDescription.UTF8String);
                            return QString::fromUtf8(err.localizedDescription.UTF8String);
                    }
                    /*
            } else {
                    NSString *path = [sw desktopImageURLForScreen:screen].path;
                    BOOL isDir;
                    NSFileManager *fm = [NSFileManager defaultManager];

                    // Check if file is a directory
                    [fm fileExistsAtPath:path isDirectory:&isDir];

                    // If directory, check database
                    if (isDir) {
                            NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
                            NSString *dbPath = [dirs[0] stringByAppendingPathComponent:@"Dock/desktoppicture.db"];
                            sqlite3 *db;

                            if (sqlite3_open(dbPath.UTF8String, &db) == SQLITE_OK) {
                                    sqlite3_stmt *statement;
                                    const char *sql = "SELECT * FROM data";

                                    if (sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK) {
                                            NSString *file;
                                            while (sqlite3_step(statement) == SQLITE_ROW) {
                                                    file = @((char *)sqlite3_column_text(statement, 0));
                                            }

                                            printf("%s/%s\n", path.UTF8String, file.UTF8String);
                                            sqlite3_finalize(statement);
                                    }

                                    sqlite3_close(db);
                            }
                    } else {
                            printf("%s\n", path.UTF8String);
                    }
            }
    }

    return 0;*/
                    return "";
    }
}
