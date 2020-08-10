#!/bin/bash

set -e

tar xf grub-2.04.tar.xz
cd grub-2.04

./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror

make -j$(nproc)

make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

cd ../
rm -rf grub-2.04