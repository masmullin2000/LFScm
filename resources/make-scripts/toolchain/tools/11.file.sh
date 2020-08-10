#!/bin/bash

set -e

tar xvf file.tar.gz
cd file

./configure --prefix=/usr --host=$LFS_TGT

make -j$(nproc)

make DESTDIR=$LFS install

cd ../
rm -rf file