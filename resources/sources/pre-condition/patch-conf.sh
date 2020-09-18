#!/bin/bash

set -e

./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
make dist-xz -j$(nproc)
mv patch*.tar.xz ..
cd ..
rm -rf patch
tar xf patch*.tar.xz
rm -f patch*.tar.xz
mv patch* patch