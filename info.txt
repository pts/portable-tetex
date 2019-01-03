by pts@fazekas.hu at Mon Jul 23 23:51:11 CEST 2018

* TOOD(pts): Implement all trampolines using xstatic gcc rather than /bin/sh.
* TODO(pts): Download tetex-bin in a copy of sarge_dir, make a copy of tetex2.
* TODO(pts): Download tetex-bin in a copy of etch_dir, make a copy of tetex3.
* TODO(pts): Document which command to use to regenerate the format files to texmf.fmt.
* DONE: mktexpk shouldn't write to /tmp, not even small files. (Set TMPDIR.)

FYI We can't load all hyphenation patterns, trie_op_size is not configurable
in tetex1: trie_op_size=35111 trie_size=250000 latex --ini latex.ltx

Removed tools:

* xdvi depends on libX11 etc.
* oxdvi depends on libX11 etc.
* texshow is a Perl script which uses Tk (not available, would need X11).

teTeX versions Debian systems, on 2018-07-25:

* Debian 3.0 Woody: 1.0.7+20011202
* Debian 3.1 Sarge: 2.0.2
* Debian 4.0 Etch: 3.0-31
* Debian 5.0 Lenny: no teTeX, tetex-bin is transitional to TeX Live 2007

chroot environments:

* Get qq from: https://github.com/pts/pts-chroot-env-qq
* sudo debootstrap --arch=i386 woody woody_dir http://archive.debian.org/debian/
* qq pts-debootstrap woody woody_dir
* qq pts-debootstrap sarge sarge_dir
* qq pts-debootstrap etch etch_dir

* !! TODO(pts): mktexpk shouldn't write to /tmp, not even small files.
* !! TODO(pts): Add all non-Tk (non-X11) Perl tools to tetex1.
# !! rm -rf texmf.fonts/* texmf.tmp/*
# !! find -name '*~' -type f | xargs -d '\n' -- rm -f --
* !! chmod 555 texmf.bin texmf.lib/{disabled,sh,}bin texmf.lib
* !! time 7z a -sfx../../../../../../../../"$PWD"/../tiny7zx -t7z -mx=7 -ms=32m -ms=on ../portable-tetex1-v1.sfx.7z portable-tetex1
* !! chmod 555 portable-tetex*.sfx.7z

__END__
