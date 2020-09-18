#!/bin/bash

set -e

tar xvf expect.tar.gz
cd expect

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make -j$(nproc)

#make test -j(nproc)

make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

cd ../
rm -rf expect