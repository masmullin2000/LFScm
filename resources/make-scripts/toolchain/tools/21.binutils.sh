#!/bin/bash

set -e

tar xvf binutils.tar.gz
cd binutils

mkdir -v build
cd build

../configure                   \
    --prefix=$LFS/usr          \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --disable-werror           \
    --enable-64-bit-bfd

make -j$(nproc)

make install

make DESTDIR=$LFS install

cd ../..
rm -rf binutils