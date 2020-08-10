#!/bin/bash

set -e

tar xvf dejagnu.tar.gz
cd dejagnu

./configure --prefix=/usr

makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi

make install -j$(nproc)

install -v -dm755  /usr/share/doc/dejagnu-1.6.2
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.2

# make check -j$(nproc)

cd ..
rm -rf dejagnu