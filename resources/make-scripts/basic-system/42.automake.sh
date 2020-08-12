#!/bin/bash

set -e

tar xf automake.tar.gz
cd automake


sed -i "s/''/etags/" t/tags-lisp-space.sh
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.2

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf automake