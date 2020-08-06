#!/bin/bash

set -e

tar xf meson-0.53.1.tar.gz
cd meson-0.53.1

python3 setup.py build

python3 setup.py install --root=dest
cp -rv dest/* /

cd ../
rm -rf meson-0.53.1