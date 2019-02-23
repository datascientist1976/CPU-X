#!/bin/bash

BUILD_APPDIR="$1"

#cp -v "$BUILD_APPDIR/usr/share/applications/cpu-x.desktop" "$BUILD_APPDIR/"
#cp -v "$BUILD_APPDIR/usr/share/icons/hicolor/96x96/apps/cpu-x.png" "$BUILD_APPDIR/"

mkdir -pv "$BUILD_APPDIR/usr/share/"
cp -Rv "/lib/terminfo/" "$BUILD_APPDIR/lib/"

#mkdir -pv "$BUILD_APPDIR/usr/lib/x86_64-linux-gnu/"
#cp -Rv "/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0" "$BUILD_APPDIR/usr/lib/x86_64-linux-gnu/"

wget -c -nv "https://github.com/probonopd/linuxdeployqt/releases/download/5/linuxdeployqt-5-x86_64.AppImage"
chmod a+x linuxdeployqt-5-x86_64.AppImage

wget -c "https://gist.githubusercontent.com/X0rg/58446b4ca33ca3e77fe8eb54d6d79973/raw/AppRun.c"
gcc AppRun.c -o "$BUILD_APPDIR/AppRun"

unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
export VERSION=$(git describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g') # linuxdeployqt uses this for naming the file
./linuxdeployqt-5-x86_64.AppImage "$BUILD_APPDIR/usr/share/applications/cpu-x.desktop" -bundle-non-qt-libs -appimage
rm -rfv $BUILD_APPDIR/{etc,var}
find $BUILD_APPDIR/
