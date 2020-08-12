#!/bin/bash

set -e

tar xf autoconf.tar.gz
cd autoconf

sed -i '361 s/{/\\{/' bin/autoscan.in

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf autoconf