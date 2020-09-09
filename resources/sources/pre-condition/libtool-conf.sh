#!/bin/bash

set -e

./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
make dist-xz -j$(nproc)
mv libtool*.tar.xz ..
cd ..
rm -rf libtool
tar xf libtool*.tar.xz
rm -f libtool*.tar.xz
mv libtool* libtool