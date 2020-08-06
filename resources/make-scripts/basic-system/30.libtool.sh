#!/bin/bash

set -e

tar xf libtool-2.4.6.tar.xz
cd libtool-2.4.6

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf libtool-2.4.6

