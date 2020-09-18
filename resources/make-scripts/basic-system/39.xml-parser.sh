#!/bin/bash

set -e

tar xf XML.tar.gz
cd XML

perl Makefile.PL

make -j$(nproc)

#make test -j$(nproc)

make install

cd ../
rm -rf XML