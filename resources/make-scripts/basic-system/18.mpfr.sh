#!/bin/bash

set -e

tar xf mpfr.tar.gz
cd mpfr

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.1.0

make -j$(nproc)
make html -j$(nproc)

#make check -j$(nproc)

make install
make install-html

cd ../
rm -rf mpfr