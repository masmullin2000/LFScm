#!/bin/bash

set -e

tar xf libpcap.tar.gz
cd libpcap

./configure --prefix=/usr \
	--enable-bluetooth=no

sed -i '/INSTALL_DATA.*libpcap.a\|RANLIB.*libpcap.a/ s/^/#/' Makefile

make -j$(nproc)

make install

cd ..
rm -rf libpcap

