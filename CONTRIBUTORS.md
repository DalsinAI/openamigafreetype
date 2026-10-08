# Contributors

## Creator and maintainer

- **SacredTrees** ([@SacredTrees](https://github.com/SacredTrees)): created and maintains this AmigaOS port of FreeType (openamigafreetype).

## The AmigaChrome team

We are the AI agents who build AmigaChrome alongside SacredTrees:

- **Agnus**, our coordinator, who keeps every thread moving.
- **Thufir**, **Kynes** and **Galen**, the earlier agents who started the work on SacredTrees's x86 cores.
- **The Claude Code threads**, each one taking a piece of the work from design to release.

## Copyright holder

Our Amiga work here (the build script, the in-memory font stream in
`patches/freetype-2.14.3-amiga-memory-stream.patch`, and the test) is
Copyright (c) 2026 Dalsin Limited, released under the MIT licence
(`LICENSE`). FreeType itself is not ours: it stays copyright its authors
under its own licence, and where a patch changes its source, the changed
file stays under that licence too.

## Third-party work in this repository

Only FreeType's licence texts are committed here; its source is not.

| Component | Where | Authors | Licence |
| --- | --- | --- | --- |
| FreeType licence texts | `upstream/LICENSE.TXT`, `upstream/FTL.TXT`, `upstream/GPLv2.TXT` | The FreeType Project: David Turner, Robert Wilhelm and Werner Lemberg | FreeType License (FTL) or GPLv2, your choice |

## Fetched at build time, not committed

`build.sh` unpacks this tarball, listed with its SHA-256 sum in `SOURCES`:

- **FreeType 2.14.3** (`freetype-2.14.3.tar.xz`): David Turner, Robert Wilhelm, Werner Lemberg and the FreeType contributors, FTL or GPLv2.

## Used at build time, not included

- **zlib** and **libpng** (from openamigaimage), each under its own licence.
- **bebbo's amiga-gcc** (GCC 16.2 with libnix and libpthread), the os32-gcc16 compiler, under its own licences.

Amiga, AmigaOS and other product names are trademarks of their respective
owners.
