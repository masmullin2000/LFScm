#!/bin/bash

set -e

tar xf XML-Parser.tar.gz
cd XML-Parser

perl Makefile.PL

make -j$(nproc)

#make test -j$(nproc)

make install

cd ../
rm -rf XML-Parser