#!/bin/bash

set -e

tar xf gmp.tar.gz
cd gmp

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.2.0

make -j$(nproc)
make html -j$(nproc)

#make check 2>&1 -j$(nproc) | tee gmp-check-log
#awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log

make install
make install-html

cd ../
rm -rf gmp