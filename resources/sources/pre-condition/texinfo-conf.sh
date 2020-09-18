#!/bin/bash

set -e

./autogen.sh
./configure
make -j12
make dist-xz
mv texinfo*.tar.xz ..
cd ..
rm -rf texinfo
tar xf texinfo*.tar.xz
rm -f texinfo*.tar.xz
mv texinfo* texinfo
