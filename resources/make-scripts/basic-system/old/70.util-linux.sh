#!/bin/bash

set -e

tar xf util-linux-2.35.1.tar.xz
cd util-linux-2.35.1

mkdir -pv /var/lib/hwclock

rm -vf /usr/include/{blkid,libmount,uuid}

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.35.1 \
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

#chown -Rv nobody .
#su nobody -s /bin/bash -c "PATH=$PATH make -k check -j$(nproc)"

make install

cd ../
rm -rf util-linux-2.35.1

