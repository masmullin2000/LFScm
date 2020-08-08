#!/bin/bash

tar xvf bison-3.5.2.tar.xz
cd bison-3.5.2

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf bison-3.5.2
