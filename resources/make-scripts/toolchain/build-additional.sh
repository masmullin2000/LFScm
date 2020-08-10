#!/bin/bash

set -e

for i in {23..29}
do
	cd "$LFS"/sources && /additional/$i.*.sh > /dev/null || exit
done

find /usr/{lib,libexec} -name \*.la -delete
