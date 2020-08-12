#!/bin/bash

set -e

tar xf make.tar.gz
cd make

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf make
