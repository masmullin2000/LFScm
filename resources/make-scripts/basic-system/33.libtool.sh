#!/bin/bash

set -e

tar xf libtool.tar.gz
cd libtool

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf libtool

