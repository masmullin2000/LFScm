#!/bin/bash

function gitget {
	echo "GIT fetching $3 at tag $2 into $1"

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
	rm -rf $1/.git
	tar czf $1.tar.gz $1
	rm -rf $1
}

function svnget {
	echo "SVN Fetching $3/$2 into $1"
	svn co $3/$2 $1
	rm -rf $1/.svn
	tar czf $1.tar.gz $1
	rm -rf $1
}

function mercget {
	echo "Mercurial Fetching $3$2 into $1"
	hg clone "$3$2" $1
	rm -rf $1/.hg
	tar czf $1.tar.gz $1
	rm -rf $1
}

function targzget {
	wget $2 -O $1.tar.gz
}

gitget		binutils 		binutils-2_35 			git://sourceware.org/git/binutils-gdb.git
gitget		gcc 			releases/gcc-10.2.0		git://gcc.gnu.org/git/gcc.git
gitget		linux 			v5.7.14 				git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
gitget		glibc 			glibc-2.32 				git://sourceware.org/git/glibc.git
gitget		m4				v1.4.18					git://git.savannah.gnu.org/m4.git
targzget	ncurses									ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz
gitget		bash			bash-5.0				git://git.savannah.gnu.org/bash.git
gitget		coreutils		v8.32					git://git.savannah.gnu.org/coreutils.git
gitget		diffutils		v3.7					git://git.savannah.gnu.org/diffutils.git
gitget		file			FILE5_39				git://github.com/file/file
gitget		findutils		v4.7.0					git://git.savannah.gnu.org/findutils.git
gitget		gawk			gawk-5.1.0				git://git.savannah.gnu.org/gawk.git
gitget		grep			v3.4					git://git.savannah.gnu.org/grep.git
gitget		gzip			v1.10					git://git.savannah.gnu.org/gzip.git
gitget		make			4.3						git://git.savannah.gnu.org/make.git
gitget		patch			v2.7.6					git://git.savannah.gnu.org/patch.git
gitget		sed				v4.8					git://git.savannah.gnu.org/sed.git
gitget		tar				release_1_32			git://git.savannah.gnu.org/tar.git
gitget		xz				v5.2.5					https://git.tukaani.org/xz.git										yes
svnget		mpfr			branches/4.1			svn://scm.gforge.inria.fr/svnroot/mpfr
mercget		gmp				-6.2					https://gmplib.org/repo/gmp
gitget		mpc				1.1.0					https://gforge.inria.fr/anonscm/git/mpc/mpc.git						yes

tar -czf /output/all-sources.tar.gz .




