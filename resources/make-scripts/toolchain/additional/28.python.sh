#!/bin/bash

tar xvf Python.tar.gz
cd Python

./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

make -j$(nproc)

make install

cd ..
rm -rf Python
