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

	if [ ! -z "$4" ]
	then
		cd $1
		$4
		cd ..
	fi

	tar czf $1.tar.gz $1
	rm -rf $1
}

function mercget {
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
}

function targzget {
	echo "WGET fetching $2 to $1"
	echo "---------------------------------"
	wget $2 -O $1.tar.gz
	tar xf $1.tar.gz
	rm $1.tar.gz
	mv ./$1* $1
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

function fetch_scm {
	git clone git://git.sv.gnu.org/gnulib.git

	targzget	acl 									http://download.savannah.gnu.org/releases/acl/acl-2.2.53.tar.gz
	targzget	attr									http://download.savannah.gnu.org/releases/attr/attr-2.4.48.tar.gz
	tarxzget	autoconf								http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz
	tarxzget	automake								http://ftp.gnu.org/gnu/automake/automake-1.16.2.tar.xz
	gitget		bash			devel 					git://git.savannah.gnu.org/bash.git
	tarxzget	bc 										https://github.com/gavinhoward/bc/releases/download/3.1.5/bc-3.1.5.tar.xz
	gitget		binutils 		binutils-2_35 			git://sourceware.org/git/binutils-gdb.git
	tarxzget	bison									http://ftp.gnu.org/gnu/bison/bison-3.7.1.tar.xz
	targzget	bzip 									https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
	targzget	check 									https://github.com/libcheck/check/releases/download/0.15.2/check-0.15.2.tar.gz
	gitget		coreutils		master					git://git.savannah.gnu.org/coreutils.git  no 	"/build/sources/coreutils-conf.sh"
	#tarxzget	coreutils 								http://ftp.gnu.org/gnu/coreutils/coreutils-8.32.tar.xz
	#gitget		dbus			dbus-1.13.16			https://gitlab.freedesktop.org/dbus/dbus.git 							yes
	targzget	dbus 									https://dbus.freedesktop.org/releases/dbus/dbus-1.12.20.tar.gz
	targzget	dejagnu									http://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.2.tar.gz
	gitget		diffutils		master					git://git.savannah.gnu.org/diffutils.git	no 		"/build/sources/diffutils-conf.sh"
	#tarxzget	diffutils								http://ftp.gnu.org/gnu/diffutils/diffutils-3.7.tar.xz
	gitget		e				v1.45.6					git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	tarbz2get	elfutils								https://sourceware.org/ftp/elfutils/0.180/elfutils-0.180.tar.bz2
	tarxzget	expat									https://prdownloads.sourceforge.net/expat/expat-2.2.9.tar.xz
	targzget	expect									https://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz
	#gitget		file			master					git://github.com/file/file 					no 		"autoreconf -fi"
	targzget	file 									ftp://ftp.astron.com/pub/file/file-5.39.tar.gz
	#gitget		findutils		v4.7.0					git://git.savannah.gnu.org/findutils.git
	tarxzget	findutils								http://ftp.gnu.org/gnu/findutils/findutils-4.7.0.tar.xz
	targzget	flex									https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz
	gitget		gawk			gawk-5.1.0				git://git.savannah.gnu.org/gawk.git
	gitget		gcc 			releases/gcc-10.2.0		git://gcc.gnu.org/git/gcc.git
	targzget	gdbm									http://ftp.gnu.org/gnu/gdbm/gdbm-1.18.1.tar.gz
	tarxzget	gettext									http://ftp.gnu.org/gnu/gettext/gettext-0.21.tar.xz
	gitget		glibc 			glibc-2.32 				git://sourceware.org/git/glibc.git
	mercget		gmp										https://gmplib.org/repo/gmp 					"/build/sources/gmp-conf.sh"
	#tarxzget	gmp										http://ftp.gnu.org/gnu/gmp/gmp-6.2.0.tar.xz
	targzget	gperf									http://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz
	#gitget		grep			v3.4					git://git.savannah.gnu.org/grep.git
	tarxzget	grep									http://ftp.gnu.org/gnu/grep/grep-3.4.tar.xz
	targzget	groff									http://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz
	tarxzget	grub									https://ftp.gnu.org/gnu/grub/grub-2.04.tar.xz
	#gitget		gzip			v1.10					git://git.savannah.gnu.org/gzip.git
	tarxzget	gzip 									http://ftp.gnu.org/gnu/gzip/gzip-1.10.tar.xz
	targzget	iana									http://anduin.linuxfromscratch.org/LFS/iana-etc-20200429.tar.gz
	tarxzget	inetutils								http://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz
	targzget	intltool								https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz
	#tarxzget	iproute									https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.7.0.tar.xz
	gitget		iproute 		main					git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
	tarxzget	kbd 									https://www.kernel.org/pub/linux/utils/kbd/kbd-2.3.0.tar.xz
	tarxzget	kmod									https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-27.tar.xz
	targzget	less									http://www.greenwoodsoftware.com/less/less-551.tar.gz
	#tarxzget	libcap									https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.42.tar.xz
	gitget		libcap			libcap-2.43				git://git.kernel.org/pub/scm/libs/libcap/libcap.git
	targzget	libffi									ftp://sourceware.org/pub/libffi/libffi-3.3.tar.gz
	targzget	libpipeline 							http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.3.tar.gz
	tarxzget	libtool									http://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz
	gitget		linux 			master	 				git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

	gitget		m				branch-1.4				git://git.savannah.gnu.org/m4.git 		no 		"/build/sources/m4-conf.sh"
	#tarxzget	m 										http://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz
	#gitget		make			4.3						git://git.savannah.gnu.org/make.git
	targzget 	make 									http://ftp.gnu.org/gnu/make/make-4.3.tar.gz
	tarxzget	man										https://www.kernel.org/pub/linux/docs/man-pages/man-pages-5.08.tar.xz
	tarxzget	man-db									http://download.savannah.gnu.org/releases/man-db/man-db-2.9.3.tar.xz
	#targzget	meson									https://github.com/mesonbuild/meson/releases/download/0.55.1/meson-0.55.1.tar.gz
	gitget		meson 			0.55.1					https://github.com/mesonbuild/meson.git
	gitget		mpc				master					https://gitlab.inria.fr/mpc/mpc.git		yes		"autoreconf -i"
	#targzget	mpc										https://ftp.gnu.org/gnu/mpc/mpc-1.2.0.tar.gz
	svnget		mpfr			trunk					svn://scm.gforge.inria.fr/svnroot/mpfr 			"autoreconf -i"
	#tarxzget	mpfr									http://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.xz
	#targzget 	mpfr 									https://gforge.inria.fr/frs/download.php/file/38343/mpfr-4.1.0.tar.gz
	targzget	ncurses									ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz
	#targzget	ninja									https://github.com/ninja-build/ninja/archive/v1.10.0/ninja-1.10.0.tar.gz
	gitget		ninja			master					https://github.com/ninja-build/ninja.git		
	#targzget	openssl									https://www.openssl.org/source/openssl-1.1.1f.tar.gz
	#gitget		openssl 		OpenSSL_1_1_1-stable	https://github.com/openssl/openssl.git
	gitget		libressl		master					https://github.com/libressl-portable/portable.git	no		"./autogen.sh"
	#gitget		patch			v2.7.6					git://git.savannah.gnu.org/patch.git
	tarxzget	patch 									http://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz
	tarxzget	perl									https://www.cpan.org/src/5.0/perl-5.32.0.tar.xz
	targzget 	pkg										https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
	#gitget		procps			v3.3.16					https://gitlab.com/procps-ng/procps.git 								yes
	tarxzget	procps 									https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-3.3.16.tar.xz
	tarxzget	psmisc									https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.3.tar.xz
	tarxzget	Python									https://www.python.org/ftp/python/3.8.5/Python-3.8.5.tar.xz
	wget 												https://www.python.org/ftp/python/doc/3.8.5/python-3.8.5-docs-html.tar.bz2
	targzget	readline								http://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz
	#gitget		sed				v4.8					git://git.savannah.gnu.org/sed.git
	tarxzget	sed 									http://ftp.gnu.org/gnu/sed/sed-4.8.tar.xz
	tarxzget	shadow									https://github.com/shadow-maint/shadow/releases/download/4.8.1/shadow-4.8.1.tar.xz
	gitget		systemd 		v246					https://github.com/systemd/systemd.git
	#gitget		tar				release_1_32			git://git.savannah.gnu.org/tar.git
	tarxzget	tar 									http://ftp.gnu.org/gnu/tar/tar-1.32.tar.xz
	targzget	tcl										https://downloads.sourceforge.net/tcl/tcl8.6.10-src.tar.gz
	wget												https://downloads.sourceforge.net/tcl/tcl8.6.10-html.tar.gz
	tarxzget	texinfo									http://ftp.gnu.org/gnu/texinfo/texinfo-6.7.tar.xz
	wget 												https://www.iana.org/time-zones/repository/releases/tzdata2020a.tar.gz
	mv tzdata2020a.tar.gz tzdata.tar.gz
	tarxzget	util									https://www.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.tar.xz
	gitget		vim 			master					https://github.com/vim/vim.git
	targzget	XML										https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.46.tar.gz
	tarxzget	xz										https://tukaani.org/xz/xz-5.2.5.tar.xz
	tarxzget	zlib									https://zlib.net/zlib-1.2.11.tar.xz
	targzget	zstd 									https://github.com/facebook/zstd/releases/download/v1.4.5/zstd-1.4.5.tar.gz

	#wget http://www.linuxfromscratch.org/patches/lfs/development/bash-5.0-upstream_fixes-1.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/bzip2-1.0.8-install_docs-1.patch
	#wget http://www.linuxfromscratch.org/patches/lfs/development/coreutils-8.32-i18n-1.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/glibc-2.32-fhs-1.patch
	wget http://www.linuxfromscratch.org/patches/lfs/development/kbd-2.3.0-backspace-1.patch
	#wget http://www.linuxfromscratch.org/patches/lfs/development/libpipeline-1.5.2-check_fixes-3.patch
	#wget http://www.linuxfromscratch.org/patches/lfs/development/sysvinit-2.97-consolidated-1.patch

	#wget http://www.linuxfromscratch.org/lfs/view/systemd/md5sums -O - | tail -n 6 > md5sums
	#md5sum -c md5sums
}

function fetch_lfs {
	wget http://www.linuxfromscratch.org/lfs/view/systemd/wget-list
	wget http://www.linuxfromscratch.org/lfs/view/systemd/md5sums
	wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
	md5sum -c md5sums

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
elif [[ "wget" == "$FETCH" ]]; then
	fetch_wget_lfs
elif [[ "ssh" == "$FETCH" ]]; then
	fetch_ssh_lfs
fi
