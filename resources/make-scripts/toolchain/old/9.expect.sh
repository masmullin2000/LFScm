#!/bin/bash

tar xvf expect5.45.4.tar.gz
cd expect5.45.4

cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure

./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include

make -j$(nproc)

make SCRIPTS="" install

cd ../
rm -rf expect5.45.4