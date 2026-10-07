# Restart: openamigafreetype

_Written 6 October 2026 at about 23:55 UTC, while all work is paused on @SacredTrees's word (23:28 UTC). Read this first when work resumes; the newest capsule and the live PR list win if they disagree._

## What this repo is

FreeType built for AmigaOS 3.x (m68k) as static link libraries. Part of the Open family and an OpenBrowser dependency. Upstream source is fetched and pinned at build time, never committed.

## Where it stands

Stable: it builds and OpenBrowser links it. Only the CONTRIBUTORS.md pass landed today.

## Merged lately

- #1 (f253cea, 2026-10-06): Credit who made openamigafreetype: CONTRIBUTORS.md

## Open pull requests

- None.

## Next step

1. None queued. Bump the pinned upstream only with a reviewed version and sha256.

## Waiting on @SacredTrees

- Nothing.

## Who owns it

JSC thread (OpenBrowser).

## Capsules

Restart capsules for this repo's workstreams, in amigachrome's `capjumps/` shelf:

- [`20261006_AmigaChrome_OpenBrowser_JSC_Restart_Capsule.zip`](https://github.com/DalsinAI/amigachrome/tree/main/capjumps)

Team rules that still hold: commits as SacredTrees with no co-author lines; third-party code only on "yes with review" (licence checked, commit and sha256 pinned, fetched at build, never committed); deploys with deploy_dev.py only, on a typed line.
