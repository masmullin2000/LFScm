#!/bin/bash

set -e

tar xf iproute.tar.gz
cd iproute

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

sed -i 's/.m_ipt.o//' tc/Makefile

make -j$(nproc)

make DOCDIR=/usr/share/doc/iproute2-5.7.0 install

cd ../
rm -rf iproute