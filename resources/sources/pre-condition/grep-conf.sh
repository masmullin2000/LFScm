#!/bin/bash

set -e

./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
rm -rf .git
make dist-xz -j$(nproc)
mv grep*.tar.xz ..
cd ..
rm -rf grep
tar xf grep*.tar.xz
rm -f grep*.tar.xz
mv grep* grep