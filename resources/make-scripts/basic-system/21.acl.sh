#!/bin/bash

set -e

tar xf acl.tar.gz
cd acl

./configure --prefix=/usr         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl

make -j$(nproc)

make install

mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so

cd ../
rm -rf acl