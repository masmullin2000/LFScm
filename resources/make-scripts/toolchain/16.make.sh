#!/bin/bash

tar xvf make-4.3.tar.gz
cd make-4.3

./configure --prefix=/tools --without-guile

make -j$(nproc)

make install

cd ../
rm -rf make-4.3