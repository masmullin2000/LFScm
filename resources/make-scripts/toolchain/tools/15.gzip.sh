#!/bin/bash

set -e

tar xvf gzip.tar.gz
cd gzip

./configure --prefix=/usr --host=$LFS_TGT

make -j$(nproc)

make DESTDIR=$LFS install

mv -v $LFS/usr/bin/gzip $LFS/bin

cd ../
rm -rf gzip