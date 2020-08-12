#!/bin/bash

set -e

tar xf attr.tar.gz
cd attr

./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48

make -j$(nproc)

#make check -j$(nproc)

make install

mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

cd ../
rm -rf attr