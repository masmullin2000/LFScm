#!/bin/bash

set -e

tar xvf linux.tar.gz
cd linux

make mrproper
make headers

find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/usr

cd ../
rm -rf linux