#include "wallpaper.h"

#ifdef Q_OS_WIN
#include <windows.h>
#include <shlobj.h>
#include <wininet.h>

QString WallpaperSetter::doImageToDesktop(const QString &localfile, WallpaperSetter::Mode mode)
{
    //if (argc > 1) {
        //wchar_t fullPath = reinterpret_cast<wchar_t *>(localfile.utf16());

        if (!QFile().exists(localfile)) {
            //fputs("Invalid path", stderr);
            return QString::fromLocal8Bit("无效的路径: %1").arg(localfile);
        }

        if (!SystemParametersInfoW(SPI_SETDESKWALLPAPER, 0, (TCHAR *)localfile.toStdWString().c_str(), SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE)) {
            fputs("Failed to set the desktop wallpaper", stderr);
            return QString::fromLocal8Bit("设置壁纸失败!");
        }
    /*} else {
        wchar_t imagePath[MAX_PATH];

        if (SystemParametersInfoW(SPI_GETDESKWALLPAPER, MAX_PATH, imagePath, 0)) {
            _setmode(_fileno(stdout), _O_U8TEXT);
            wprintf(L"%s\n", imagePath);
        } else {
            fputs("Failed to get the desktop wallpaper", stderr);
            return 1;
        }
    }
*/

    return "";
}

#endif
