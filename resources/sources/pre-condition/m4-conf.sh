#!/bin/bash

set -e

GNULIB_SRCDIR=../gnulib ./bootstrap --copy
./configure

make -j$(nproc)
make dist-xz

mv *.tar.xz ../tobem4.tar.xz
cd ../
rm -rf m4*
tar xf tobem4.tar.xz
mv m4* m
rm tobem4.tar.xz
