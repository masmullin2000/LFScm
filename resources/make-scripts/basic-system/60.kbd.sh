#!/bin/bash

set -e

tar xf kbd.tar.gz
cd kbd

patch -Np1 -i ../kbd-2.3.0-backspace-1.patch

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make -j$(nproc)

#make check -j$(nproc)

make install

rm -v /usr/lib/libtswrap.{a,la,so*}

cd ../
rm -rf kbd