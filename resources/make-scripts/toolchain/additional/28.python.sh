#!/bin/bash

set -e

tar xvf Python.tar.gz
cd Python

./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

#make -j$(nproc)
make -j4
make install

cd ..
rm -rf Python
