#!/bin/bash

set -e

tar xf flex.tar.gz
cd flex

./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4

#make clean
make #-j$(nproc)

#make check -j$(nproc)

make install

ln -sv flex /usr/bin/lex

cd ../
rm -rf flex