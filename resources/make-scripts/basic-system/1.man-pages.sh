#!/bin/bash

set -e

tar xf man-pages.tar.gz
cd man-pages

make install

cd ../
rm -rf man-pages