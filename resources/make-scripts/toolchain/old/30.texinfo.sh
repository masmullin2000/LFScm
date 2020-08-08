#!/bin/bash

tar xvf texinfo-6.7.tar.xz
cd texinfo-6.7

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf texinfo-6.7