#!/bin/bash

tar xvf ncurses-6.2.tar.gz
cd ncurses-6.2

sed -i s/mawk// configure

./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite

make -j$(nproc)

make install
ln -s libncursesw.so /tools/lib/libncurses.so

cd ../
rm -rf ncurses-6.2
