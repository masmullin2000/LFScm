#!/bin/bash

set -e

tar xf kbd.tar.gz
cd kbd

if [[ -f "../kbd-2.3.0-backspace-1.patch" ]]; then
	patch -Np1 -i ../kbd-2.3.0-backspace-1.patch
fi

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make -j$(nproc)

#make check -j$(nproc)

make install

set +e
rm -v /usr/lib/libtswrap.{a,la,so*}
set -e
cd ../
rm -rf kbd