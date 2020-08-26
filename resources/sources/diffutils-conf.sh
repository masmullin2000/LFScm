#!/bin/bash

set -e

GNULIB_SRCDIR=../gnulib ./bootstrap --copy
./configure
make -j12
make dist-xz
mv diffutils*.tar.xz ..
cd ../
rm -rf diffutils
tar xf diffutils*.tar.xz
rm diffutils*.tar.xz
mv diffutils* diffutils
