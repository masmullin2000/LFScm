#!/bin/bash

tar xvf gzip-1.10.tar.xz
cd gzip-1.10

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf gzip-1.10