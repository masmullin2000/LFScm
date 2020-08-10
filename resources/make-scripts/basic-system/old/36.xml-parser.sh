#!/bin/bash

set -e

tar xf XML-Parser-2.46.tar.gz
cd XML-Parser-2.46

perl Makefile.PL

make -j$(nproc)

#make test -j$(nproc)

make install

cd ../
rm -rf XML-Parser-2.46