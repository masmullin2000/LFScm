#!/bin/bash

tar xvf findutils-4.7.0.tar.xz
cd findutils-4.7.0

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf findutils-4.7.0
