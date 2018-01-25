INCLUDEPATH += ../sources \
    ../sources/aes

HEADERS += ../sources/APIRequestEx.h\
    ../sources/WallpaperSetter.h \
    ../sources/DownloadBox.h \
    ../sources/UserManager.h \
    ../sources/Settings.h \
    ../sources/aes/aes.h \
    ../sources/Functions.h \
    ../sources/aes/qaeswrap.h \
    ../sources/VersionDefine.h \
    ../sources/APIRequestPrivate.h

SOURCES += ../sources/APIRequestEx.cpp \
    ../sources/main.cpp \
    ../sources/WallpaperSetter.cpp \
    ../sources/UserManager.cpp \
    ../sources/DownloadBox.cpp \
    ../sources/Settings.cpp\
    ../sources/Functions.cpp \
    ../sources/aes/aes.c \
    ../sources/aes/qaeswrap.cpp \
    ../sources/APIRequestPrivate.cpp

win32{
    LIBS += User32.lib
}

macx{
    OBJECTIVE_SOURCES += ../sources/mac/WallpaperSetter_mac.mm
    QMAKE_LFLAGS += -framework AppKit
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.13
    QMAKE_MAC_SDK=macosx10.13
}


RESOURCES += ../resources/qml.qrc
