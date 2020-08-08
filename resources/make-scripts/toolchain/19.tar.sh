#!/bin/bash

tar xvf tar-1.32.tar.xz
cd tar-1.32

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf tar-1.32