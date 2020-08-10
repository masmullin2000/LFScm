#!/bin/bash

set -e

tar xvf binutils.tar.gz
cd binutils

mkdir -v build
cd build

../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS        \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror

make -j$(nproc)

make install

cd ../../
rm -rf binutils