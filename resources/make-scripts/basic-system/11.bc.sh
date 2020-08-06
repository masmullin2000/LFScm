#!/bin/bash

set -e

tar xf bc-2.5.3.tar.gz
cd bc-2.5.3

PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3

make -j$(nproc)

#make test -j$(nproc)

make install

cd ../
rm -rf bc-2.5.3