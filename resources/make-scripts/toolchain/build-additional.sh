#!/bin/bash

set -e

for i in {23..29}
do
	echo -e "Building $i\n\n\n\n\n"
	cd "$LFS"/sources && /additional/$i.*.sh || exit
done

find /usr/{lib,libexec} -name \*.la -delete
