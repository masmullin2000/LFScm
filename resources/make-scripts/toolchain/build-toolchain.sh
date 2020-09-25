#!/bin/bash

source ~/.bashrc
set -e

BACKUP="no"
if [ -n "$1" ]
then
	BACKUP=$1
fi

function backup {
	if [ "$BACKUP" == "yes" ]
	then
		cd "$LFS"
		tar --exclude='sources/*' --exclude='boot/*' --exclude='proc/*' --exclude='basic-system' -cf - . | xz -3 --threads=0 > $1
	fi
}

function build_toolchain {
	echo -e "check for existance of /input/toolchain.tar.xz"

	if test -f "/input/toolchain.tar.xz"
	then
		tar xf /input/toolchain.tar.xz -C "$LFS"
	else
		for (( i=1; i<=5; i++ ))
		do
			echo -e "Building Toolchain $i\n\n\n\n\n"
			cd "$LFS"/sources && /build/make-scripts/toolchain/toolchain/$i.*.sh > /dev/null || exit &
		done
		wait
		backup /output/toolchain.tar.xz
	fi
}

function build_tools {
	echo -e "check for existance of /input/tools-pt$1.tar.xz"

	if test -f "/input/tools-pt$1.tar.xz"
	then
		tar xf "/input/tools-pt$1.tar.xz" -C "$LFS"
	else
		$4

		for (( i=$2; i<=$3; i++ ))
		do
			echo -e "Building Tool $i\n\n\n\n\n"
			cd "$LFS"/sources && /build/make-scripts/toolchain/tools/$i.*.sh > /dev/null || exit &
		done
		wait
		backup "/output/tools-pt$1.tar.xz"
	fi
}

function build_tools_2 {
	build_tools 2 13 22 build_tools_1
}

function build_tools_1 {
	build_tools 1 6 12 build_toolchain
}

build_tools_2