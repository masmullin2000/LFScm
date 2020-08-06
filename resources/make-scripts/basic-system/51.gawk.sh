#!/bin/bash

set -e

tar xf gawk-5.0.1.tar.xz
cd gawk-5.0.1

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

mkdir -v /usr/share/doc/gawk-5.0.1
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.0.1

cd ../
rm -rf gawk-5.0.1
