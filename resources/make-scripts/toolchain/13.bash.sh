#!/bin/bash

tar xvf bash-5.0.tar.gz
cd bash-5.0

./configure --prefix=/tools --without-bash-malloc

make -j$(nproc)

make install

ln -sv bash /tools/bin/sh

cd ../
rm -rf bash-5.0
