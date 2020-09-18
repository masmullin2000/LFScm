#!/bin/bash

set -e

tar xf wireguard.tar.gz
cd wireguard

make -C src -j$(nproc)
make -C src install

cd ..
rm -rf wireguard