#!/bin/bash

tar xvf xz-5.2.4.tar.xz
cd xz-5.2.4

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf xz-5.2.4