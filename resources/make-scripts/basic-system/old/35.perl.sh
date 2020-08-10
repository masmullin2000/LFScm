#!/bin/bash

set -e

tar xf perl-5.30.1.tar.xz
cd perl-5.30.1

echo "127.0.0.1 localhost $(hostname)" > /etc/hosts

export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib                  \
                  -Dusethreads

make -j$(nproc)

#make test -j$(nproc)

make install
unset BUILD_ZLIB BUILD_BZIP2

cd ../
rm -rf perl-5.30.1