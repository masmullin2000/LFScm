#!/bin/bash

set -e

./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
make -j12
make dist-xz
mv diffutils*.tar.xz ..
cd ../
rm -rf diffutils
tar xf diffutils*.tar.xz
rm diffutils*.tar.xz
mv diffutils* diffutils
