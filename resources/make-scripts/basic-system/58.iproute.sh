#!/bin/bash

set -e

tar xf iproute2-5.5.0.tar.xz
cd iproute2-5.5.0

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

sed -i 's/.m_ipt.o//' tc/Makefile

make -j$(nproc)

make DOCDIR=/usr/share/doc/iproute2-5.5.0 install

cd ../
rm -rf iproute2-5.5.0