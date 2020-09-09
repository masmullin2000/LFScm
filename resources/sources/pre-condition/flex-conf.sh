#!/bin/bash

set -e

./autogen.sh
./configure
make dist-xz
mv flex*.tar.xz ..
cd ..
rm -rf flex
tar xf flex*.tar.xz
rm flex*.tar.xz
mv flex* flex