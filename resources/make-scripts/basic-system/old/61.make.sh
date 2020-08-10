#!/bin/bash

set -e

tar xf make-4.3.tar.gz
cd make-4.3

./configure --prefix=/usr

make -j$(nproc)

#make PERL5LIB=$PWD/tests/ check -j$(nproc)

make install

cd ../
rm -rf make-4.3
