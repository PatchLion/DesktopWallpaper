QT += quick network
CONFIG += c++11
TEMPLATE = app
CONFIG -= flat


INCLUDEPATH += ./sources ./sources/aes

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += ./sources/APIRequestEx.h\
    ./sources/WallpaperSetter.h \
    sources/UserManager.h \
    sources/Settings.h \
    sources/aes/aes.h \
    sources/aes/qaeswrap.h \
    sources/APIRequestPrivate.h
SOURCES += ./sources/APIRequestEx.cpp  main.cpp \
    ./sources/WallpaperSetter.cpp \
    sources/UserManager.cpp \
    sources/Settings.cpp\
    sources/aes/aes.c \
    sources/aes/qaeswrap.cpp \
    sources/APIRequestPrivate.cpp
win32{
    LIBS += User32.lib
}

macx{
    OBJECTIVE_SOURCES += ./sources/mac/WallpaperSetter_mac.mm
    QMAKE_LFLAGS += -framework AppKit
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.13
    QMAKE_MAC_SDK=macosx10.13
}


RESOURCES += ./resources/qml.qrc #qmlcommon/qmlcommon.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES +=
