#!/bin/bash

set -e

tar xvf bash.tar.gz
cd bash

./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc

# on machines with an extreme amount of cpu, bash has problems
# change due to testing on amazon aws 32 core machine
#make -j$(nproc)
make -j12

make DESTDIR=$LFS install

mv $LFS/usr/bin/bash $LFS/bin/bash
ln -sv bash $LFS/bin/sh

cd ../
rm -rf bash
