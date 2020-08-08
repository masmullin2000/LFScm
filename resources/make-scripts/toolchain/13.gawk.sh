#!/bin/bash

tar xvf gawk-5.0.1.tar.xz
cd gawk-5.0.1

./configure --prefix=/tools

make -j$(nproc)

make install

cd ../
rm -rf gawk-5.0.1