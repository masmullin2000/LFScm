#!/bin/bash

set -e

./gitsub.sh pull
./autogen.sh
./configure
make -j$(nproc)
make dist-xz
mv gettext*.tar.xz ..
cd ..
rm -rf gettext
tar xf gettext*.tar.xz
rm -f gettext*.tar.xz
mv gettext* gettext