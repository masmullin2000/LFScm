#!/bin/bash

tar xvf coreutils-8.31.tar.xz
cd coreutils-8.31

./configure --prefix=/tools --enable-install-program=hostname

make -j$(nproc)

make install

cd ../
rm -rf coreutils-8.31
