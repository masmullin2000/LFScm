#!/bin/bash

set -e

./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
make -j$(nproc)
make dist-xz
mv groff*.tar.xz ..
cd ..
rm -rf groff
tar xf groff*.tar.xz
rm -f groff*.tar.xz
mv groff* groff