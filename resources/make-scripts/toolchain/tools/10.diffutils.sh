#!/bin/bash

set -e

tar xvf diffutils.tar.gz
cd diffutils

./configure --prefix=/usr --host=$LFS_TGT

make -j$(nproc)

make DESTDIR=$LFS install

cd ../
rm -rf diffutils
