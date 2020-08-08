#!/bin/bash

tar xvf util-linux-2.35.1.tar.xz
cd util-linux-2.35.1

./configure --prefix=/tools                \
            --without-python               \
            --disable-makeinstall-chown    \
            --without-systemdsystemunitdir \
            --without-ncurses              \
            PKG_CONFIG=""

make -j$(nproc)

make install

cd ../
rm -rf util-linux-2.35.1