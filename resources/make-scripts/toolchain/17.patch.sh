#!/bin/bash

tar xvf patch-2.7.6.tar.xz
cd patch-2.7.6

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf patch-2.7.6