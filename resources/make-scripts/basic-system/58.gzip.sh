#!/bin/bash

set -e

tar xf gzip.tar.gz
cd gzip

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

mv -v /usr/bin/gzip /bin

cd ../
rm -rf gzip
