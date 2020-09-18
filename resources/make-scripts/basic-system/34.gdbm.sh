#!/bin/bash

set -e

tar xf gdbm.tar.gz
cd gdbm

sed -r -i '/^char.*parseopt_program_(doc|args)/d' src/parseopt.c

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf gdbm

