#!/bin/bash

set -e

./autogen.sh
sed -i 's/^BRANCH/#BRANCH/g' configure
rev=$(git rev-parse --short HEAD)
sed -i "s/revision=.*git.*/revision=$rev \\\/g" Makefile*
# ./configure
# make dist-xz -j$(nproc)
# mv dejagnu*.tar.xz ..
# cd ..
# rm -rf dejagnu
# tar xf dejagnu*.tar.xz
# rm -f dejagnu*.tar.xz
# mv dejagnu* dejagnu
