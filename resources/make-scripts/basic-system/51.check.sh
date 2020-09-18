#!/bin/bash

set -e

tar xf check.tar.gz
cd check

./configure --prefix=/usr --disable-static

make -j$(nproc)

#make check -j$(nproc)

make docdir=/usr/share/doc/check-0.15.1 install

cd ../
rm -rf check