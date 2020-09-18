#!/bin/bash

set -e

./bootstrap --copy --gnulib-srcdir=../gnulib
FORCE_UNSAFE_CONFIGURE=1 ./configure
rm -rf .git
make distdir -j$(nproc)
make dist-xz
mv coreutils*.tar.xz ..
cd ..
rm -rf coreutils
tar xf coreutils*.tar.xz
rm coreutils*.tar.xz
mv coreutils* coreutils
cd coreutils
touch .git
