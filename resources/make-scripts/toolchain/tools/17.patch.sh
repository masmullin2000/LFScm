#!/bin/bash

set -e

tar xvf patch.tar.gz
cd patch

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$(nproc)

make DESTDIR=$LFS install

cd ../
rm -rf patch