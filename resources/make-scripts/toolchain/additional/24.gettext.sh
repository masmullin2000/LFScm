#!/bin/bash

set -e

tar xvf gettext.tar.gz
cd gettext

./configure --disable-shared

make -j$(nproc)

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext,msgconv} /usr/bin

cd ../
rm -rf gettext