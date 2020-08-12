#!/bin/bash

set -e

tar xf pkg-config.tar.gz
cd pkg-config

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf pkg-config