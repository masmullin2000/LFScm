#!/bin/bash

set -e

tar xf gawk.tar.gz
cd gawk

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

mkdir -v /usr/share/doc/gawk-5.1.0
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.0

cd ../
rm -rf gawk
