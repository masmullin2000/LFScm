#!/bin/bash

set -e

sed -i 's/2.2.53/69/g' configure.ac
./autogen.sh
./configure
make dist-xz
mv acl*.tar.xz ..
cd ..
rm -rf acl
tar xf acl*.tar.xz
rm acl*.tar.xz
mv acl* acl
cd acl
touch .git