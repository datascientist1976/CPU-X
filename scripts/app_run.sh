#!/bin/bash

die() {
	echo "[FATAL] $*"
	exit 1
}

safeExport() {
	local expr="$1"
	local var="$(echo "$expr" | cut -d= -f1)"
	local dirs="$(echo "$expr" | cut -d= -f2)"
	local ok=false

	for dir in $(echo "$dirs" | sed 's/:/ /g'); do
		if [[ ! -d "$dir" ]]; then
			local msg="Directory '$dir' does not exist (used by '$var')"
			if $ok; then
				echo "$msg"
			else
				die "$msg"
			fi
			ok=true
		fi
	done

	export "$expr"
}

if [[ -n "$CPUX_APPIMAGE_DEBUG" ]]; then
	set -x
fi

if [[ -n "$CPUX_APPIMAGE_GDB" ]]; then
	EXEC="gdb --args"
else
	EXEC=exec
fi

CACHEDIR="$(mktemp --tmpdir --directory CPU-X.XXXXXXXX)"

export GTK_THEME=Adwaita
export GDK_BACKEND=x11
safeExport GTK_DATA_PREFIX="$APPDIR"
safeExport GTK_EXE_PREFIX="$APPDIR/usr"
safeExport GTK_PATH="$APPDIR/usr/lib/x86_64-linux-gnu/gtk-3.0"
safeExport GTK_IM_MODULE_DIR="$APPDIR//usr/lib/x86_64-linux-gnu/gtk-3.0/3.0.0/immodules"
export     GTK_IM_MODULE_FILE="$CACHEDIR/immodules.cache"
safeExport GDK_PIXBUF_MODULEDIR="$APPDIR/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders"
export     GDK_PIXBUF_MODULE_FILE="$CACHEDIR/loaders.cache"
safeExport GSETTINGS_SCHEMA_DIR="$APPDIR/usr/share/glib-2.0/schemas"
safeExport PANGO_LIBDIR="$APPDIR/usr/lib"
#safeExport PANGO_SYSCONFDIR="$APPDIR/etc"
#safeExport XDG_CONFIG_DIRS="$APPDIR/etc/xdg"
safeExport XDG_DATA_DIRS="$APPDIR/usr/share:/usr/share:$XDG_DATA_DIRS"
safeExport TEXTDOMAINDIR="$APPDIR/usr/share/locale"
safeExport TERMINFO="$APPDIR/usr/share/terminfo"
safeExport LD_LIBRARY_PATH="$APPDIR/usr/lib/:$APPDIR/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH:$GDK_PIXBUF_MODULEDIR"
safeExport PATH="$APPDIR/usr/bin:$PATH"

gtk-query-immodules-3.0 "$GTK_IM_MODULE_DIR/"* > "$GTK_IM_MODULE_FILE"
gdk-pixbuf-query-loaders "$GDK_PIXBUF_MODULEDIR/"* > "$GDK_PIXBUF_MODULE_FILE"

cd "$APPDIR"
$EXEC "$APPDIR/usr/bin/cpu-x" "$@"
rm -rf "$CACHEDIR"
