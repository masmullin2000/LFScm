#!/bin/bash

set -e

tar xf less.tar.gz
cd less

./configure --prefix=/usr --sysconfdir=/etc --with-editor=vim

make -j$(nproc)

make install

cd ../
rm -rf less
