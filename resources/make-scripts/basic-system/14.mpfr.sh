#!/bin/bash

set -e

tar xf mpfr-4.0.2.tar.xz
cd mpfr-4.0.2

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.0.2

make -j$(nproc)
make html -j$(nproc)

#make check -j$(nproc)

make install
make install-html

cd ../
rm -rf mpfr-4.0.2