#!/bin/bash

set -e

tar xf libffi-3.3.tar.gz
cd libffi-3.3

./configure --prefix=/usr --disable-static --with-gcc-arch=native

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf libffi-3.3