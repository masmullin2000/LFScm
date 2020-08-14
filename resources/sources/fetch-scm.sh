#!/bin/bash

set -e

function gitget {
	echo "GIT fetching $3 at tag $2 into $1"
	echo "---------------------------------"

	local DUMB_GIT="no"
	if [ ! -z "$4" ]
	then
		DUMB_GIT=$4
	fi

	if [ "yes" == $DUMB_GIT ]
	then
		git clone -b $2 $3 $1
	else
		git clone -b $2 --depth 1 $3 $1
	fi

	if [ ! -z "$5" ]
	then
		cd $1
		$5
		cd ..
	fi

	rm -rf $1/.git
	tar czf $1.tar.gz $1
	rm -rf $1
}

function svnget {
	echo "SVN Fetching $3/$2 into $1"
	echo "---------------------------------"
	svn co $3/$2 $1
	rm -rf $1/.svn
	tar czf $1.tar.gz $1
	rm -rf $1
}

function mercget {
	echo "Mercurial Fetching $3$2 into $1"
	echo "---------------------------------"
	hg clone "$3$2" $1
	rm -rf $1/.hg
	tar czf $1.tar.gz $1
	rm -rf $1
}

function targzget {
	echo "WGET fetching $2 to $1"
	echo "---------------------------------"
	wget $2 -O $1.tar.gz
	tar xf $1.tar.gz
	rm $1.tar.gz
	mv $1* $1
	tar czf $1.tar.gz $1

	rm -rf $1
}

function tarxzget {
	echo "WGET fetching $2 to $1"
	echo "---------------------------------"
	wget $2 -O $1.tar.xz
	tar xf $1.tar.xz
	rm $1.tar.xz
	mv ./$1* $1
	tar czf $1.tar.gz $1

	rm -rf $1
}

function tarbz2get {
	echo "WGET fetching $2 to $1"
	echo "---------------------------------"
	wget $2 -O $1.tar.bz2
	tar xf $1.tar.bz2
	rm $1.tar.bz2
	mv ./$1* $1
	tar czf $1.tar.gz $1

	rm -rf $1
}

