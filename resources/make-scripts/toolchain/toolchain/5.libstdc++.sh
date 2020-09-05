#!/bin/bash

set -e

tar xvf gcc.tar.gz
cd gcc

mkdir -v build
cd       build

gcc_ver=$($LFS_TGT-gcc -dumpversion)

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$gcc_ver

make -j$(nproc)

make DESTDIR=$LFS install

cd ../..
rm -rf gcc
