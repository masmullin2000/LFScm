#!/bin/bash
set -e

tar xvf man-pages-5.05.tar.xz
cd man-pages-5.05

make install

cd ../
rm -rf man-pages-5.05