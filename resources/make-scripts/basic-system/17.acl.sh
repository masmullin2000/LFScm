#!/bin/bash

set -e

tar xf acl-2.2.53.tar.gz
cd acl-2.2.53

./configure --prefix=/usr         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl-2.2.53

make -j$(nproc)

make install

mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so

cd ../
rm -rf acl-2.2.53