#!/bin/bash

set -e

tar xf bash-5.0.tar.gz
cd bash-5.0

patch -Np1 -i ../bash-5.0-upstream_fixes-1.patch

./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.0 \
            --without-bash-malloc            \
            --with-installed-readline

make -j$(nproc)

#chown -Rv nobody .
#su nobody -s /bin/bash -c "PATH=$PATH HOME=/home make tests -j$(nproc)"

make install
mv -vf /usr/bin/bash /bin

cd ..
rm -rf bash-5.0
