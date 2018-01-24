echo off
cls
set QTDIR=C:\Qt\Qt5.9.2\5.9.2\msvc2015\bin
mkdir vs2015
xcopy /Y /F DesktopWallpaper.pro .\vs2015\DesktopWallpaper.pro <F
cd vs2015
%QTDIR%\qmake.exe -tp vc DesktopWallpaper.pro
rm DesktopWallpaper.pro
cd ..