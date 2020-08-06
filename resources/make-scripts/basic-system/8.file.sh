#!/bin/bash

set -e

tar xf file-5.38.tar.gz
cd file-5.38

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf file-5.38