#!/bin/bash

set -e

GNULIB_SRCDIR=../gnulib ./bootstrap --copy
FORCE_UNSAFE_CONFIGURE=1 ./configure
make dist-xz
mv tar*.tar.xz ..
cd ..
rm -rf tar
tar xf tar*.tar.xz
rm -f tar*.tar.xz
mv tar* tar