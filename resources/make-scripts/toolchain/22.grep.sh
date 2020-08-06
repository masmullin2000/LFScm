#!/bin/bash

tar xvf grep-3.4.tar.xz
cd grep-3.4

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf grep-3.4