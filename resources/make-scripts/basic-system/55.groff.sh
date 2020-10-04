#!/bin/bash 

set -e

tar xf groff.tar.gz
cd groff

export CFLAGS=$(echo $CFLAGS | sed 's/Ofast/O3/g')

PAGE=letter ./configure --prefix=/usr

make -j1

make install

cd ..
rm -rf groff

