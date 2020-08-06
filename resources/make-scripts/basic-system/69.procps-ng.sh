#!/bin/bash

set -e

tar xf procps-ng-3.3.15.tar.xz
cd procps-ng-3.3.15

./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng-3.3.15 \
            --disable-static                         \
            --disable-kill                           \
            --with-systemd

make -j$(nproc)

#sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
#sed -i '/set tty/d' testsuite/pkill.test/pkill.exp
#rm testsuite/pgrep.test/pgrep.exp
#make check -j$(nproc)

make install

mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so

cd ../
rm -rf procps-ng-3.3.15