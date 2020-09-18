#!/bin/bash

set -e

tar xf make-ca.tar.gz
cd make-ca

make install

install -vdm755 /etc/ssl/local

#systemctl enable update-pki.timer

cd ../
rm -rf make-ca