#!/bin/bash

set -e

while [[ ! -f "$LFS"/completed/4.glibc ]]; do
    sleep 5
done

me=$(basename "$0" | sed 's/.sh//g')
touch "$LFS"/completed/started.$me

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

rm -f "$LFS"/completed/started.$me
touch "$LFS"/completed/$me

