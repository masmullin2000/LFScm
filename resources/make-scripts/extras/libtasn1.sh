#!/bin/bash

set -e

tar xf libtasn1.tar.gz
cd libtasn1

./configure --prefix=/usr --disable-static

make -j$(nproc)

#make check -j$(nproc)

make install

make -C doc/reference install-data-local

cd ../
rm -rf libtasn1