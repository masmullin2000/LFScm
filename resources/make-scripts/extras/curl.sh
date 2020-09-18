#!/bin/bash

set -e

tar xf curl.tar.gz
cd curl

autoreconf -fi
./configure --prefix=/usr                           \
            --disable-static                        \
            --enable-threaded-resolver              \
            --with-ca-path=/etc/ssl/certs

make -j$(nproc)
make install

cd ../
rm -rf curl
