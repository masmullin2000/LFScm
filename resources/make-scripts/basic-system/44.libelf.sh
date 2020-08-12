#!/bin/bash

set -e

tar xf elfutils.tar.gz
cd elfutils


./configure --prefix=/usr --disable-debuginfod --libdir=/lib

make -j$(nproc)

#make check -j$(nproc)

make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /lib/libelf.a

cd ../
rm -rf elfutils