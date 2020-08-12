#!/bin/bash

set -e

tar xf dbus.tar.gz
cd dbus

./configure --prefix=/usr                       \
            --sysconfdir=/etc                   \
            --localstatedir=/var                \
            --disable-static                    \
            --disable-doxygen-docs              \
            --disable-xml-docs                  \
            --docdir=/usr/share/doc/dbus        \
            --with-console-auth-dir=/run/console

make -j$(nproc)

make install

mv -v /usr/lib/libdbus-1.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so

ln -sfv /etc/machine-id /var/lib/dbus
sed -i 's:/var/run:/run:' /lib/systemd/system/dbus.socket

cd ../
rm -rf dbus