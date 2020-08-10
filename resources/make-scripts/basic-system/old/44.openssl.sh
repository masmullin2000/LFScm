#!/bin/bash

set -e

tar xf openssl-1.1.1d.tar.gz
cd openssl-1.1.1d


./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic

make -j$(nproc)

#make test -j$(nproc)

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1d
cp -vfr doc/* /usr/share/doc/openssl-1.1.1d

cd ../
rm -rf openssl-1.1.1d