function fetch_scm {
	#gitget		dbus			dbus-1.13.16			https://gitlab.freedesktop.org/dbus/dbus.git 							yes
	targzget	dbus 									https://dbus.freedesktop.org/releases/dbus/dbus-1.12.20.tar.gz
	#gitget		procps			v3.3.16					https://gitlab.com/procps-ng/procps.git 								yes
	tarxzget	procps 									https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-3.3.16.tar.xz
	gitget		e2fsprogs		v1.45.6					git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

	gitget		binutils 		binutils-2_35 			git://sourceware.org/git/binutils-gdb.git
	gitget		gcc 			releases/gcc-10.2.0		git://gcc.gnu.org/git/gcc.git

	# GCC doesn't build with the sources from the repos... grab the exact files from LFS
	#svnget		mpfr			branches/4.1			svn://scm.gforge.inria.fr/svnroot/mpfr
	#tarxzget	mpfr									http://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.xz
	targzget 	mpfr 									https://gforge.inria.fr/frs/download.php/file/38343/mpfr-4.1.0.tar.gz
	# mercget		gmp				-6.2					https://gmplib.org/repo/gmp
	tarxzget	gmp										http://ftp.gnu.org/gnu/gmp/gmp-6.2.0.tar.xz
	# gitget		mpc				1.1.0					https://gforge.inria.fr/anonscm/git/mpc/mpc.git						yes
	targzget	mpc										https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz

	gitget		linux 			v5.8.1	 				git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
	gitget		glibc 			glibc-2.32 				git://sourceware.org/git/glibc.git
	#gitget		m4				v1.4.18					git://git.savannah.gnu.org/m4.git 										no		/build/sources/m4-bootstrap.sh
	tarxzget	m4 										http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz
	targzget	ncurses									ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz
	gitget		bash			bash-5.0				git://git.savannah.gnu.org/bash.git
	#gitget		coreutils		v8.32					git://git.savannah.gnu.org/coreutils.git
	tarxzget	coreutils 								http://ftp.gnu.org/gnu/coreutils/coreutils-8.32.tar.xz
	#gitget		diffutils		v3.7					git://git.savannah.gnu.org/diffutils.git
	tarxzget	diffutils								http://ftp.gnu.org/gnu/diffutils/diffutils-3.7.tar.xz
	#gitget		file			FILE5_39				git://github.com/file/file
	targzget	file 									ftp://ftp.astron.com/pub/file/file-5.39.tar.gz
	#gitget		findutils		v4.7.0					git://git.savannah.gnu.org/findutils.git
	tarxzget	findutils								http://ftp.gnu.org/gnu/findutils/findutils-4.7.0.tar.xz
	gitget		gawk			gawk-5.1.0				git://git.savannah.gnu.org/gawk.git
	#gitget		grep			v3.4					git://git.savannah.gnu.org/grep.git
	tarxzget	grep									http://ftp.gnu.org/gnu/grep/grep-3.4.tar.xz
	#gitget		gzip			v1.10					git://git.savannah.gnu.org/gzip.git
	tarxzget	gzip 									http://ftp.gnu.org/gnu/gzip/gzip-1.10.tar.xz
	#gitget		make			4.3						git://git.savannah.gnu.org/make.git
	targzget 	make 									http://ftp.gnu.org/gnu/make/make-4.3.tar.gz
	#gitget		patch			v2.7.6					git://git.savannah.gnu.org/patch.git
	tarxzget	patch 									http://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz
	#gitget		sed				v4.8					git://git.savannah.gnu.org/sed.git
	tarxzget	sed 									http://ftp.gnu.org/gnu/sed/sed-4.8.tar.xz
	#gitget		tar				release_1_32			git://git.savannah.gnu.org/tar.git
	tarxzget	tar 									http://ftp.gnu.org/gnu/tar/tar-1.32.tar.xz
	#gitget		xz				v5.2.5					https://git.tukaani.org/xz.git										yes
	tarxzget	xz										https://tukaani.org/xz/xz-5.2.5.tar.xz

	## TODO: HAVEN"T TRIED TO GET THE SCM REPOS  LETS JUST GET MOVING
	tarxzget	gettext									http://ftp.gnu.org/gnu/gettext/gettext-0.21.tar.xz
	tarxzget	bison									http://ftp.gnu.org/gnu/bison/bison-3.7.1.tar.xz
	tarxzget	perl									https://www.cpan.org/src/5.0/perl-5.32.0.tar.xz
	tarxzget	Python									https://www.python.org/ftp/python/3.8.5/Python-3.8.5.tar.xz
	wget 												https://www.python.org/ftp/python/doc/3.8.5/python-3.8.5-docs-html.tar.bz2
	tarxzget	texinfo									http://ftp.gnu.org/gnu/texinfo/texinfo-6.7.tar.xz
	tarxzget	util-linux								https://www.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.tar.xz

	## TODO: Basic system, having tried to get scm repos yet
	tarxzget	man-pages								https://www.kernel.org/pub/linux/docs/man-pages/man-pages-5.07.tar.xz
	targzget	tcl										https://downloads.sourceforge.net/tcl/tcl8.6.10-src.tar.gz
	wget												https://downloads.sourceforge.net/tcl/tcl8.6.10-html.tar.gz
	targzget	expect									https://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz
	targzget	dejagnu									http://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.2.tar.gz
	targzget	iana									http://anduin.linuxfromscratch.org/LFS/iana-etc-20200429.tar.gz
	#targzget	tzdata									https://www.iana.org/time-zones/repository/releases/tzdata2020a.tar.gz
	wget 												https://www.iana.org/time-zones/repository/releases/tzdata2020a.tar.gz
	mv tzdata2020a.tar.gz tzdata.tar.gz

	tarxzget	zlib									https://zlib.net/zlib-1.2.11.tar.xz
	targzget	bzip2 									https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
	targzget	zstd 									https://github.com/facebook/zstd/releases/download/v1.4.5/zstd-1.4.5.tar.gz
	targzget	readline								http://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz
	tarxzget	bc 										https://github.com/gavinhoward/bc/releases/download/3.1.5/bc-3.1.5.tar.xz
	targzget	flex									https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz
	targzget	attr									http://download.savannah.gnu.org/releases/attr/attr-2.4.48.tar.gz
	targzget	acl 									http://download.savannah.gnu.org/releases/acl/acl-2.2.53.tar.gz
	tarxzget	libcap									https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.42.tar.xz
	tarxzget	shadow									https://github.com/shadow-maint/shadow/releases/download/4.8.1/shadow-4.8.1.tar.xz
	targzget 	pkg-config								https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
	tarxzget	psmisc									https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.3.tar.xz
	tarxzget	libtool									http://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz
	targzget	gdbm									http://ftp.gnu.org/gnu/gdbm/gdbm-1.18.1.tar.gz
	targzget	gperf									http://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz
	tarxzget	expat									https://prdownloads.sourceforge.net/expat/expat-2.2.9.tar.xz
	tarxzget	inetutils								http://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz
	targzget	XML-Parser								https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz
	targzget	intltool								https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz
	tarxzget	autoconf								http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz
	tarxzget	automake								http://ftp.gnu.org/gnu/automake/automake-1.16.2.tar.xz
	tarxzget	kmod									https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-27.tar.xz
	tarbz2get	elfutils								https://sourceware.org/ftp/elfutils/0.180/elfutils-0.180.tar.bz2
	targzget	libffi									ftp://sourceware.org/pub/libffi/libffi-3.3.tar.gz
	targzget	openssl									https://www.openssl.org/source/openssl-1.1.1g.tar.gz
	targzget	ninja									https://github.com/ninja-build/ninja/archive/v1.10.0/ninja-1.10.0.tar.gz
	targzget	meson									https://github.com/mesonbuild/meson/releases/download/0.55.0/meson-0.55.0.tar.gz
	targzget	check 									https://github.com/libcheck/check/releases/download/0.15.2/check-0.15.2.tar.gz
	targzget	groff									http://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz
	tarxzget	grub									https://ftp.gnu.org/gnu/grub/grub-2.04.tar.xz
	targzget	less									http://www.greenwoodsoftware.com/less/less-551.tar.gz
	#tarxzget	iproute									https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.7.0.tar.xz
	gitget		iproute 		v5.8.0					git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
	tarxzget	kbd 									https://www.kernel.org/pub/linux/utils/kbd/kbd-2.3.0.tar.xz
	targzget	libpipeline 							http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.2.tar.gz
	tarxzget	man-db									http://download.savannah.gnu.org/releases/man-db/man-db-2.9.3.tar.xz
	targzget	vim										http://anduin.linuxfromscratch.org/LFS/vim-8.2.1361.tar.gz

	gitget		systemd 		v246					https://github.com/systemd/systemd.git


	wget http://www.linuxfromscratch.org/patches/lfs/development/bash-5.0-upstream_fixes-1.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/bzip2-1.0.8-install_docs-1.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/coreutils-8.32-i18n-1.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/glibc-2.32-fhs-1.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/kbd-2.3.0-backspace-1.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/libpipeline-1.5.2-check_fixes-3.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/sysvinit-2.97-consolidated-1.patch

	wget http://www.linuxfromscratch.org/lfs/view/systemd/md5sums -O - | tail -n 6 > md5sums
	md5sum -c md5sums
}

function fetch_lfs {
	wget http://www.linuxfromscratch.org/lfs/view/systemd/wget-list
	wget http://www.linuxfromscratch.org/lfs/view/systemd/md5sums
	wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
	md5sum -c md5sums
}

function fetch_wget_lfs {
	targzget	wget		https://ftp.gnu.org/gnu/wget/wget-1.20.3.tar.gz
	tarxzget	make-ca		https://github.com/djlucas/make-ca/releases/download/v1.7/make-ca-1.7.tar.xz
	tarxzget	p11-kit		https://github.com/p11-glue/p11-kit/releases/download/0.23.20/p11-kit-0.23.20.tar.xz
	targzget	libtasn1	https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.16.0.tar.gz
}

FETCH=$1
if [ -z "$FETCH" ]
then
	FETCH="scm"
fi


if [[ "scm" == "$FETCH" ]]; then
	fetch_scm
elif [[ "lfs" == "$FETCH" ]]; then
	fetch_lfs
elif [[ "wget" == "$FETCH" ]]; then
	fetch_wget_lfs
fi

#tar -czf /output/all-sources.tar.gz .




