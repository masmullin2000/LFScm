#!/bin/bash

set -e

tar xf automake-1.16.1.tar.xz
cd automake-1.16.1

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf automake-1.16.1