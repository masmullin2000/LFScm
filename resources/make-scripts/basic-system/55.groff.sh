#!/bin/bash 

set -e

tar xf groff.tar.gz
cd groff

PAGE=letter ./configure --prefix=/usr

make -j1

make install

cd ..
rm -rf groff

