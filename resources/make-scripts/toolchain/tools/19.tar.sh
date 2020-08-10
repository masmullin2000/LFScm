#!/bin/bash

set -e

tar xvf tar.tar.gz
cd tar

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --bindir=/bin

make -j$(nproc)

make DESTDIR=$LFS install

cd ../
rm -rf tar