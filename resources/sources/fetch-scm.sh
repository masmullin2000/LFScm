#!/bin/bash

set -e

function provided_source {

	local __ret=$2
	eval $__ret=0
	if [[ -d "/input/sources/$1" ]]; then
		tar czf $1.tar.gz -C /input/sources/ $1
		eval $__ret=1
	elif [[ -f "/input/sources/$1.tar.gz" ]]; then
		cp /input/sources/$1.tar.gz .
		eval $__ret=1
	fi
}

function store_source {
	if [[ -d "/input/sources" && ! -d "/input/sources/$1.tar.gz" ]]; then
		cp $1.tar.gz /input/sources/
	fi
}

function gitget {
	provided_source $1 getit

	echo $getit

	if [[ $getit -eq 1 ]]; then
		echo "Developer provided $1"
	else
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
		store_source $1
	fi
}

function svnget {
	provided_source $1 getit

	echo $getit

	if [[ $getit -eq 1 ]]; then
		echo "Developer provided $1"
	else
		echo "SVN Fetching $3/$2 into $1"
		echo "---------------------------------"
		svn co $3/$2 $1
		rm -rf $1/.svn

		if [ ! -z "$4" ]
		then
			cd $1
			$4
			cd ..
		fi

		tar czf $1.tar.gz $1
		rm -rf $1
		store_source $1
	fi
}

function mercget {
	provided_source $1 getit

	echo $getit

	if [[ $getit -eq 1 ]]; then
		echo "Developer provided $1"
	else
		echo "Mercurial Fetching $2 into $1"
		echo "---------------------------------"
		hg clone "$2" $1
		rm -rf $1/.hg
		
		if [ ! -z "$3" ]
		then
			cd $1
			$3
			cd ..
		fi

		tar czf $1.tar.gz $1
		rm -rf $1
		store_source $1
	fi
}

function tarballget {
	provided_source $1 getit

	echo $getit

	if [[ $getit -eq 1 ]]; then
		echo "Developer provided $1"
	else
		echo "WGET fetching $2 to $1"
		echo "---------------------------------"
		wget $2 -O $1.tar.$3
		tar xf $1.tar.$3
		rm $1.tar.$3
		mv ./$1* $1
		tar czf $1.tar.gz $1

		rm -rf $1
		store_source $1
	fi
}

function targzget {
	tarballget $1 $2 gz
}

function tarxzget {
	tarballget $1 $2 xz
}

function tarbz2get {
	tarballget $1 $2 bz2
}

function fossilget {
	provided_source $1 getit

	echo $getit

	if [[ $getit -eq 1 ]]; then
		echo "Developer provided $1"
	else
		echo "FOSSIL fetching $2 into $1"
		echo "---------------------------------"
		mkdir -p $1
		fossil clone $2 $1/$1.fossil --user root
		cd $1
		fossil open $1.fossil
		rm $1.fossil
		cd ..
		tar czf $1.tar.gz $1
		store_source $1
	fi
}

function bzrget {
	provided_source $1 getit

	echo $getit

	if [[ $getit -eq 1 ]]; then
		echo "Developer provided $1"
	else
		echo "BZR fetching $2 into $1"
		echo "---------------------------------"
		bzr branch lp:$2 $1
		cd $1

		if [ ! -z "$3" ]
		then
			$3
		fi

		rm -rf .bzr
		cd ..
		tar czf $1.tar.gz $1
		rm -rf $1
		store_source $1
	fi
}

function gitgetkeep {
	provided_source $1 getit

	echo $getit

	if [[ $getit -eq 1 ]]; then
		echo "Developer provided $1"
		tar xf $1.tar.gz
	else
		git clone $2 $1
		tar czf $1.tar.gz $1
		store_source $1
	fi
}

