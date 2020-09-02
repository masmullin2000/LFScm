#!/bin/bash

set -e

tar xf Python.tar.gz
cd Python

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes

make -j$(nproc)

make install
chmod -v 755 /usr/lib/libpython*.so
#chmod -v 755 /usr/lib/libpython3.so
pipver=(pip3.*)
ln -sfv "${pipver}" /usr/bin/pip3
ln -sfv /usr/bin/pip3 /usr/bin/pip
ln -sfv /usr/bin/python3 /usr/bin/python

install -v -dm755 /usr/share/doc/python/html 

if [[ -f "../python-3.8.5-docs-html.tar.bz2" ]]; then
	tar --strip-components=1  \
	    --no-same-owner       \
	    --no-same-permissions \
	    -C /usr/share/doc/python/html \
	    -xvf ../python-3.8.5-docs-html.tar.bz2
fi

cd ../
rm -rf Python