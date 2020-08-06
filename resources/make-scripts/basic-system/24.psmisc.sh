#!/bin/bash

set -e

tar xf psmisc-23.2.tar.xz
cd psmisc-23.2

./configure --prefix=/usr

make -j$(nproc)

make install

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin

cd ../
rm -rf psmisc-23.2