#! /bin/bash --
# by pts@fazekas.hu at Wed Jan 16 01:37:32 CET 2019
#
# Example: ./release.sh source/tetex2-v3

set -ex
if test $# = 0; then
  set -- source/portable-tetex*-{doc,src}
fi
cd source
test -f tiny7zx
RPWD="../../../../../../../../../../../../../../../../../../../../$PWD"
for D in "$@"; do
  D="${D#source/}"
  test -d "$D" || continue
  find "$D" -name '*~' -type f | xargs -d '\n' -- rm -f --
  find "$D" -type f | xargs -d '\n' -- chmod 644 --
  find "$D" -type d | xargs -d '\n' -- chmod 755 --
  # -ms=64m makes it <100 bytes smaller than -ms=32m, so using -ms32m to save
  # memory during decompression (64-32 MiB will be saved).
  (time 7z a -sfx"$RPWD"/tiny7zx -t7z -mx=7 -ms=32m -ms=on "$D.sfx.7z.tmp" "$D") || exit "$?"
  chmod 755 "$D.sfx.7z.tmp"
  rm -f "../release/$D.sfx.7z"
  mv "$D.sfx.7z.tmp" "../release/$D.sfx.7z"
done

: release_nonsw.sh OK.
