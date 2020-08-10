#!/bin/bash

set -e

tar xf man-db-2.9.0.tar.xz
cd man-db-2.9.0

sed -i '/find/s@/usr@@' init/systemd/man-db.service.in

./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.9.0 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap

make -j$(nproc)

#make check -j$(nproc)

make install

cd ..
rm -rf man-db-2.9.0