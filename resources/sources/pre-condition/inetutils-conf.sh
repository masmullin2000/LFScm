#!/bin/bash

set -e

sed -i "s/2.63/2.64/g" configure.ac
./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
make -j$(nproc)
make dist-xz -j$(nproc)
mv inetutils*.tar.xz ..
cd ..
rm -rf inetutils
tar xf inetutils*.tar.xz
rm -f inetutils*.tar.xz
mv inetutils* inetutils
