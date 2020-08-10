#!/bin/bash

set -e

tar xf libcap-2.31.tar.xz
cd libcap-2.31

sed -i '/install.*STA...LIBNAME/d' libcap/Makefile

make lib=lib -j$(nproc)

#make test -j$(nproc)

make lib=lib install
chmod -v 755 /lib/libcap.so.2.31

cd ../
rm -rf libcap-2.31