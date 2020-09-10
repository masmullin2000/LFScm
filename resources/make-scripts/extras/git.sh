#!/bin/bash

set -e

tar xf git.tar.gz
cd git

make configure
./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3

make -j$(nproc)
make perllibdir=/usr/lib/perl5/5.32/site_perl install

cd ../
rm -rf git
