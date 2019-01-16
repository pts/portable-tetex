#! /bin/bash --
# by pts@fazekas.hu at Wed Jan 16 01:37:32 CET 2019
#
# Example: ./release.sh source/tetex2-v3

set -ex
D="$1"
test -f source/tiny7zx
test -d "$D"
test -d "$D/portable-tetex"?"/texmf.bin"
DNV="${D%-v*}"
test "$DNV" != "$D"
test -d "${DNV%/*}/portable-${DNV##*/}-doc/man"
test -d "${DNV%/*}/portable-${DNV##*/}-src/latex"
test -d release

ls -l "release/portable-${DNV##*/}-"{doc,src}.sfx.7z "release/portable-${D##*/}.sfx.7z"  ||:
RPWD="../../../../../../../../../../../../../../../../../../../../$PWD"

./fix.sh "$D"
./fix_final.sh "$D"
# -ms=64m makes it <1500 bytes smaller than -ms=32m, so using -ms32m to save
# memory during decompression (64-32 MiB will be saved).
(cd "$D" && time 7z a -sfx"$RPWD"/source/tiny7zx -t7z -mx=7 -ms=32m -ms=on "portable-${D##*/}.sfx.7z.tmp" portable-tetex?) || exit "$?"
chmod 755 "$D/portable-${D##*/}.sfx.7z.tmp"
rm -f "release/portable-${D##*/}-$S.sfx.7z"
mv "$D/portable-${D##*/}.sfx.7z.tmp" "release/portable-${D##*/}.sfx.7z"

for S in doc src; do
  rm -f "release/portable-${DNV##*/}-$S.sfx.7z.tmp"
  # -ms=64m makes it <100 bytes smaller than -ms=32m, so using -ms32m to save
  # memory during decompression (64-32 MiB will be saved).
  (cd "${DNV%/*}" && time 7z a -sfx"$RPWD"/source/tiny7zx -t7z -mx=7 -ms=32m -ms=on "portable-${DNV##*/}-$S.sfx.7z.tmp" "portable-${DNV##*/}-$S") || exit "$?"
  chmod 755 "${DNV%/*}/portable-${DNV##*/}-$S.sfx.7z.tmp"
  rm -f "release/portable-${DNV##*/}-$S.sfx.7z"
  mv "${DNV%/*}/portable-${DNV##*/}-$S.sfx.7z.tmp" "release/portable-${DNV##*/}-$S.sfx.7z"
done

: release.sh OK.
