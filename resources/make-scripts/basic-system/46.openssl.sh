#!/bin/bash

set -e

tar xf openssl.tar.gz
cd openssl


./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic

make -j$(nproc)

#make test -j$(nproc)

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

#mv -v /usr/share/doc/openssl /usr/share/doc/openssl
#cp -vfr doc/* /usr/share/doc/openssl

cd ../
rm -rf openssl