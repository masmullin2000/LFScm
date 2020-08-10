#!/bin/bash

set -e

tar xf patch-2.7.6.tar.xz
cd patch-2.7.6

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf patch-2.7.6

