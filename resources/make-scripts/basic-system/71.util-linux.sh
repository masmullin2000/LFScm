#!/bin/bash

set -e

tar xf util-linux.tar.gz
cd util-linux

mkdir -pv /var/lib/hwclock

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.36 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python

make -j$(nproc)

#bash tests/run.sh --srcdir=$PWD --builddir=$PWD

#chown -Rv tester .
#su tester -c "make -k check"

make install

cd ../
rm -rf util-linux

