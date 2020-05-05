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
_GTK_IM_DIR="/usr/lib/x86_64-linux-gnu/gtk-3.0/3.0.0"
_GDK_PIXBUF_DIR="/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/2.10.0"
export GTK_THEME=Adwaita
export GTK_DATA_PREFIX="$APPDIR"
export GTK_EXE_PREFIX="$APPDIR/usr"
export GTK_PATH="$APPDIR/usr/lib/x86_64-linux-gnu/gtk-3.0"
export GTK_IM_MODULE_DIR="$APPDIR/$_GTK_IM_DIR/immodules"
export GTK_IM_MODULE_FILE="$APPDIR/$_GTK_IM_DIR/immodules.cache"
export GDK_PIXBUF_MODULEDIR="$APPDIR/$_GDK_PIXBUF_DIR/loaders"
export GDK_PIXBUF_MODULE_FILE="$APPDIR/$_GDK_PIXBUF_DIR/loaders.cache"
export GSETTINGS_SCHEMA_DIR="$APPDIR/usr/share/glib-2.0/schemas"
export PANGO_LIBDIR="$APPDIR/usr/lib"
export PANGO_SYSCONFDIR="$APPDIR/etc"
export XDG_CONFIG_DIRS="$APPDIR/etc/xdg"
export XDG_DATA_DIRS="$APPDIR/usr/share:/usr/share:$XDG_DATA_DIRS"
export TEXTDOMAINDIR="$APPDIR/usr/share/locale"
export TERMINFO="$APPDIR/usr/share/terminfo"
export LD_LIBRARY_PATH="$APPDIRusr/lib/:$APPDIR/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH:$GDK_PIXBUF_MODULEDIR"
export PATH="$APPDIR/usr/local/sbin:$APPDIR/usr/local/bin:$APPDIR/usr/sbin:$APPDIR/usr/bin:$APPDIR/sbin:$APPDIR/bin:$PATH"

gtk-query-immodules-3.0 "$GTK_IM_MODULE_DIR/"* > "$GTK_IM_MODULE_FILE"
gdk-pixbuf-query-loaders "$GDK_PIXBUF_MODULEDIR/"* > "$GDK_PIXBUF_MODULE_FILE"
glib-compile-schemas "$GSETTINGS_SCHEMA_DIR"

cd "$APPDIR/"
$EXEC "$APPDIR/usr/bin/cpu-x" "$@"
