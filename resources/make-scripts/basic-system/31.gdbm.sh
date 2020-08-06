#!/bin/bash

set -e

tar xf gdbm-1.18.1.tar.gz
cd gdbm-1.18.1

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf gdbm-1.18.1

