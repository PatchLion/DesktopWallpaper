INCLUDEPATH += ../sources \
    ../sources/aes

HEADERS += ../sources/APIRequestEx.h\
    ../sources/Functions.h \
    ../sources/Settings.h \
    ../sources/APIRequestPrivate.h

SOURCES += ../sources/APIRequestEx.cpp \
    ../sources/main_admin.cpp \
    ../sources/Functions.cpp \
    ../sources/Settings.cpp \
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


RESOURCES += ../resources/qml_admin.qrc

DISTFILES +=
