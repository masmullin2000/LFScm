#!/bin/bash

set -e

tar xvf glibc.tar.gz
cd glibc

case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

if [[ -f "../glibc-2.32-fhs-1.patch" ]]; then
  patch -Np1 -i ../glibc-2.32-fhs-1.patch
fi

mkdir -v build
cd       build

../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=$LFS/usr/include    \
      libc_cv_slibdir=/lib

make -j$(nproc)

make DESTDIR=$LFS install

mkh=$(find $LFS/tools/libexec/gcc -name "mkheaders")
$mkh

cd ../..
rm -rf glibc

echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep '/ld-linux'

rm -v dummy.c a.out
