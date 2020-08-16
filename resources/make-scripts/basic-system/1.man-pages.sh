#!/bin/bash

set -e

tar xf man.tar.gz
cd man

make install

cd ../
rm -rf man