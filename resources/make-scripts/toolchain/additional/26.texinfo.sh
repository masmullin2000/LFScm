#!/bin/bash

tar xvf texinfo.tar.gz
cd texinfo

./configure --prefix=/usr

make -j$(nproc)

make install

cd ../
rm -rf texinfo