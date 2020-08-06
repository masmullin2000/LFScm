#!/bin/bash

set -e

tar xf gzip-1.10.tar.xz
cd gzip-1.10

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

mv -v /usr/bin/gzip /bin

cd ../
rm -rf gzip-1.10
