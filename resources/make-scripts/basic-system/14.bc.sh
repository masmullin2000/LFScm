#!/bin/bash

set -e

tar xf bc.tar.gz
cd bc

PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3

make -j$(nproc)

#make test -j$(nproc)

make install

cd ../
rm -rf bc