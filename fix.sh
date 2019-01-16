#! /bin/bash --
# by pts@fazekas.hu at Tue Jan 15 01:17:59 CET 2019
#
# Example: fix.sh source/tetex1-v3

set -ex
cd "$1"
cd portable-tetex?
chmod +w texmf.product.txt ||:
chmod +w . texmf.*
echo "portable-${1##*/}" >texmf.product.txt
find texmf.main texmf.etc texmf.lib texmf.README.txt texmf.bin texmf.fmt -type d | xargs -d '\n' -- chmod a+w
rm -rf texmf.fonts/* texmf.tmp/* texmf.main/web2c/*.log texmf.main/source
rm -f texmf.main/doc texmf.main/ls-R texmf.main/texdoctk texmf.main/xdvi/XDvi
rm -f texmf.fmt/ls-R-TEXMFMAIN texmf.fmt/helpindex.html
rm -rf texmf.etc/*.d
find texmf.main texmf.fmt -type l | perl -wne '
    chomp;
    my $t = readlink($_);
    die "error $_: $!\n" if !$t;
    next if $t !~ m@^/@;
    die "bad target $_ -> $t\n" if $t !~ s@^/etc/texmf/@@;
    my $p = "../" x (y@/@@);
    my $u = "${p}texmf.etc/$t";
    print "ln -sf \x27$u\x27 \x27$_\x27\n";
    unlink $_;
    die "symlink: $!\n" if !symlink($u, $_);'
for F in $(ls texmf.lib/bin/* | perl -ne 'my $f = $_; chomp; print $f if -f($_) and !-l($_)' | xargs -d '\n' -- ldd -- | perl -ne 'if (s@^\t@@ and !m@^not a dynamic executable@ and !m@^linux-gate[.]so@) { s@ .*@@; s@^.*/@@; s@^@texmf.lib/@; print }' | sort | uniq); do
  test -f "$F"
  test -h "$F" && exit 1  # For simplicity, it shouldn't be a symlink.
done
find texmf.lib/shbin texmf.lib/ld-linux.so.2 -type f | xargs -d '\n' -- chmod +x --
chmod -x texmf.lib/shbin/__tmperl.pm
chmod +x texmf.main/web2c/mktex*
for D in texmf.main texmf.fonts; do
  chmod 755 "$D"
  rm -f "$D/ls-R"
  texmf.bin/mktexlsr "$D"
done
chmod +w texmf.lib/bin/*
chmod +w texmf.bin/* texmf.lib/shbin/__tm*
chmod +w .

: fix.sh OK.
