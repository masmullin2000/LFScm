#!/bin/bash

tar xvf glibc-2.31.tar.xz
cd glibc-2.31

mkdir -v build
cd       build

../configure                             \
      --prefix=/tools                    \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=/tools/include

make -j$(nproc)

make install

cd ../..
rm -rf glibc-2.31