#!/bin/bash

set -e

tar xf p11-kit.tar.gz
cd p11-kit

sed '20,$ d' -i trust/trust-extract-compat.in

cat >> trust/trust-extract-compat.in << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Generate a new trust store
/usr/sbin/make-ca -f -g
EOF

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-trust-paths=/etc/pki/anchors

make -j$(nproc)

#make check -j$(nproc)

make install

ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates

ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so

cd ../
rm -rf p11-kit
