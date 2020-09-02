#!/bin/bash

set -e

tar xf bison.tar.gz
cd bison

./configure --prefix=/usr --docdir=/usr/share/doc/bison

make -j$(nproc)

make install

cd ../
rm -rf bison

