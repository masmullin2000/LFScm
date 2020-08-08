#!/bin/bash

tar xvf sed-4.8.tar.xz
cd sed-4.8

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf sed-4.8