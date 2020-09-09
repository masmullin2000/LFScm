#!/bin/bash

set -e

./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
make dist-xz -j$(nproc)
mv sed*.tar.xz ..
cd ..
rm -rf sed
tar xf sed*.tar.xz
rm -f sed*.tar.xz
mv sed* sed