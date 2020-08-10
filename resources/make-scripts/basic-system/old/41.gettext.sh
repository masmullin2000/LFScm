#!/bin/bash

set -e

tar xf gettext-0.20.1.tar.xz
cd gettext-0.20.1

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.20.1

make -j$(nproc)

#make check -j$(nproc)

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

cd ../
rm -rf gettext-0.20.1