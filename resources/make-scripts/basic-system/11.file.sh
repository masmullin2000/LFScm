#!/bin/bash

set -e

tar xf file.tar.gz
cd file

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf file