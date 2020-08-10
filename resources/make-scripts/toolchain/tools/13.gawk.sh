#!/bin/bash

set -e

tar xvf gawk.tar.gz
cd gawk

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./config.guess)

make -j$(nproc)

make DESTDIR=$LFS install

cd ../
rm -rf gawk