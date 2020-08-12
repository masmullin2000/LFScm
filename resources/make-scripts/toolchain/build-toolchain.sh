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

if test -f "/input/tools-pt4.tar.xz"
then
	tar xf /input/tools-pt4.tar.xz -C "$LFS"
else
	if test -f "/input/tools-pt3.tar.xz"
	then
		tar xf /input/tools-pt3.tar.xz -C "$LFS"
	else
		if test -f "/input/tools-pt2.tar.xz"
		then
			tar xf /input/tools-pt2.tar.xz -C "$LFS"
		else
			if test -f "/input/tools-pt1.tar.xz"
			then
				tar xf /input/tools-pt1.tar.xz -C "$LFS"
			else
				if test -f "/input/toolchain.tar.xz"
				then
					tar xf /input/toolchain.tar.xz -C "$LFS"
				else
					for i in {1..5}
					do
						cd "$LFS"/sources && /build/make-scripts/toolchain/toolchain/$i.*.sh > /dev/null || exit
					done
					backup /output/toolchain.tar.xz
				fi

				for i in {6..9}
				do
					echo "Building $i\n\n\n\n\n"
					cd "$LFS"/sources && /build/make-scripts/toolchain/tools/$i.*.sh > /dev/null || exit
				done
				backup /output/tools-pt1.tar.xz
			fi

			for i in {10..12}
			do
				echo "Building $i\n\n\n\n\n"
				cd "$LFS"/sources && /build/make-scripts/toolchain/tools/$i.*.sh > /dev/null|| exit
			done
			backup /output/tools-pt2.tar.xz
		fi

		for i in {13..17}
		do
			echo "Building $i\n\n\n\n\n"
			cd "$LFS"/sources && /build/make-scripts/toolchain/tools/$i.*.sh > /dev/null || exit
		done
		backup /output/tools-pt3.tar.xz
	fi

	for i in {18..22}
	do
		echo "Building $i\n\n\n\n\n"
		cd "$LFS"/sources && /build/make-scripts/toolchain/tools/$i.*.sh > /dev/null|| exit
	done
	backup /output/tools-pt4.tar.xz
fi
