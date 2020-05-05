#!/bin/bash

BUILD_APPDIR="$1"
echo "BUILD_APPDIR=$BUILD_APPDIR"
ls "$BUILD_APPDIR"

#cp -v "$BUILD_APPDIR/usr/share/applications/cpu-x.desktop" "$BUILD_APPDIR/"
#cp -v "$BUILD_APPDIR/usr/share/icons/hicolor/96x96/apps/cpu-x.png" "$BUILD_APPDIR/"

#mkdir -pv "$BUILD_APPDIR/usr/share/"
#cp -Rv "/lib/terminfo/" "$BUILD_APPDIR/lib/"

#mkdir -pv "$BUILD_APPDIR/usr/lib/x86_64-linux-gnu/"
#cp -Rv "/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0" "$BUILD_APPDIR/usr/lib/x86_64-linux-gnu/"

wget -c -nv -O "linuxdeployqt.AppImage" "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x "linuxdeployqt.AppImage"
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH

#export VERSION=$(git describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g') # linuxdeployqt uses this for naming the file
export VERSION="continuous"
cp -v "./scripts/app_run.sh" "$BUILD_APPDIR/AppRun"
./linuxdeployqt.AppImage "$BUILD_APPDIR/usr/share/applications/cpu-x.desktop" -appimage -bundle-non-qt-libs -verbose=2
#rm -rfv $BUILD_APPDIR/{etc,var}
find $BUILD_APPDIR/
find . -name '*.AppImage' -exec realpath {} \;

# wget -c https://github.com/probonopd/uploadtool/raw/master/upload.sh
# chmod +x upload.sh
# ./upload.sh CPU-X*.AppImage*
