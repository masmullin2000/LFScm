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

gitget		linux 			v5.7.14 				git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
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



wget http://www.linuxfromscratch.org/patches/lfs/development/bash-5.0-upstream_fixes-1.patch
wget http://www.linuxfromscratch.org/patches/lfs/development/bzip2-1.0.8-install_docs-1.patch
wget http://www.linuxfromscratch.org/patches/lfs/development/coreutils-8.32-i18n-1.patch
wget http://www.linuxfromscratch.org/patches/lfs/development/glibc-2.32-fhs-1.patch
wget http://www.linuxfromscratch.org/patches/lfs/development/kbd-2.3.0-backspace-1.patch
wget http://www.linuxfromscratch.org/patches/lfs/development/libpipeline-1.5.2-check_fixes-3.patch
wget http://www.linuxfromscratch.org/patches/lfs/development/sysvinit-2.97-consolidated-1.patch
wget http://www.linuxfromscratch.org/patches/lfs/development/systemd-245-gcc_10-fixes-2.patch

wget http://www.linuxfromscratch.org/lfs/view/systemd/md5sums -O - | tail -n 7 > md5sums
md5sum -c md5sums

tar -czf /output/all-sources.tar.gz .




