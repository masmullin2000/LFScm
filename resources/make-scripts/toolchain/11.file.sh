#!/bin/bash

tar xvf file-5.38.tar.gz
cd file-5.38

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf file-5.38