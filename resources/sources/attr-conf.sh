#!/bin/bash

set -e

./autogen.sh
./configure
make dist-xz
mv attr*.tar.xz ..
cd ..
rm -rf attr
tar xf attr*.tar.xz
rm -f attr*.tar.xz
mv attr* attr