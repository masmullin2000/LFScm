#!/bin/bash

set -e

tar xf libffi.tar.gz
cd libffi

./configure --prefix=/usr --disable-static --with-gcc-arch=native

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf libffi