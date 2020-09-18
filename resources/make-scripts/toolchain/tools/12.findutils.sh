#!/bin/bash

set -e

tar xvf findutils.tar.gz
cd findutils

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$(nproc)

make DESTDIR=$LFS install

mv -v $LFS/usr/bin/find $LFS/bin
sed -i 's|find:=${BINDIR}|find:=/bin|' $LFS/usr/bin/updatedb

cd ../
rm -rf findutils
