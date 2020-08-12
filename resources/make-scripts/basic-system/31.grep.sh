#!/bin/bash 

set -e

tar xf grep.tar.gz
cd grep

./configure --prefix=/usr --bindir=/bin

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf grep