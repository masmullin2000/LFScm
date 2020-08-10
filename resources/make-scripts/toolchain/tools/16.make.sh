#!/bin/bash

set -e

tar xvf make.tar.gz
cd make

./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$(nproc)

make DESTDIR=$LFS install

cd ../
rm -rf make