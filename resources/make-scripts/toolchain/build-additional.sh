#!/bin/bash

set -e

echo -e "Building File as an Additional Tool \n\n\n\n\n"
cd "$LFS"/sources && /tools/11.file.sh > /dev/null || exit

for i in {23..29}
do
	echo -e "Building Additional Tool $i\n\n\n\n\n"
	cd "$LFS"/sources && /additional/$i.*.sh > /dev/null || exit
done

find /usr/{lib,libexec} -name \*.la -delete
