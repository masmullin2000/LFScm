#!/bin/bash

set -e

tar xf libressl.tar.gz
cd libressl

CFLAGS="-Ofast -fstack-protector-all" \
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         --enable-nc           \
         shared                \
         zlib-dynamic

make -j$(nproc)

#make test -j$(nproc)

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv apps/nc/.libs/nc /bin/

#mv -v /usr/share/doc/openssl /usr/share/doc/openssl
#cp -vfr doc/* /usr/share/doc/openssl

cd ../
rm -rf libressl