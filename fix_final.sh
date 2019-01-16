#! /bin/bash --
# by pts@fazekas.hu at Tue Jan 15 01:17:59 CET 2019
#
# Example: fix.sh source/tetex1-v3

set -ex
cd "$1"
cd portable-tetex?
chmod +w texmf.product.txt ||:
echo "portable-${1##*/}" >texmf.product.txt
rm -rf texmf.fonts/* texmf.tmp/* texmf.main/web2c/*.log texmf.main/source
for F in $(ls texmf.lib/bin/* | perl -ne 'my $f = $_; chomp; print $f if -f($_) and !-l($_)' | xargs -d '\n' -- ldd -- | perl -ne 'if (s@^\t@@ and !m@^not a dynamic executable@ and !m@^linux-gate[.]so@) { s@ .*@@; s@^.*/@@; s@^@texmf.lib/@; print }' | sort | uniq); do
  test -f "$F"
  test -h "$F" && exit 1  # For simplicity, it shouldn't be a symlink.
done
for D in texmf.main texmf.fonts; do
  chmod 755 "$D"
  rm -f "$D/ls-R"
  texmf.bin/mktexlsr "$D"
done
# Don't add executable bit, to prevent direct execs of programs in
# texmf.lib/bin. All execs should be done by texmf.bin/... and then
# texmf.lib/shbin.
chmod a-x texmf.lib/bin/*
chmod a+x texmf.bin/* texmf.lib/shbin/*
chmod a-x texmf.lib/shbin/__tmperl.pm
find -name '*~' -type f | xargs -d '\n' -- rm -f --
find texmf.* -type f | xargs -d '\n' -- chmod 444 --
find texmf.lib/shbin texmf.lib/ld-linux.so.2 -type f | xargs -d '\n' -- chmod 555 --
chmod 444 texmf.lib/shbin/__tmperl.pm
find texmf.* -type d -depth | xargs -d '\n' -- chmod 555 --
chmod 755 texmf.fonts texmf.home texmf.tmp
chmod 755 texmf.main/web2c/mktex*
chmod 644 texmf.fonts/ls-R
chmod 555 .

: fix_final.sh OK.
