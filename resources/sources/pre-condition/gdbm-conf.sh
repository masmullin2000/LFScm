#!/bin/bash

set -e

./bootstrap
./configure
make dist-xz -j$(nproc)
mv gdbm*.tar.xz ..
cd ..
rm -rf gdbm
tar xf gdbm*.tar.xz
rm -f gdbm*.tar.xz
mv gdbm* gdbm