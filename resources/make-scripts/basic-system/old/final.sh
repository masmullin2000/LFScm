#!/bin/bash

rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libfl.a
rm -f /usr/lib/libz.a

find /usr/lib /usr/libexec -name \*.la -delete

cp basic-system/10-eth-dhcp.network /etc/systemd/network/
ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf
echo "LFS" > /etc/hostname
cp basic-system/hosts /etc/hosts
cp basic-system/locale.conf /etc/locale.conf
cp basic-system/inputrc /etc/inputrc
cp basic-system/shells /etc/shells
cp basic-system/fstab /etc/fstab

cd /sources && /basic-system/100.kernel.sh

grub-install --target=i386-pc /dev/loop0
mkdir -p /boot/grub/
cp /basic-system/grub.cfg /boot/grub/grub.cfg
sync