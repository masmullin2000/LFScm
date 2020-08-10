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
		tar --exclude='sources/*' --exclude='boot/*' -czf $1 .
	fi
}

if test -f "/input/tools-pt4.tar.gz"
then
	tar xf /input/tools-pt4.tar.gz -C "$LFS"
else
	if test -f "/input/tools-pt3.tar.gz"
	then
		tar xf /input/tools-pt3.tar.gz -C "$LFS"
	else
		if test -f "/input/tools-pt2.tar.gz"
		then
			tar xf /input/tools-pt2.tar.gz -C "$LFS"
		else
			if test -f "/input/tools-pt1.tar.gz"
			then
				tar xf /input/tools-pt1.tar.gz -C "$LFS"
			else
				if test -f "/input/toolchain.tar.gz"
				then
					tar xf /input/toolchain.tar.gz -C "$LFS"
				else
					for i in {1..5}
					do
						cd "$LFS"/sources && /build/make-scripts/toolchain/toolchain/$i.*.sh > /dev/null || exit
					done
					backup /output/toolchain.tar.gz
				fi

				for i in {6..9}
				do
					echo "Building $i\n\n\n\n\n"
					cd "$LFS"/sources && /build/make-scripts/toolchain/tools/$i.*.sh > /dev/null || exit
				done
				backup /output/tools-pt1.tar.gz
			fi

			for i in {10..12}
			do
				echo "Building $i\n\n\n\n\n"
				cd "$LFS"/sources && /build/make-scripts/toolchain/tools/$i.*.sh > /dev/null|| exit
			done
			backup /output/tools-pt2.tar.gz
		fi

		for i in {13..17}
		do
			echo "Building $i\n\n\n\n\n"
			cd "$LFS"/sources && /build/make-scripts/toolchain/tools/$i.*.sh > /dev/null || exit
		done
		backup /output/tools-pt3.tar.gz
	fi

	for i in {18..22}
	do
		echo "Building $i\n\n\n\n\n"
		cd "$LFS"/sources && /build/make-scripts/toolchain/tools/$i.*.sh > /dev/null|| exit
	done
	backup /output/tools-pt4.tar.gz
fi
