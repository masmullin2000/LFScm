#!/bin/bash 

set -e

tar xf grep-3.4.tar.xz
cd grep-3.4

./configure --prefix=/usr --bindir=/bin

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf grep-3.4