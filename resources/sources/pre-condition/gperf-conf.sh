#!/bin/bash

set -e

./autogen.sh
./configure
make -j12
make dist -j$(nproc)
mv gperf*.tar.gz ..
cd ..
rm -rf gperf
tar xf gperf*.tar.gz
rm -f gperf*.tar.gz
mv gperf* gperf