#!/bin/bash

set -e

tar xf sed.tar.gz
cd sed

./configure --prefix=/usr --bindir=/bin

make -j$(nproc)
make html -j$(nproc)

#chown -Rv tester .
#su tester -c "PATH=$PATH make check -j$(nproc)"

make install
install -d -m755           /usr/share/doc/sed-4.8
install -m644 doc/sed.html /usr/share/doc/sed-4.8

cd ../
rm -rf sed