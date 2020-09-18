#!/bin/bash

set -e

tar xf libcap.tar.gz
cd libcap

sed -i '/install -m.*STACAPLIBNAME/d' libcap/Makefile

make lib=lib -j$(nproc)

#make test -j$(nproc)

make lib=lib PKGCONFIGDIR=/usr/lib/pkgconfig install
chmod -v 755 /lib/libcap.so*
mv -v /lib/libpsx.a /usr/lib
rm -v /lib/libcap.so
ln -sfv ../../lib/libcap.so.2 /usr/lib/libcap.so

cd ../
rm -rf libcap