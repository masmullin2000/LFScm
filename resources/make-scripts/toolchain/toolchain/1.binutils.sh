#!/bin/bash

set -e

me=$(basename "$0" | sed 's/.sh//g')
touch "$LFS"/completed/started.$me

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

rm -f "$LFS"/completed/started.$me
touch "$LFS"/completed/$me