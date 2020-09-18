#!/bin/bash

set -e

./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
rm -rf .git
make distdir -j$(nproc)
make dist-xz
mv findutils*.tar.xz ..
cd ..
rm -rf findutils
tar xf findutils*.tar.xz
rm findutils*.tar.xz
mv findutils* findutils
cd findutils
touch .git