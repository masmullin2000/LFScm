#!/bin/bash

set -e

tar xvf grep.tar.gz
cd grep

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --bindir=/bin

make -j$(nproc)

make DESTDIR=$LFS install

cd ../
rm -rf grep