appname="DesktopWallpaper"
apppath="${BUILT_PRODUCTS_DIR}/${appname}.app"

#拷贝指定资源
rsync -vauP --exclude=".*" ../resources/fonts "${apppath}/Contents/Resources"
rsync -vauP --exclude=".*" ./Info.plist "${apppath}/Contents/Resources"

qtpath="${QTDIR}/"
qtbinpath="${qtpath}bin/"
qtlibpath="${qtpath}lib/"
frameworkpath="${apppath}/Contents/Frameworks/"
pluginpath="${apppath}/Contents/PlugIns/"
cert="Mac Developer: XiaoBing Dai (CP64KHZF34)"

#sudo rm -r -f "${frameworkpath}"
#sudo rm -r -f "${pluginpath}"

#Copy
${qtbinpath}macdeployqt "${apppath}" "-qmldir=${qtpath}qml/QtQuick"

#cp ${qtlibpath}QtCore.framework/Resources/Info.plist "${frameworkpath}QtCore.framework/Resources"

#cp ${qtlibpath}QtGui.framework/Resources/Info.plist "${frameworkpath}QtGui.framework/Resources"

#cp ${qtlibpath}QtNetwork.framework/Resources/Info.plist "${frameworkpath}QtNetwork.framework/Resources"

#cp ${qtlibpath}QtWidgets.framework/Resources/Info.plist "${frameworkpath}QtWidgets.framework/Resources"

#cp ${qtlibpath}QtQuick.framework/Resources/Info.plist "${frameworkpath}QtQuick.framework/Resources"
#cp ${qtlibpath}QtOpenGL.framework/Resources/Info.plist "${frameworkpath}QtOpenGL.framework/Resources"

#Adjust Dir
#python ${SRCROOT}/ChangeQt5FrameworkDir.py "${qtpath}" "${apppath}"

#CodeSign
codesign --deep --verbose --force --sign "${cert}" "${frameworkpath}"*.framework
codesign --deep --verbose --force --sign "${cert}" "${pluginpath}imageformats/"*
codesign --deep --verbose --force --sign "${cert}" "${pluginpath}platforms/"*
codesign --deep --verbose --force --sign "${cert}" "${pluginpath}bearer/"*
codesign --deep --verbose --force --sign "${cert}" "${pluginpath}iconengines/"*
codesign --deep --verbose --force --sign "${cert}" "${pluginpath}printsupport/"*
codesign --deep --verbose --force --sign "${cert}" "${pluginpath}quick/"*
