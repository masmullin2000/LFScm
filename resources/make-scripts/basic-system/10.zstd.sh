#!/bin/bash

set -e

tar xf zstd.tar.gz
cd zstd

make -j$(nproc)

make prefix=/usr install

rm -v /usr/lib/libzstd.a
mv -v /usr/lib/libzstd.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libzstd.so) /usr/lib/libzstd.so

cd ../
rm -rf zstd