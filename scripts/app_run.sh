#!/bin/bash

if [[ -n "$CPUX_APPIMAGE_DEBUG" ]]; then
	set -x
fi

if [[ -n "$CPUX_APPIMAGE_GDB" ]]; then
	EXEC="gdb --args"
else
	EXEC=exec
fi

APPDIR="$(dirname "$(realpath "$0")")"
_GDK_PIXBUF_DIR="/usr/lib/gdk-pixbuf-2.0/2.10.0"
_GDK_PIXBUF_MODULEDIR="$_GDK_PIXBUF_DIR/loaders"
export PATH="$APPDIR/usr/local/sbin:$APPDIR/usr/local/bin:$APPDIR/usr/sbin:$APPDIR/usr/bin:$APPDIR/sbin:$APPDIR/bin:$PATH"
export LD_LIBRARY_PATH="$APPDIR/usr/lib/:$APPDIR/usr/lib/i386-linux-gnu/:$APPDIR/usr/lib/x86_64-linux-gnu/:$APPDIR/usr/lib32/:$APPDIR/usr/lib64/:$APPDIR/lib/:$APPDIR/lib/i386-linux-gnu/:$APPDIR/lib/x86_64-linux-gnu/:$APPDIR/lib32/:$APPDIR/lib64/:$APPDIR"
export GTK_DATA_PREFIX="$APPDIR"
export GTK_PATH="$APPDIR/usr/lib/gtk-3.0"
export GTK_IM_MODULE_FILE="$APPDIR/usr/lib/gtk-3.0/3.0.0/immodules.cache"
export GDK_PIXBUF_MODULEDIR="$APPDIR/$_GDK_PIXBUF_MODULEDIR"
export GDK_PIXBUF_MODULE_FILE="$APPDIR/$_GDK_PIXBUF_DIR/loaders.cache"
export GSETTINGS_SCHEMA_DIR="$APPDIR/usr/share/glib-2.0/schemas"
export PANGO_LIBDIR="$APPDIR/usr/lib"
export PANGO_SYSCONFDIR="$APPDIR/etc"
export XDG_CONFIG_DIRS="$APPDIR/etc/xdg"
export XDG_DATA_DIRS="$APPDIR/usr/share"
export TEXTDOMAINDIR="$APPDIR/usr/share/locale"
export TERMINFO="$APPDIR/usr/share/terminfo"

cd "$APPDIR/usr/share/glib-2.0/schemas/"
glib-compile-schemas .

cd "$APPDIR/"
sed -i -e "s|$_GDK_PIXBUF_MODULEDIR|$GDK_PIXBUF_MODULEDIR|g" "$GDK_PIXBUF_MODULE_FILE"
$EXEC "$APPDIR/usr/bin/cpu-x" "$@"
