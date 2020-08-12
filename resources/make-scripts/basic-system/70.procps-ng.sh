#!/bin/bash

set -e

tar xf procps.tar.gz
cd procps

./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng        \
            --disable-static                         \
            --disable-kill                           \
            --with-systemd
make -j$(nproc)

#make check -j$(nproc)

make install

mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so

cd ../
rm -rf procps