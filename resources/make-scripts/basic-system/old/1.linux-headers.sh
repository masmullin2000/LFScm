#!/bin/bash

set -e

tar xf linux-5.5.3.tar.xz
cd linux-5.5.3


make mrproper
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile

cp -rv usr/include/* /usr/include

cd ../
rm -rf linux-5.5.3