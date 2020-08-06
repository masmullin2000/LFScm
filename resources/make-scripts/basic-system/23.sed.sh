#!/bin/bash

set -e

tar xf sed-4.8.tar.xz
cd sed-4.8

sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in

./configure --prefix=/usr --bindir=/bin

make -j$(nproc)
make html -j$(nproc)

#make check -j$(nproc)

make install
install -d -m755           /usr/share/doc/sed-4.8
install -m644 doc/sed.html /usr/share/doc/sed-4.8

cd ../
rm -rf sed-4.8