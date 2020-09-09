#!/bin/bash

set -e

./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
make dist-xz -j$(nproc)
mv gzip*.tar.xz ..
cd ..
rm -rf gzip
tar xf gzip*.tar.xz
rm -f gzip*.tar.xz
mv gzip* gzip