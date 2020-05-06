#!/bin/bash

die() {
	echo "[FATAL] $*"
	exit 1
}

runCmd() {
	if ! "$@"; then
		die "command failed: '$*'"
	fi
}

safeCopy() {
	local src="${@:1:$#-1}"
	local dst="${@:$#}"

	for s in $src; do
		runCmd cp "$s" --archive --parents --target-directory="$dst" --verbose
	done
}

APPDIR="$1"

gtk_libdir="$(pkg-config --variable=libdir gtk+-3.0)"
gdk_pixbuf_moduledir="$(pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0)"
gdk_pixbuf_cache_file="$(pkg-config --variable=gdk_pixbuf_cache_file gdk-pixbuf-2.0)"
gdk_pixbuf_dir="$(dirname "$gdk_pixbuf_moduledir")"
gsettings_schema_dir="/usr/share/glib-2.0/schemas"
#mkdir -pv "$APPDIR/$gtk_libdir" "$APPDIR/$gdk_pixbuf_dir" "$APPDIR/$terminfo_dir" "$APPDIR/$gsettings_schema_dir"
#cp -Rv "$gtk_libdir/gtk-3.0" "$APPDIR/$gtk_libdir/"
#cp -Rv "$gdk_pixbuf_moduledir" "$gdk_pixbuf_cache_file" "$APPDIR/$gdk_pixbuf_dir/"
#cp -Rv "/usr/share/"{glib-2.0,terminfo,themes} "$APPDIR/usr/share/"
#cp -v "/usr/lib/x86_64-linux-gnu/librsvg"* "$APPDIR/usr/lib/x86_64-linux-gnu/"
safeCopy \
	"$gtk_libdir/"{gtk-2.0,gtk-3.0} \
	"$gdk_pixbuf_moduledir" \
	"$gdk_pixbuf_cache_file" \
	"/usr/share/"{glib-2.0,icons,terminfo,themes} \
	"/usr/lib/x86_64-linux-gnu/libgdk_pixbuf"* \
	"/usr/lib/x86_64-linux-gnu/libgobject"* \
	"/usr/lib/x86_64-linux-gnu/libcanberra"* \
	"/usr/lib/gnome-settings-daemon-3.0" \
	"$APPDIR"
runCmd cp -v "./scripts/app_run.sh" "$APPDIR/AppRun"
#runCmd glib-compile-schemas "$APPDIR/$gsettings_schema_dir"

#runCmd wget -c -nv -O "linuxdeploy.AppImage" "https://github.com/probonopd/linuxdeployqt/releases/download/6/linuxdeployqt-6-x86_64.AppImage"
#runCmd wget -c -nv -O "linuxdeploy.AppImage" "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
runCmd wget -c "https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-gtk/master/linuxdeploy-plugin-gtk.sh"
runCmd wget -c -nv -O "linuxdeploy.AppImage" "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
runCmd chmod -v a+x *.sh *.AppImage
#unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
export ARCH=x86_64
#export VERSION=$(git describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g') # linuxdeployqt uses this for naming the file
export VERSION="continuous"
# set environment variable to embed update information in an AppImage
#export UPDATE_INFORMATION="zsync|https://foo.bar/myappimage-latest.AppImage.zsync"
export VERBOSE=1
export NO_STRIP=1
export DISABLE_COPYRIGHT_FILES_DEPLOYMENT=1
# ./linuxdeploy.AppImage \
# 	"$APPDIR/usr/share/applications/cpu-x.desktop" \
# 	-appimage \
# 	-unsupported-bundle-everything \
# 	-no-copy-copyright-files \
# 	-verbose=2
./linuxdeploy.AppImage \
	--appdir="$APPDIR" \
	--desktop-file="$APPDIR/usr/share/applications/cpu-x.desktop" \
	--output appimage \
	--verbosity=1
