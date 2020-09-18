#!/bin/bash

set -e

tar xf htop.tar.gz
cd htop

./autogen.sh
./configure --prefix=/usr
make -j$(nproc)

make install

cd ..
rm -rf htop

