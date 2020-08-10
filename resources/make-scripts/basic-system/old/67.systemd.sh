#!/bin/bash

set -e

tar xf systemd-244.tar.gz
cd systemd-244

ln -sf /tools/bin/true /usr/bin/xsltproc

for file in /tools/lib/lib{blkid,mount,uuid}.so*; do
    ln -sf $file /usr/lib/
done

tar -xf ../systemd-man-pages-244.tar.xz

sed '177,$ d' -i src/resolve/meson.build

sed -i 's/GROUP="render", //' rules.d/50-udev-default.rules.in

mkdir -p build
cd       build

PKG_CONFIG_PATH="/usr/lib/pkgconfig:/tools/lib/pkgconfig" \
LANG=en_US.UTF-8                   \
meson --prefix=/usr                \
      --sysconfdir=/etc            \
      --localstatedir=/var         \
      -Dblkid=true                 \
      -Dbuildtype=release          \
      -Ddefault-dnssec=no          \
      -Dfirstboot=false            \
      -Dinstall-tests=false        \
      -Dkmod-path=/bin/kmod        \
      -Dldconfig=false             \
      -Dmount-path=/bin/mount      \
      -Drootprefix=                \
      -Drootlibdir=/lib            \
      -Dsplit-usr=true             \
      -Dsulogin-path=/sbin/sulogin \
      -Dsysusers=false             \
      -Dumount-path=/bin/umount    \
      -Db_lto=false                \
      -Drpmmacrosdir=no            \
      ..

LANG=en_US.UTF-8 ninja

LANG=en_US.UTF-8 ninja install

rm -f /usr/bin/xsltproc

systemd-machine-id-setup

systemctl preset-all

systemctl disable systemd-time-wait-sync.service

rm -fv /usr/lib/lib{blkid,uuid,mount}.so*

cd ../../
rm -rf systemd-244