#!/bin/bash

set -e

tar xf patch.tar.gz
cd patch

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf patch

