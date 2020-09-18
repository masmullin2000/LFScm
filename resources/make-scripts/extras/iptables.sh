#!/bin/bash

set -e

tar xf iptables.tar.gz
cd iptables

./autogen.sh
./configure --prefix=/usr      \
            --sbindir=/sbin    \
            --disable-nftables \
            --enable-libipq    \
            --with-xtlibdir=/lib/xtables

make -j$(nproc)

make install
ln -sfv ../../sbin/xtables-legacy-multi /usr/bin/iptables-xml

for file in ip4tc ip6tc ipq xtables
do
  mv -v /usr/lib/lib${file}.so.* /lib 
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done

cd ..
rm -rf iptables

