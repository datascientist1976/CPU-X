#!/bin/bash

APPDIR="$1"

#cp -v "$APPDIR/usr/share/applications/cpu-x.desktop" "$APPDIR/"
#cp -v "$APPDIR/usr/share/icons/hicolor/96x96/apps/cpu-x.png" "$APPDIR/"

#mkdir -pv "$APPDIR/usr/share/"
#cp -Rv "/lib/terminfo/" "$APPDIR/lib/"

#mkdir -pv "$APPDIR/usr/lib/x86_64-linux-gnu/"
#cp -Rv "/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0" "$APPDIR/usr/lib/x86_64-linux-gnu/"

wget -c -nv -O "linuxdeployqt.AppImage" "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x "linuxdeployqt.AppImage"
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH

#export VERSION=$(git describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g') # linuxdeployqt uses this for naming the file
export VERSION="continuous"
gtk_libdir=$(pkg-config --variable=libdir gtk+-3.0)
gdk_pixbuf_moduledir="$(pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0)"
gdk_pixbuf_cache_file="$(pkg-config --variable=gdk_pixbuf_cache_file gdk-pixbuf-2.0)"
gdk_pixbuf_dir="$(dirname "$gdk_pixbuf_moduledir")"
mkdir -pv "$gdk_pixbuf_dir"
cp -Rv "$gtk_libdir/gtk-3.0" "$APPDIR/usr/lib"
cp -Rv "$gdk_pixbuf_moduledir" "$gdk_pixbuf_cache_file" "$APPDIR/$gdk_pixbuf_dir"
cp -v "./scripts/app_run.sh" "$APPDIR/AppRun"
./linuxdeployqt.AppImage "$APPDIR/usr/share/applications/cpu-x.desktop" -appimage -bundle-non-qt-libs -verbose=2
#rm -rfv $APPDIR/{etc,var}
find $APPDIR/
find . -name '*.AppImage' -exec realpath {} \;

# wget -c https://github.com/probonopd/uploadtool/raw/master/upload.sh
# chmod +x upload.sh
# ./upload.sh CPU-X*.AppImage*
