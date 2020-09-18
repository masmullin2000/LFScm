#!/bin/bash

set -e

tar xvf sed.tar.gz
cd sed

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --bindir=/bin

make -j$(nproc)

make DESTDIR=$LFS install

cd ../
rm -rf sed