#!/bin/bash

set -e

./autogen.sh

./configure
make dist-xz -j$(nproc)
mv psmisc*.tar.xz ..
cd ..
rm -rf psmisc
tar xf psmisc*.tar.xz
rm -f psmisc*.tar.xz
mv psmisc* psmisc