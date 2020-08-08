#!/bin/bash

tar xvf dejagnu-1.6.2.tar.gz
cd dejagnu-1.6.2

./configure --prefix=/tools

make install -j$(nproc)

cd ..
rm -rf dejagnu-1.6.2