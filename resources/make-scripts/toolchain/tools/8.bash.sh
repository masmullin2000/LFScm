#!/bin/bash

set -e

tar xvf bash.tar.gz
cd bash

./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc

make -j$(nproc)

make DESTDIR=$LFS install

mv $LFS/usr/bin/bash $LFS/bin/bash
ln -sv bash $LFS/bin/sh

cd ../
rm -rf bash
