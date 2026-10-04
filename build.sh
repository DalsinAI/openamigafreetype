#!/bin/sh
# openamigafreetype: FreeType, built for AmigaOS 3.x (68020 + FPU) with the
# os32-gcc16 compiler (bebbo's amiga-gcc, GCC 16.2, libnix, libpthread).
# MIT, Copyright (c) 2026 Dalsin Limited. The library keeps its own licence.
#
#   OS32_GCC16   compiler root holding prefix/ and compat/
#                (default ~/AmigaChrome/stoves/os32-gcc16)
#   PREFIX       where include/ and lib/ go (default ./out)
#   TARBALLS     folder holding the upstream tarballs listed in SOURCES
#                (default ./tarballs); the script checks their SHA-256
#   JOBS         parallel jobs for CMake/make builds (default 2)
#
# usage: ./build.sh
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
S=${OS32_GCC16:-"$HOME/AmigaChrome/stoves/os32-gcc16"}
P=$S/prefix
OUT=${PREFIX:-"$HERE/out"}
TARBALLS=${TARBALLS:-"$HERE/tarballs"}
JOBS=${JOBS:-2}
WORK="$HERE/work"
CC="$P/bin/m68k-amigaos-gcc"
CXX="$P/bin/m68k-amigaos-g++"
AR="$P/bin/m68k-amigaos-ar"
CPU="-m68020 -m68881 -mcrt=nix20"
CFLAGS="-O2 $CPU -D_DEFAULT_SOURCE=1 -D_POSIX_TIMERS=1 -D_POSIX_REALTIME_SIGNALS=1 -fno-common"
mkdir -p "$OUT/include" "$OUT/lib" "$WORK"

# unpack NAME TARBALL SHA256: check the tarball and unpack it into $WORK
unpack() {
    t="$TARBALLS/$2"
    [ -f "$t" ] || { echo "missing $t (see SOURCES)"; exit 2; }
    echo "$3  $t" | sha256sum -c - >/dev/null || { echo "SHA-256 mismatch: $t"; exit 2; }
    rm -rf "$WORK/$1"; mkdir -p "$WORK/$1"
    case "$2" in
        *.zip) (cd "$WORK/$1" && unzip -q "$t") ;;
        *) tar xf "$t" -C "$WORK/$1" ;;
    esac
}

# archive NAME FILE...: compile into $OUT/lib/libNAME.a ($XFLAGS added)
archive() {
    name=$1; shift
    obj="$WORK/obj-$name"
    rm -rf "$obj"; mkdir -p "$obj"
    for f in "$@"; do
        o="$obj/$(echo "$f" | tr '/' '_' | sed 's/\.[a-z]*$//').o"
        case "$f" in
            *.cc|*.cpp) $CXX $CFLAGS ${XFLAGS:-} -c "$f" -o "$o" ;;
            *) $CC $CFLAGS ${XFLAGS:-} -c "$f" -o "$o" ;;
        esac
    done
    rm -f "$OUT/lib/lib$name.a"
    $AR rcs "$OUT/lib/lib$name.a" "$obj"/*.o
    echo "lib$name.a: $(wc -c < "$OUT/lib/lib$name.a") bytes"
}

DEPS=${DEPS_PREFIX:?set DEPS_PREFIX to a prefix with zlib and libpng (openamigaimage)}
unpack freetype freetype-2.14.3.tar.xz 36bc4f1cc413335368ee656c42afca65c5a3987e8768cc28cf11ba775e785a5f
cd "$WORK/freetype/freetype-2.14.3"
# FreeType's standard modules; system zlib, libpng for colour bitmaps; no
# HarfBuzz link (the autohinter works without it), bzip2 or Brotli.
mkdir -p "$WORK/freetype-conf/freetype/config"
sed -e 's|^/\* *#define FT_CONFIG_OPTION_USE_PNG *\*/|#define FT_CONFIG_OPTION_USE_PNG|' \
    -e 's|^/\* *#define FT_CONFIG_OPTION_SYSTEM_ZLIB *\*/|#define FT_CONFIG_OPTION_SYSTEM_ZLIB|' \
    include/freetype/config/ftoption.h > "$WORK/freetype-conf/freetype/config/ftoption.h"
XFLAGS="-I$WORK/freetype-conf -Iinclude -I$DEPS/include -DFT2_BUILD_LIBRARY" archive freetype \
    src/autofit/autofit.c src/base/ftbase.c src/base/ftbbox.c src/base/ftbdf.c src/base/ftbitmap.c \
    src/base/ftcid.c src/base/ftfstype.c src/base/ftgasp.c src/base/ftglyph.c src/base/ftgxval.c \
    src/base/ftinit.c src/base/ftmm.c src/base/ftotval.c src/base/ftpatent.c src/base/ftpfr.c \
    src/base/ftstroke.c src/base/ftsynth.c src/base/ftsystem.c src/base/fttype1.c src/base/ftwinfnt.c \
    src/base/ftdebug.c src/bdf/bdf.c src/cache/ftcache.c src/cff/cff.c src/cid/type1cid.c \
    src/gzip/ftgzip.c src/lzw/ftlzw.c src/pcf/pcf.c src/pfr/pfr.c src/psaux/psaux.c \
    src/pshinter/pshinter.c src/psnames/psnames.c src/raster/raster.c src/sdf/sdf.c src/sfnt/sfnt.c \
    src/smooth/smooth.c src/svg/svg.c src/truetype/truetype.c src/type1/type1.c src/type42/type42.c \
    src/winfonts/winfnt.c
rm -rf "$OUT/include/freetype2"; mkdir -p "$OUT/include/freetype2"
cp -r include/ft2build.h include/freetype "$OUT/include/freetype2/"
cp "$WORK/freetype-conf/freetype/config/ftoption.h" "$OUT/include/freetype2/freetype/config/"
