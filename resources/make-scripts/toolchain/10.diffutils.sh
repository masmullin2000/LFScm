#!/bin/bash

tar xvf diffutils-3.7.tar.xz
cd diffutils-3.7

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf diffutils-3.7
