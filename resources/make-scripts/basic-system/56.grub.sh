#!/bin/bash

set -e

tar xf grub.tar.gz
cd grub

unset CFLAGS
./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror

make -j$(nproc)

make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

cd ../
rm -rf grub
