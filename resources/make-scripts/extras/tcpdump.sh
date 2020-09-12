#!/bin/bash

set -e

tar xf tcpdump.tar.gz
cd tcpdump

./configure --prefix=/usr
make -j$(nproc)

make install

cd ..
rm -rf tcpdump

