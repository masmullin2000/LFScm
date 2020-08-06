#!/bin/bash

set -e

tar xf less-551.tar.gz
cd less-551

./configure --prefix=/usr --sysconfdir=/etc

make -j$(nproc)

make install

cd ../
rm -rf less-551
