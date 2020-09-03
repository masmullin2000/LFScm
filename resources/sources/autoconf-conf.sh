#!/bin/bash

set -e

echo "2.70" > .version
echo "2.70" > .tarball-version

autoreconf -vi
./configure
make -j$(nproc)
make dist-xz -j$(nproc)
mv autoconf*.tar.xz ..
cd ..
rm -rf autoconf
tar xf autoconf*tar.xz
rm -f autoconf*.tar.xz
mv autoconf* autoconf

