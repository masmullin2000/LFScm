#!/bin/bash

set -e

tar xf zlib-1.2.11.tar.xz
cd zlib-1.2.11

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so

cd ../
rm -rf zlib-1.2.11