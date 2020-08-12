#!/bin/bash

set -e

tar xf findutils.tar.gz
cd findutils

./configure --prefix=/usr --localstatedir=/var/lib/locate

make -j$(nproc)

#chown -Rv tester .
#su tester -c "PATH=$PATH make check -j$(nproc)"

make install

mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb

cd ../
rm -rf findutils