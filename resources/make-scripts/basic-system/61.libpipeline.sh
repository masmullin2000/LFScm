#!/bin/bash

set -e

tar xf libpipeline.tar.gz
cd libpipeline

patch -Np1 -i ../libpipeline-1.5.2-check_fixes-3.patch

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf libpipeline