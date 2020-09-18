#/bin/bash

set -e

tar xf gcc.tar.gz
cd gcc

ln -s gthr-posix.h libgcc/gthr-default.h

mkdir -v build
cd       build

../libstdc++-v3/configure            \
    CXXFLAGS="-g -O2 -D_GNU_SOURCE"  \
    --prefix=/usr                    \
    --disable-multilib               \
    --disable-nls                    \
    --host=$(uname -m)-lfs-linux-gnu \
    --disable-libstdcxx-pch

make -j$(nproc)

make install

cd ../../
rm -rf gcc