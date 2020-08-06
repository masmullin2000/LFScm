#!/bin/bash

set -e

tar xf libpipeline-1.5.2.tar.gz
cd libpipeline-1.5.2

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf libpipeline-1.5.2