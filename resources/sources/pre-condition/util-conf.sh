#!/bin/bash

set -e

echo "2.37" > .version
echo "2.37" > .tarball-version
./autogen.sh
./configure
make dist-xz -j$(nproc)
mv util*.tar.xz ..
cd ..
rm -rf util
tar xf util*.tar.xz
rm -f util*.tar.xz
mv util* util