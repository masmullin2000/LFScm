#!/bin/bash

set -e

tar xf iana-etc-2.30.tar.bz2
cd iana-etc-2.30

make -j$(nproc)

make install

cd ../
rm -rf iana-etc-2.30