function fetch_scm {
	gitgetkeep	gnulib									git://git.sv.gnu.org/gnulib.git

	gitget		acl				master					git://git.savannah.gnu.org/acl.git \
	no		"/build/sources/acl-conf.sh"
	gitget 		attr 			master 					git://git.savannah.gnu.org/attr.git \
	no 		"/build/sources/attr-conf.sh"
	gitget 		autoconf 		master 					git://git.savannah.gnu.org/autoconf.git \
	no 		"/build/sources/autoconf-conf.sh"
	gitget 		automake 		master 					git://git.savannah.gnu.org/automake.git \
	no 		"./bootstrap --copy --gnulib-srcdir=../gnulib"
	gitget		bash			devel					git://git.savannah.gnu.org/bash.git
	gitget		bc				master					https://git.yzena.com/gavin/bc.git
	gitget		binutils		binutils-2_35			git://sourceware.org/git/binutils-gdb.git
	gitget 		bison 			master 					git://git.savannah.gnu.org/bison.git \
	no 		"/build/sources/bison-conf.sh"
	gitget		bzip			master					git://sourceware.org/git/bzip2.git
	gitget		check			master					https://github.com/libcheck/check.git \
	no		"autoreconf -i"
	gitget		coreutils		master					git://git.savannah.gnu.org/coreutils.git \
	no		"/build/sources/coreutils-conf.sh"
	gitget		dbus			master					https://gitlab.freedesktop.org/dbus/dbus.git \
	no		"./autogen.sh"
	gitget		dejagnu			master					git://git.savannah.gnu.org/dejagnu.git \
	no		"/build/sources/dejagnu-conf.sh"
	gitget		diffutils		master					git://git.savannah.gnu.org/diffutils.git \
	no		"/build/sources/diffutils-conf.sh"
	gitget		e				maint					git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	gitget 		elfutils 		master 					git://sourceware.org/git/elfutils.git \
	no 		"autoreconf -if"
	gitget		expat			master					https://github.com/libexpat/libexpat.git \
	no		"/build/sources/expat-conf.sh"
	gitget		file			master					git://github.com/file/file \
	no		"autoreconf -fi"
	gitget		findutils		master					git://git.savannah.gnu.org/findutils.git \
	no		"/build/sources/findutils-conf.sh"
	gitget 		flex 			master	 				https://github.com/westes/flex.git \
	no 		"/build/sources/flex-conf.sh"
	gitget		gawk			master					git://git.savannah.gnu.org/gawk.git
	gitget		gcc				releases/gcc-10.2.0		git://gcc.gnu.org/git/gcc.git
	gitget 		gdbm 			master 					git://git.gnu.org.ua/gdbm.git \
	no 		"/build/sources/gdbm-conf.sh"
	gitget 		gettext 		master 					git://git.savannah.gnu.org/gettext.git \
	no 		"/build/sources/gettext-conf.sh"
	gitget		glibc			glibc-2.32				git://sourceware.org/git/glibc.git
	gitget 		gperf 			master 					git://git.savannah.gnu.org/gperf.git \
	no 		"/build/sources/gperf-conf.sh"
	gitget 		grub 			master 					git://git.savannah.gnu.org/grub.git \
	no 		"./bootstrap --copy --gnulib-srcdir=../gnulib"
	gitget		gzip			master					git://git.savannah.gnu.org/gzip.git \
	no 		"/build/sources/gzip-conf.sh"
	gitget 		inetutils 		master 					git://git.savannah.gnu.org/inetutils.git \
	no 		"/build/sources/inetutils-conf.sh"
	gitget		iproute			main					git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
	gitget 		kbd 			master					git://git.kernel.org/pub/scm/linux/kernel/git/legion/kbd.git \
	no		"./autogen.sh"
	gitget 		kmod 			master					git://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git \
	no		"/build/sources/kmod-conf.sh"
	gitget  	less 			master 					https://github.com/gwsw/less.git \
	no 		"/build/sources/less-conf.sh"
	gitget		libcap			master					git://git.kernel.org/pub/scm/libs/libcap/libcap.git
	gitget 		libpipeline 	master 					git://git.savannah.gnu.org/libpipeline.git \
	no 		"./bootstrap --copy --gnulib-srcdir=../gnulib"
	gitget		libressl		master					https://github.com/libressl-portable/portable.git \
	no		"./autogen.sh"
	gitget 		libtool 		master 					git://git.savannah.gnu.org/libtool.git \
	no 		"/build/sources/libtool-conf.sh"
	gitget		linux			master					git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
	gitget		m				branch-1.4				git://git.savannah.gnu.org/m4.git \
	no		"/build/sources/m4-conf.sh"
	gitget		make			master					git://git.savannah.gnu.org/make.git \
	no 		"./bootstrap --copy --gnulib-srcdir=../gnulib"
	gitget		man				master					git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
	gitget 		man-db 			master 					git://git.savannah.gnu.org/man-db.git \
	no 		"./bootstrap --copy --gnulib-srcdir=../gnulib"
	gitget		meson			master					https://github.com/mesonbuild/meson.git
	gitget		mpc				master					https://gitlab.inria.fr/mpc/mpc.git \
	yes		"autoreconf -i"
	gitget		ninja			master					https://github.com/ninja-build/ninja.git		
	#gitget		openssl			OpenSSL_1_1_1-stable	https://github.com/openssl/openssl.git
	gitget		patch			master					git://git.savannah.gnu.org/patch.git \
	no 		"/build/sources/patch-conf.sh"
	gitget		perl			blead					https://github.com/Perl/perl5.git
	gitget 		pkg 			master 					https://gitlab.freedesktop.org/pkg-config/pkg-config \
	no 		"./autogen.sh --no-configure"
	gitget		procps			master					https://gitlab.com/procps-ng/procps.git \
	yes 	"./autogen.sh"
	gitget 		psmisc 			master 					https://gitlab.com/psmisc/psmisc.git \
	yes 	"/build/sources/psmisc-conf.sh"
	gitget		Python			master					https://github.com/python/cpython.git
	gitget 		readline 		devel 					git://git.savannah.gnu.org/readline.git
	gitget		sed				master					git://git.savannah.gnu.org/sed.git \
	no 		"/build/sources/sed-conf.sh"
	gitget 		shadow 			master 					https://github.com/shadow-maint/shadow.git \
	no 		"./autogen.sh"
	# current systemd (as of https://github.com/systemd/systemd/commit/b9df353689c34d7180ff4b271e866ca597dd516f#diff-91be33be198dcb660ec3e06b561540db)
	# has a compile bug that wont compile on machines that do not have libcryptsetup
	gitget		systemd			v246					https://github.com/systemd/systemd.git
	gitget 		tar 			master 					git://git.savannah.gnu.org/tar.git \
	no 		"/build/sources/tar-conf.sh"
	gitget 		texinfo 		master 					git://git.savannah.gnu.org/texinfo.git \
	no 		"/build/sources/texinfo-conf.sh"
	gitget 		util 			master					git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git \
	no 		"/build/sources/util-conf.sh"
	gitget		vim				master					https://github.com/vim/vim.git
	gitget		XML				master					https://github.com/toddr/XML-Parser.git
	gitget 		xz 				master					https://git.tukaani.org/xz.git \
	yes		"./autogen.sh"
	gitget 		zlib 			develop 				https://github.com/madler/zlib.git
	gitget		zstd			dev						https://github.com/facebook/zstd.git

	mercget		gmp										https://gmplib.org/repo/gmp \
			"/build/sources/gmp-conf.sh"

	svnget		mpfr			trunk					svn://scm.gforge.inria.fr/svnroot/mpfr \
			"autoreconf -i"

	fossilget	expect 									https://core.tcl-lang.org/expect
	# using fossil is painful, there is a good gitmirror
	# TCL also seems fairly unstable.  > 8.6.10 breaks expect
	#fossilget	tcl										https://core.tcl-lang.org/tcl
	gitget 		tcl 			core-8-6-10				https://github.com/tcltk/tcl.git

	bzrget		intltool 								intltool \
			"./autogen.sh"

	#gitget		grep			v3.4					git://git.savannah.gnu.org/grep.git
	tarxzget	grep									http://ftp.gnu.org/gnu/grep/grep-3.4.tar.xz
	targzget	groff									http://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz
	#tarxzget	grub									https://ftp.gnu.org/gnu/grub/grub-2.04.tar.xz
	#
	#tarxzget	gzip 									http://ftp.gnu.org/gnu/gzip/gzip-1.10.tar.xz
	targzget	iana									http://anduin.linuxfromscratch.org/LFS/iana-etc-20200429.tar.gz
	targzget	libffi									ftp://sourceware.org/pub/libffi/libffi-3.3.tar.gz
	targzget	ncurses									ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz

	#wget 												https://www.python.org/ftp/python/doc/3.8.5/python-3.8.5-docs-html.tar.bz2
	#wget												https://downloads.sourceforge.net/tcl/tcl8.6.10-html.tar.gz
	wget 												https://www.iana.org/time-zones/repository/releases/tzdata2020a.tar.gz
	mv tzdata2020a.tar.gz tzdata.tar.gz

	wget http://www.linuxfromscratch.org/patches/lfs/development/glibc-2.32-fhs-1.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/kbd-2.3.0-backspace-1.patch
}

