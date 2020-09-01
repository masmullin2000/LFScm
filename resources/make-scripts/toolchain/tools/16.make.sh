#!/bin/bash

set -e

tar xvf make.tar.gz
cd make

# tip of make scm has some compile errors due to -Werror (aug31/2020)
CFLAGS="-Wno-unused-result -Wno-return-local-addr" \
./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$(nproc)

make DESTDIR=$LFS install

cd ../
rm -rf make