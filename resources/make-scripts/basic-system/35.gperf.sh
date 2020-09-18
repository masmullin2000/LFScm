#!/bin/bash

set -e

tar xf gperf.tar.gz
cd gperf

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1

make -j$(nproc)

#make -j1 check

make install

cd ../
rm -rf gperf