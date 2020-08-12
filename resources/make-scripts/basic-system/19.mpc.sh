#!/bin/bash

set -e

tar xf mpc.tar.gz
cd mpc

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.1.0

make -j$(nproc)
make html -j$(nproc)

#make check -j$(nproc)

make install
make install-html

cd ../
rm -rf mpc