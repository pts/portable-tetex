portable-tetex: teTeX binaries for new and old Linux systems
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
portable-tetex is a software distribution of teTeX for i386 Linux. It aims
to work conveniently on any Linux released between 1999 and 2019 and beyond.
teTeX is distrubution of TeX (including latex, dvips, pdflatex, mpost etc.)
for Unix systems by Thomas Esser, with 3 major releases between 1999 and
2005, and officially retired and unsupported since then. portable-tetex
brings the old teTeX binaries back to life. portable-tetex is useful for
compiling old .tex documents reliably, to reproduce the original output
files (.dvi, .ps and .pdf). For writing new documents, modern, up-to-date
TeX distributions (e.g TeX Live) are recommended instead.

portable-tetex was started by pts@fazekas.hu on 2018-07-23.

portable-tetex contains the following teTeX releases:

* tetex1: teTeX 1.0.7 (2000-04)
* tetex2: teTeX 2.0.2 (2003-02)
* tetex3: teTeX 3.0 (2005-02)

How to install and use:

* To use portable-tetex, you need an i386 or amd64 Linux system.
* Download portable-tetex1-v3.sfx.7z from the Releases section above.
* Extract it by running:
  $ chmod +x portable-tetex1-v3.sfx.7z
  $ ./portable-tetex1-v3.sfx.7z -y  # Creates and extracts to portable-tetex1/
* Download examples/hello.tex .
* Compile your document just as it compiled in 2000-04:
  $ portable-tetex1-v3/texmf.bin/latex hello
  $ portable-tetex1-v3/texmf.bin/dvips hello
  $ portable-tetex1-v3/texmf.bin/pdflatex hello

teTeX versions and their packages in Debian releases:

* teTeX 1.0 was released in 1999-06:
  http://ftp.math.utah.edu/pub/tex/historic/systems/teTeX/teTeX-1.0/distrib/ANNOUNCE
* Debian 3.0 Woody has teTeX 1.0.7.
  teTeX 1.0.7 was released in 2000-04:
  see timestamp of teTeX-src-1.0.7.tar.gz in http://ftp.math.utah.edu/pub/tex/historic/systems/teTeX/teTeX-1.0/distrib/sources/
* Debian 3.1 Sarge has teTeX 2.0.2.
  teTeX 2.0.2 was released in 2003-02:
  http://ftp.math.utah.edu/pub/tex/historic/systems/teTeX/teTeX-2.0/distrib/
* Debian 4.0 Etch has teTeX 3.0.
  teTeX 3.0.2 was released in 2005-02:
  http://ftp.math.utah.edu/pub/tex/historic/systems/teTeX/teTeX-3.0/distrib/ANNOUNCE-3.0
* Debian 5.0 Lenny: no teTeX, tetex-bin is transitional to TeX Live 2007.
  In 2006-05 Thomas Esser has decided not to make new teTeX releases.

Developer documentation
~~~~~~~~~~~~~~~~~~~~~~~
The rest of this file is useful only for the developers of portable-tetex.
Users don't have to care.

Progress and TODOs:

* DONE: mktexpk shouldn't write to /tmp, not even small files. (Set TMPDIR.)
* DONE: mktexpk doesn't write to /tmp, not even small files. This was done
  by setting TMPDIR in texmf.lib/shbin/__tm* .
* DONE: Added all non-Tk (non-X11) Perl tools to tetex1.
* DONE: fix.sh is now checking that we have all texmf.lib/*.so files needed.
* DONE: Added statically linked texmf.lib/shbin/{busybox,gs,perl}
* DONE: texmf.lib/shbin/__tmelf is not calling pdf*tex with --mktex=pk so that it will call mktexpk.
* DONE: Removed /bin/sh5 from texmf.lib/bin/* (busybox sh is good).
* DONE: Removed applets which are not needed (e.g. acpid, fdformat,
  kbd_mode, anything in /sbin and /usr/sbin) from busybox. Kept only what
  was definitely needed (grepped, see busybox_used.lst).
* TODO: Do tetex3.
* TODO: Copy texmf.etc to tetex1-v4.
* TOOD: Implement __tm* trampolines using xstatic gcc rather than /bin/sh.
* TODO: Document how to load many hyphenation patterns in tetex1, and load
  as many is it fits by default.
  We can't load all hyphenation patterns, trie_op_size is not configurable
  in tetex1: trie_op_size=35111 trie_size=250000 latex --ini latex.ltx
* TODO: document how to use fmtutil and updmap; we need chmod +w ... .../ls-R

Removed tools:

* xdvi depends on libX11 etc.
* oxdvi depends on libX11 etc.
* mfw depends on libX11 etc.
* tetex-xwarn depends on libX11 etc.
* texdoctk depends on libX11 etc.
* texfind depends on libX11 etc.
* texshow is a Perl script which uses Tk (not available, would need X11).
* xdvizilla is a shell script which runs executables which need X11.

What else is missing:

* Package gsfonts is not needed, it has e.g. c059033l.pfb (font
  CenturySchL-Ital), which is already in tetex-* as uncri8a.pfb).

chroot environments:

* Get qq from: https://github.com/pts/pts-chroot-env-qq
* qq pts-debootstrap woody woody_dir
* qq pts-debootstrap sarge sarge_dir
* qq pts-debootstrap etch etch_dir

What was copied where:

* Missing from tetex-base:
  * /usr/share/doc/texmf/...: copied
* Missing from tetex-bin:
  * /usr/sbin/update-texmf: not needed, regenerates texmf.cnf
  * /usr/sbin/update-fmtutil: not needed, regenerates fmtutil.cnf
  * /usr/share/man/man1/...: copied
  * /usr/share/info/...: copied
* These files are copied to portable-tetex1-src:
  * /usr/share/texmf/source as . from tetex-src
* These files are copied to portable-tetex1-doc:
  * /usr/share/doc/texmf as . from tetex-doc and tatex-base
  * /usr/share/man/man as man from tetex-bin
  * /usr/share/info as info from tetex-bin
  * find -type f -name '*.gz' | xargs -d '\n' -- gunzip
  * find -type l -name '*.gz' | perl -ne 'chomp; my $r = readlink($_); die "$_" if !defined($r); $r !~ s@[.]gz$@@; unlink $_; die if !s@[.]gz$@@; unlink $_; die "$_\n" if !symlink($r, $_)'

Useful shell commands:

* ./fix.sh source/tetex1-v3
* ./fix_final.sh source/tetex1-v3
* find portable-tetex2-doc -type f -name '*.gz' | xargs -d '\n' -- gunzip
* find portable-tetex2-doc -type l -name '*.gz' | perl -ne 'chomp; my $r = readlink($_); die "$_" if !defined($r); $r !~ s@[.]gz$@@; unlink $_; die if !s@[.]gz$@@; unlink $_; die "$_\n" if !symlink($r, $_)'
* time 7z a -sfx../../../../../../../../"$PWD"/../tiny7zx -t7z -mx=7 -ms=32m -ms=on ../portable-tetex1-v1.sfx.7z portable-tetex1
* cat $(grep -lE '^#! ?/bin/sh' texmf.lib/bin/*) | perl -ne 'our %h; while (m@([.-\w]+)@g) { next if exists $h{$1}; print "$1\n"; $h{$1} = 1 }' | sort >/tmp/a

__END__
