#!/bin/bash

set -e

tar xf diffutils-3.7.tar.xz
cd diffutils-3.7

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf diffutils-3.7
