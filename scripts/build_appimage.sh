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
LIBARCHDIR="lib/x86_64-linux-gnu"

safeCopy \
	"/usr/share/"{glib-2.0,terminfo} \
	"/usr/share/icons/"{Adwaita,hicolor,locolor} \
	"/usr/$LIBARCHDIR/"{gdk-pixbuf-2.0,gtk-3.0,libgtk-3-0} \
	"/usr/$LIBARCHDIR/libgdk_pixbuf"* \
	"/usr/$LIBARCHDIR/libgobject"* \
	"/usr/$LIBARCHDIR/libgio"* \
	"$APPDIR"
runCmd cp -v "./scripts/app_run.sh" "$APPDIR/AppRun"
runCmd glib-compile-schemas "$APPDIR/usr/share/glib-2.0/schemas"

runCmd wget -c -nv -O "linuxdeploy.AppImage" "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"
runCmd chmod -v a+x "linuxdeploy.AppImage"
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
