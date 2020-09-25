#!/bin/bash

set -e

me=$(basename "$0" | sed 's/.sh//g')
touch "$LFS"/completed/started.$me

tar xvf linux.tar.gz
cd linux

make mrproper
make headers

find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/usr

cd ../
rm -rf linux

rm -f "$LFS"/completed/started.$me
touch "$LFS"/completed/$me
