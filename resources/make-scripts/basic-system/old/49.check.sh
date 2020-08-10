#!/bin/bash

set -e

tar xf check-0.14.0.tar.gz
cd check-0.14.0

./configure --prefix=/usr

make -j$(nproc)

#make check -j$(nproc)

make docdir=/usr/share/doc/check-0.14.0 install && sed -i '1 s/tools/usr/' /usr/bin/checkmk

cd ../
rm -rf check-0.14.0