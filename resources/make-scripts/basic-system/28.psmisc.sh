#!/bin/bash

set -e

tar xf psmisc.tar.gz
cd psmisc

./configure --prefix=/usr

make -j$(nproc)

make install

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin

cd ../
rm -rf psmisc