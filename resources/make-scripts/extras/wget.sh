#!/bin/bash

set -e

tar xf wget.tar.gz
cd wget

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf wget