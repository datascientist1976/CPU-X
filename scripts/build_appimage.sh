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
safeCopy "$gtk_libdir/gtk-2.0" \
	"$gtk_libdir/gtk-3.0" \
	"$gdk_pixbuf_moduledir" \
	"$gdk_pixbuf_cache_file" \
	"/usr/share/"{glib-2.0,icons,terminfo,themes} \
	"/usr/lib/gnome-settings-daemon-3.0" \
	"/usr/lib/x86_64-linux-gnu/libgdk_pixbuf-2.0"* \
	"/usr/lib/x86_64-linux-gnu/librsvg"* \
	"$APPDIR"
runCmd cp -v "./scripts/app_run.sh" "$APPDIR/AppRun"
runCmd glib-compile-schemas "$APPDIR/$gsettings_schema_dir"

runCmd wget -c -nv -O "linuxdeployqt.AppImage" "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
runCmd chmod a+x "linuxdeployqt.AppImage"
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
export ARCH=x86_64
#export VERSION=$(git describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g') # linuxdeployqt uses this for naming the file
export VERSION="continuous"
runCmd ./linuxdeployqt.AppImage \
	"$APPDIR/usr/share/applications/cpu-x.desktop" \
	-appimage \
	-extra-plugins=iconengines,platformthemes/libqgtk3.so \
	-no-copy-copyright-files \
	-verbose=2
