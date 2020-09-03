#!/bin/bash

set -e

tar xf gettext.tar.gz
cd gettext

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext

make -j$(nproc)

#make check -j$(nproc)

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

cd ../
rm -rf gettext