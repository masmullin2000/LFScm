#!/bin/bash

set -e

max_children=$(nproc)

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
	cd "$LFS"/sources

	provided_source $1 getit

	echo $getit

	if [[ $getit -eq 1 ]]; then
		echo "Developer provided $1"
	else
		echo "GIT fetching $3 at tag $2 into $1"
		echo "---------------------------------"

		DUMB_GIT="no"
		if [[ ! -z "$4" ]]; then
			DUMB_GIT="$4"
		fi

		mkdir -p /input/sources/fetcher
		touch /input/sources/fetcher/$1.start

		if [[ "yes" == $DUMB_GIT ]]; then
			git clone -b $2 $3 $1
			if [[ ! -z \"$6\" ]]; then
				cd $1
				echo "Checkout at sha:$6"
				git checkout -b to_sha $6
				cd ..
			fi
		else
			git clone -b $2 --depth 1 $3 $1
		fi

		if [[ ! -z "$5" ]]; then
			cd $1
			$5
			cd ..
		fi

		rm -rf $1/.git
		tar czf $1.tar.gz $1
		rm -rf $1
		rm /input/sources/fetcher/$1.start
		store_source $1
	fi
}

function svnget {
	cd "$LFS"/sources

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
	cd "$LFS"/sources

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

function fossilget {
	cd "$LFS"/sources

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
	cd "$LFS"/sources

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
	cd "$LFS"/sources

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

function tarballget {
	cd "$LFS"/sources

	provided_source $1 getit

	echo $getit

	if [[ $getit -eq 1 ]]; then
		echo "Developer provided $1"
	else
		echo "WGET fetching $2 to $1"
		echo "---------------------------------"
		set -e

		mkdir -p /input/sources/fetcher
		touch /input/sources/fetcher/$1.start

		wget $2 -O $1.tar.$3
		tar xf $1.tar.$3
		rm $1.tar.$3
		dir=$(find . -type d -name "$1*" -print | grep "^./$1" | head -n 1)
		mv "$dir" $1
		tar czf $1.tar.gz $1

		rm -rf $1

		rm /input/sources/fetcher/$1.start
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
				if test -n "$is_mandb"
				then
					pkg_to+="-db"
				fi

				if [[ "$2" == ".tar.gz" ]]; then
					targzget  $pkg_to $3
				elif [[ "$2" == ".tar.xz" ]]; then
					tarxzget  $pkg_to $3
				else
					tarbz2get $pkg_to $3
				fi
			else
				wget $3
				mv $1 tzdata.tar.gz
			fi
		else
			echo "retaining"
		fi
	fi
}

function parallel {
	"$@" || exit 1 &

	local my_pid=$$
  	local children=$(ps -eo ppid | grep -w $my_pid | wc -w)

	if [[ $children -ge $max_children ]]; then
		wait -n
	fi
}

function pak {
	max_children=4
	while read url;
	do
		set +e
		file=$(echo "$url" | sed 's/.*\///g')
		is_gz=$(echo "$file" | grep tar.gz)
		is_xz=$(echo "$file" | grep tar.xz)
		is_bz2=$(echo "$file" | grep tar.bz2)
		set -e
		if [[ -n $is_gz ]]; then
			parallel repackage "$file" ".tar.gz" "$url"
		elif [[ -n $is_xz ]]; then
			parallel repackage "$file" ".tar.xz" "$url"
		elif [[ -n $is_bz2 ]]; then
			parallel repackage "$file" ".tar.bz2" "$url"
		else
			parallel wget $url
		fi

		local my_pid=$$
  		local children=$(ps -eo ppid | grep -w $my_pid | wc -w)

		if [[ $children -ge $max_children ]]; then
			wait -n
		fi
	done < wget-list

	wait
}



function fetch_scm {
	gitgetkeep	gnulib									git://git.sv.gnu.org/gnulib.git

	#Make moved up due to compile error during toolchain
	parallel  gitget  make  master  git://git.savannah.gnu.org/make.git  no  "./bootstrap --copy --gnulib-srcdir=../gnulib"
	parallel  gitget  inetutils  master  git://git.savannah.gnu.org/inetutils.git  no  "/build/sources/pre-condition/inetutils-conf.sh"
	wait
	parallel  gitget  acl  master  git://git.savannah.gnu.org/acl.git  no  "/build/sources/pre-condition/acl-conf.sh"
	parallel  gitget  attr  master  git://git.savannah.gnu.org/attr.git  no  "/build/sources/pre-condition/attr-conf.sh"
	parallel  gitget  autoconf  master  git://git.savannah.gnu.org/autoconf.git  no  "/build/sources/pre-condition/autoconf-conf.sh"
	parallel  gitget  automake  master  git://git.savannah.gnu.org/automake.git  no  "./bootstrap --copy --gnulib-srcdir=../gnulib"
	parallel  gitget  bash  master  git://git.savannah.gnu.org/bash.git
	parallel  gitget  bc  master  https://git.yzena.com/gavin/bc.git
	parallel  gitget  binutils  master  git://sourceware.org/git/binutils-gdb.git
	parallel  gitget  bison  master  git://git.savannah.gnu.org/bison.git  no  "/build/sources/pre-condition/bison-conf.sh"
	parallel  gitget  bzip  master  git://sourceware.org/git/bzip2.git
	parallel  gitget  check  master  https://github.com/libcheck/check.git  no  "autoreconf -i"
	parallel  gitget  coreutils master  git://git.savannah.gnu.org/coreutils.git  no  "/build/sources/pre-condition/coreutils-conf.sh"
	parallel  gitget  dbus  master  https://gitlab.freedesktop.org/dbus/dbus.git  no  "./autogen.sh"
	parallel  gitget  dejagnu  master git://git.savannah.gnu.org/dejagnu.git  no  "/build/sources/pre-condition/dejagnu-conf.sh"
	parallel  gitget  diffutils  master  git://git.savannah.gnu.org/diffutils.git  no  "/build/sources/pre-condition/diffutils-conf.sh"
	parallel  gitget  e  maint  git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	parallel  gitget  elfutils  master  git://sourceware.org/git/elfutils.git  no  "autoreconf -if"
	parallel  gitget  expat  master  https://github.com/libexpat/libexpat.git  no  "/build/sources/pre-condition/expat-conf.sh"
	parallel  gitget  file  master  git://github.com/file/file  no  "autoreconf -fi"
	parallel  gitget  findutils  master  git://git.savannah.gnu.org/findutils.git  no  "/build/sources/pre-condition/findutils-conf.sh"
	parallel  gitget  flex  master  https://github.com/westes/flex.git  no  "/build/sources/pre-condition/flex-conf.sh"
	parallel  gitget  gawk  master  git://git.savannah.gnu.org/gawk.git
	# Sometime around Sept7 2020 master of gcc started
	# causing a hung compile of python
	parallel  gitget  gcc  releases/gcc-10  git://gcc.gnu.org/git/gcc.git
	parallel  gitget  gdbm  master  git://git.gnu.org.ua/gdbm.git  no  "/build/sources/pre-condition/gdbm-conf.sh"
	parallel  gitget  gettext  master  git://git.savannah.gnu.org/gettext.git  no  "/build/sources/pre-condition/gettext-conf.sh"
	parallel  gitget  glibc  master  git://sourceware.org/git/glibc.git
	#parallel  gitget  glibc  release/2.32/master  git://sourceware.org/git/glibc.git
	parallel  gitget  gperf  master  git://git.savannah.gnu.org/gperf.git  no  "/build/sources/pre-condition/gperf-conf.sh"
	parallel  gitget  grep  master  git://git.savannah.gnu.org/grep.git  yes  "/build/sources/pre-condition/grep-conf.sh"
	parallel  gitget  groff  master  git://git.savannah.gnu.org/groff.git  yes  "/build/sources/pre-condition/groff-conf.sh"
	parallel  gitget  grub  master  git://git.savannah.gnu.org/grub.git  no  "./bootstrap --copy --gnulib-srcdir=../gnulib"
	parallel  gitget  gzip  master  git://git.savannah.gnu.org/gzip.git  no  "/build/sources/pre-condition/gzip-conf.sh"
	parallel  gitget  iproute  main  git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
	parallel  gitget  kbd  master  git://git.kernel.org/pub/scm/linux/kernel/git/legion/kbd.git  no  "./autogen.sh"
	parallel  gitget  kmod  master  git://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git  no  "/build/sources/pre-condition/kmod-conf.sh"
	parallel  gitget  less  master  https://github.com/gwsw/less.git  no  "/build/sources/pre-condition/less-conf.sh"
	parallel  gitget  libcap  master  git://git.kernel.org/pub/scm/libs/libcap/libcap.git
	parallel  gitget  libffi  master  https://github.com/libffi/libffi  no  "./autogen.sh"
	parallel  gitget  libpipeline  master  git://git.savannah.gnu.org/libpipeline.git  no  "./bootstrap --copy --gnulib-srcdir=../gnulib"
	parallel  gitget  libressl  master  https://github.com/libressl-portable/portable.git  no  "./autogen.sh"
	parallel  gitget  libtool  master  git://git.savannah.gnu.org/libtool.git  no  "/build/sources/pre-condition/libtool-conf.sh"
	parallel  gitget  linux  master  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
	parallel  gitget  m  branch-1.4  git://git.savannah.gnu.org/m4.git  no  "/build/sources/pre-condition/m4-conf.sh"
	# Make moved up something above it is causing a problem
	parallel  gitget  man  master  git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
	parallel  gitget  man-db  master  git://git.savannah.gnu.org/man-db.git  no  "./bootstrap --copy --gnulib-srcdir=../gnulib"
	parallel  gitget  meson  master  https://github.com/mesonbuild/meson.git
	parallel  gitget  mpc  master  https://gitlab.inria.fr/mpc/mpc.git  yes  "autoreconf -i"
	parallel  gitget  ninja  master  https://github.com/ninja-build/ninja.git
	# Use libressl for scm builds
	#gitget		openssl			OpenSSL_1_1_1-stable	https://github.com/openssl/openssl.git
	parallel  gitget  patch  master  git://git.savannah.gnu.org/patch.git  no  "/build/sources/pre-condition/patch-conf.sh"
	parallel  gitget  perl  blead  https://github.com/Perl/perl5.git
	parallel  gitget  pkg  master  https://gitlab.freedesktop.org/pkg-config/pkg-config  no  "./autogen.sh --no-configure"
	parallel  gitget  procps  master  https://gitlab.com/procps-ng/procps.git  yes  "./autogen.sh"
	parallel  gitget  psmisc  master  https://gitlab.com/psmisc/psmisc.git  yes  "/build/sources/pre-condition/psmisc-conf.sh"
	parallel  gitget  Python  master  https://github.com/python/cpython.git
	parallel  gitget  readline  devel  git://git.savannah.gnu.org/readline.git
	parallel  gitget  sed  master  git://git.savannah.gnu.org/sed.git  no  "/build/sources/pre-condition/sed-conf.sh"
	# Shadow is broken; use mine until it's fixed
	parallel  gitget  shadow  master  https://github.com/shadow-maint/shadow.git  no  "./autogen.sh"
	parallel  gitget  systemd  master  https://github.com/systemd/systemd.git
	parallel  gitget  tar  master  git://git.savannah.gnu.org/tar.git  no  "/build/sources/pre-condition/tar-conf.sh"
	parallel  gitget  texinfo  master  git://git.savannah.gnu.org/texinfo.git  no  "/build/sources/pre-condition/texinfo-conf.sh"
	parallel  gitget  util  master  git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git  no  "/build/sources/pre-condition/util-conf.sh"
	parallel  gitget  vim  master  https://github.com/vim/vim.git
	parallel  gitget  XML  master  https://github.com/toddr/XML-Parser.git
	parallel  gitget  xz  master  https://git.tukaani.org/xz.git  yes  "./autogen.sh"
	parallel  gitget  zlib  develop  https://github.com/madler/zlib.git
	parallel  gitget  zstd  dev  https://github.com/facebook/zstd.git

	parallel  mercget  gmp  https://gmplib.org/repo/gmp  "/build/sources/pre-condition/gmp-conf.sh"

	parallel  svnget  mpfr  trunk  svn://scm.gforge.inria.fr/svnroot/mpfr  "autoreconf -i"

	parallel  fossilget  expect  https://core.tcl-lang.org/expect
	# using fossil is painful, there is a good gitmirror
	# TCL also seems fairly unstable.  > 8.6.10 breaks expect
	#fossilget	tcl								https://core.tcl-lang.org/tcl
	parallel  gitget  tcl  core-8-6-10  https://github.com/tcltk/tcl.git

	parallel  bzrget  intltool  intltool  "./autogen.sh"

	parallel  targzget  iana  http://anduin.linuxfromscratch.org/LFS/iana-etc-20200429.tar.gz
	parallel  targzget  ncurses  ftp://ftp.invisible-island.net/ncurses/ncurses.tar.gz

	#wget										https://www.python.org/ftp/python/doc/3.8.5/python-3.8.5-docs-html.tar.bz2
	#wget										https://downloads.sourceforge.net/tcl/tcl8.6.10-html.tar.gz
	wget  https://www.iana.org/time-zones/repository/releases/tzdata2020a.tar.gz
	mv  tzdata2020a.tar.gz  tzdata.tar.gz

	#wget http://www.linuxfromscratch.org/patches/lfs/development/glibc-2.32-fhs-1.patch
	#wget http://www.linuxfromscratch.org/patches/lfs/development/kbd-2.3.0-backspace-1.patch
	wait
}

function fetch_lfs_dev {
	wget http://www.linuxfromscratch.org/lfs/view/systemd/wget-list
	# wget http://www.linuxfromscratch.org/lfs/view/systemd/md5sums
	# wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
	# md5sum -c md5sums

	pak
}

function fetch_lfs {
	wget http://www.linuxfromscratch.org/lfs/view/stable-systemd/wget-list
	# wget http://www.linuxfromscratch.org/lfs/view/stable-systemd/md5sums
	# wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
	# md5sum -c md5sums

	pak
}

function fetch_wget_lfs {
	targzget	wget		https://ftp.gnu.org/gnu/wget/wget-1.20.3.tar.gz
	tarxzget	make-ca		https://github.com/djlucas/make-ca/releases/download/v1.7/make-ca-1.7.tar.xz
	tarxzget	p11-kit		https://github.com/p11-glue/p11-kit/releases/download/0.23.20/p11-kit-0.23.20.tar.xz
	targzget	libtasn1	https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.16.0.tar.gz
}

function fetch_ssh {
	#targzget	openssh		http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.3p1.tar.gz
	gitget 		openssh 	master						git://anongit.mindrot.org/openssh.git
}

function fetch_htop_scm {
	gitget 		htop		master						https://github.com/htop-dev/htop.git
}

function fetch_wireguard_scm {
	gitget		tcpdump		master						https://github.com/the-tcpdump-group/tcpdump.git
	gitget		libpcap		master						https://github.com/the-tcpdump-group/libpcap.git
	gitget		iptables	master						git://git.netfilter.org/iptables
	gitget 		wireguard 	master 						https://git.zx2c4.com/wireguard-tools
}

function fetch_git_scm {
	gitget 		curl 		master 						https://github.com/curl/curl.git
	gitget 		git 		master 						git://git.kernel.org/pub/scm/git/git.git
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
elif [[ "dev" == "$FETCH" ]]; then
	fetch_lfs_dev
elif [[ "wget" == "$FETCH" ]]; then
	fetch_wget_lfs
elif [[ "ssh" == "$FETCH" ]]; then
	fetch_ssh
elif [[ "htop" == "$FETCH" ]]; then
	fetch_htop_scm
elif [[ "wireguard" == "$FETCH" ]]; then
	fetch_wireguard_scm
elif [[ "git" == "$FETCH" ]]; then
	fetch_git_scm
fi
