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
gsettings_schema_dir="/usr/share/glib-2.0/schemas"
safeCopy \
	"$gtk_libdir/gtk-3.0" \
	"$gdk_pixbuf_moduledir" \
	"$gdk_pixbuf_cache_file" \
	"/usr/share/"{glib-2.0,icons,terminfo,themes} \
	"/usr/lib/x86_64-linux-gnu/libgdk_pixbuf"* \
	"/usr/lib/x86_64-linux-gnu/libgobject"* \
	"$APPDIR"
runCmd cp -v "./scripts/app_run.sh" "$APPDIR/AppRun"
runCmd glib-compile-schemas "$APPDIR/$gsettings_schema_dir"

runCmd wget -c -nv -O "linuxdeploy.AppImage" "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
runCmd chmod -v a+x *.AppImage
export ARCH=x86_64
#export VERSION=$(git describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g') # linuxdeployqt uses this for naming the file
export VERSION="continuous"
# set environment variable to embed update information in an AppImage
#export UPDATE_INFORMATION="zsync|https://foo.bar/myappimage-latest.AppImage.zsync"
export VERBOSE=1
export DISABLE_COPYRIGHT_FILES_DEPLOYMENT=1

./linuxdeploy.AppImage \
	--appdir="$APPDIR" \
	--desktop-file="$APPDIR/usr/share/applications/cpu-x.desktop" \
	--output appimage \
	--verbosity=1
