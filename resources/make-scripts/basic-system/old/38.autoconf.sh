#!/bin/bash

set -e

tar xf autoconf-2.69.tar.xz
cd autoconf-2.69

sed '361 s/{/\\{/' -i bin/autoscan.in

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf autoconf-2.69