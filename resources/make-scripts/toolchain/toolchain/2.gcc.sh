#!/bin/bash

set -e

me=$(basename "$0" | sed 's/.sh//g')

while [[ ! -f "$LFS"/completed/1.binutils ]]; do
    sleep 5
done

touch "$LFS"/completed/started.$me


tar xvf gcc.tar.gz
cd gcc

tar -xf ../mpfr.tar.gz
#mv -v mpfr-4.1.0 mpfr
tar -xf ../gmp.tar.gz
#mv -v gmp-6.2.0 gmp
tar -xf ../mpc.tar.gz
#mv -v mpc-1.1.0 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build
cd       build

../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=$LFS/tools                            \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++

make -j$(nproc)

make install

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

cd ../
rm -rf gcc

rm -f "$LFS"/completed/started.$me
touch "$LFS"/completed/$me
