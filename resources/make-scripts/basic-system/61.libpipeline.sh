#!/bin/bash

set -e

tar xf libpipeline.tar.gz
cd libpipeline

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf libpipeline