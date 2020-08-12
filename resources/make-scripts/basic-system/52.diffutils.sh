#!/bin/bash

set -e

tar xf diffutils.tar.gz
cd diffutils

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make install

cd ../
rm -rf diffutils
