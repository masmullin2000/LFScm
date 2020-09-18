#!/bin/bash

set -e

tar xf meson.tar.gz
cd meson

python3 setup.py build

python3 setup.py install --root=dest
cp -rv dest/* /

cd ../
rm -rf meson