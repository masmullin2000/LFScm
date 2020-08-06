#!/bin/bash

tar xvf gettext-0.20.1.tar.xz
cd gettext-0.20.1

./configure --disable-shared

make -j$(nproc)

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /tools/bin

cd ../
rm -rf gettext-0.20.1