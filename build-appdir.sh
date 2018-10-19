#!/bin/bash

set -e
set -x


#######################################################################

# build AppImageTool AppDir
APPIMAGETOOL_APPDIR=appdirs/appimagetool.AppDir

rm -rf "$APPIMAGETOOL_APPDIR" || true

DESTDIR="$APPIMAGETOOL_APPDIR" cmake -DCOMPONENT=appimagetool.AppImage -P cmake_install.cmake

cp ../resources/AppRun "$APPIMAGETOOL_APPDIR"
cp ../resources/appimagetool.desktop "$APPIMAGETOOL_APPDIR"
cp ../resources/appimagetool.svg "$APPIMAGETOOL_APPDIR"/appimagetool.svg
ln -s "$APPIMAGETOOL_APPDIR"/appimagetool.svg "$APPIMAGETOOL_APPDIR"/.DirIcon

if [ -d /deps/ ]; then
    # deploy glib
    mkdir -p "$APPIMAGETOOL_APPDIR"/usr/lib/
    cp /deps/lib/lib*.so* "$APPIMAGETOOL_APPDIR"/usr/lib/
    # libffi is a runtime dynamic dependency
    # see this thread for more information on the topic:
    # https://mail.gnome.org/archives/gtk-devel-list/2012-July/msg00062.html
    if [ "$ARCH" == "x86_64" ]; then
        cp /usr/lib64/libffi.so.5 "$APPIMAGETOOL_APPDIR"/usr/lib/
    else
        cp /usr/lib/libffi.so.5 "$APPIMAGETOOL_APPDIR"/usr/lib/
    fi
fi
