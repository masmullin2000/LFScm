#!/bin/bash

set -e

tar xf make.tar.gz
cd make

# tip of make scm has some compile errors due to -Werror (aug31/2020)
CFLAGS="-Wno-unused-result -Wno-return-local-addr" \
./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf make
