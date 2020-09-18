#!/bin/bash

set -e

tar xf readline.tar.gz
cd readline

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.0

make SHLIB_LIBS="-L/tools/lib -lncursesw" -j$(nproc)

make SHLIB_LIBS="-L/tools/lib -lncursesw" install

mv -v /usr/lib/lib{readline,history}.so.* /lib
chmod -v u+w /lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so

cd ../
rm -rf readline