function repackage {
	set +e
	is_html=$(echo $1 | grep html)
	is_tz=$(echo $1 | grep tzdata)
	is_sysd_man=$(echo $1 | grep systemd-man-pages)
	is_mandb=$(echo $1 | grep man-db)
	set -e

	if test -z "$is_sysd_man"
	then
		if test -z "$is_html"
		then
			if test -z "$is_tz"
			then
				pkg_from=$(echo $1 | sed "s/$2//g" | sed "s/-src//g")
				pkg_to=$(echo $1 | sed "s/$2//g" | sed 's/-.*//g' | sed 's/[0-9].*//g')
				if test -f "$is_mandb"
				then
					pkg_to+="-db"
				fi
				echo "repackaging -> $pkg_to :: $pkg_from :: $2"
				tar xf $1
				if test -f "$1"
				then
					rm $1
				fi
				mv "$pkg_from" "$pkg_to"
				tar czf "$pkg_to".tar.gz "$pkg_to"
				rm -rf "$pkg_to"

			else
				mv $1 tzdata.tar.gz
			fi
		else
			echo "retaining"
		fi
	fi
}

function pak {
	for f in *.tar.gz
	do
		echo "$f"
		repackage "$f" ".tar.gz"
	done

	for f in *.tar.xz
	do
		echo "$f"
		repackage "$f" ".tar.xz"
	done

	for f in *.tar.bz2
	do
		echo "$f"		
		repackage "$f" ".tar.bz2"
	done
}

