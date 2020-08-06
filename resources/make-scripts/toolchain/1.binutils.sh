#!/bin/bash

tar xvf binutils-2.34.tar.xz
cd binutils-2.34

mkdir -v build
cd build

../configure --prefix=/tools            \
             --with-sysroot=$LFS        \
             --with-lib-path=/tools/lib \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror

make -j$(nproc)

case $(uname -m) in
  x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac

make install

cd ../../
rm -rf binutils-2.34