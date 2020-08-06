#!/bin/bash

set -e

tar xf expat-2.2.9.tar.xz
cd expat-2.2.9

sed -i 's|usr/bin/env |bin/|' run.sh.in

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.9

make -j$(nproc)

#make check -j$(nproc)

make install

install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.9

cd ../
rm -rf expat-2.2.9
