# openamigafreetype

FreeType for AmigaOS 3.x on 68k, built as static link libraries for
GCC programs. Part of the [OpenAmiga](https://github.com/DalsinAI/openamiga)
ports, made for [OpenBrowser](https://github.com/DalsinAI/openamigabrowser),
the WebKit browser for AmigaOS 3.2.

**Status:** Working: builds, and the test's output matches Linux bit for bit.

This repository holds the Amiga build, not FreeType itself: a build script,
a smoke test and the upstream licences.

## Upstream

| Library | Version | Licence | Home |
| --- | --- | --- | --- |
| FreeType | 2.14.3 | FreeType License or GPLv2, your choice (upstream/LICENSE.TXT, FTL.TXT, GPLv2.TXT) | https://freetype.org/ |

The exact files and their SHA-256 sums are in [SOURCES](SOURCES). All credit
for the library goes to its authors; see `upstream/` for their notices.

## What the Amiga port changes

- **Fonts are read into memory** (`patches/freetype-2.14.3-amiga-memory-stream.patch`, in `src/base/ftsystem.c`): a font file is read whole when it is opened, so loading a glyph is not a seek and a read on the disk each time. Before, a page's first text took long enough that OpenBrowser's window sat at 31% while it was laid out. If there is not enough memory the file is read as it is needed, as before.
- `ftoption.h` turns on the system zlib and libpng (colour bitmap glyphs).

## Building

You need the os32-gcc16 compiler (bebbo's amiga-gcc on GCC 16.2 with libnix
and libpthread; see DalsinAI/openamigabrowser `stove/`) and the upstream
tarballs from [SOURCES](SOURCES) in `tarballs/`. Then:

```
./build.sh
```

The libraries and headers land in `out/` (set `PREFIX` to change that). The
script prints which other settings it needs, if any. Target: 68020 or better
with an FPU (`-m68020 -m68881`), libnix (`-mcrt=nix20`).

Link with: `-lfreetype -lpng -lz`

## Tested

`tests/ftpix.c`, run on AmigaOS 3.2.3 on AmigaChrome's AC090 emulation (68040 with FPU, 256 MB), Instance-24, 4 October 2026, as `ftpix DH1:OBFonts/LiberationSans-Regular.ttf`:

```
FTPIX glyphs_end=357 pixel0=ffffffff pixel_mid=ffffffff sum=5ff8f813
```

It renders "Hello, Amiga! AVWa 123" at 32 px with FreeType and composites it with pixman. The checksum is identical to the same program built from the same sources on x86-64 Linux, so the big-endian build draws exactly the same pixels.

It has not yet been run on real Amiga hardware.

## Known issues

- None known.

## Licence

Dalsin Limited's Amiga changes (the build script, patches, configuration
headers and tests) are MIT, Copyright (c) 2026 Dalsin Limited: see
[LICENSE](LICENSE). FreeType keeps its own licence, in
[upstream/](upstream/); a patch to its source stays under that licence.

## Contributors

This port is maintained by [SacredTrees](https://github.com/SacredTrees) with the AmigaChrome agent team, copyright Dalsin Limited. Everyone whose work it includes is credited in [`CONTRIBUTORS.md`](CONTRIBUTORS.md).
