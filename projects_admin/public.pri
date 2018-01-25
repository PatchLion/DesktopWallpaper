UI_DIR = ./temp/GeneratedFiles
RCC_DIR = ./temp/GeneratedFiles
MOC_DIR = ./temp/GeneratedFiles

INCLUDEPATH += ./temp/GeneratedFiles

macx{
    OBJECTS_DIR = ./temp
}

win32{
    OBJECTS_DIR = ./temp/$(Platform)/$(Configuration)

    CONFIG -= flat
}