function fetch_lfs_dev {
	wget http://www.linuxfromscratch.org/lfs/view/systemd/wget-list
	wget http://www.linuxfromscratch.org/lfs/view/systemd/md5sums
	wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
	md5sum -c md5sums

	pak
}

function fetch_lfs {
	wget http://www.linuxfromscratch.org/lfs/view/stable-systemd/wget-list
	wget http://www.linuxfromscratch.org/lfs/view/stable-systemd/md5sums
	wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
	md5sum -c md5sums

	pak
}

function fetch_wget_lfs {
	targzget	wget		https://ftp.gnu.org/gnu/wget/wget-1.20.3.tar.gz
	tarxzget	make-ca		https://github.com/djlucas/make-ca/releases/download/v1.7/make-ca-1.7.tar.xz
	tarxzget	p11-kit		https://github.com/p11-glue/p11-kit/releases/download/0.23.20/p11-kit-0.23.20.tar.xz
	targzget	libtasn1	https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.16.0.tar.gz
}

function fetch_ssh_lfs {
	targzget	openssh		http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.3p1.tar.gz
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
elif [[ "lfs_dev" == "$FETCH" ]]; then
	fetch_lfs
elif [[ "wget" == "$FETCH" ]]; then
	fetch_wget_lfs
elif [[ "ssh" == "$FETCH" ]]; then
	fetch_ssh_lfs
fi
