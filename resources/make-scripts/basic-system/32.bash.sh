#!/bin/bash

set -e

tar xf bash.tar.gz
cd bash

#patch -Np1 -i ../bash-5.0-upstream_fixes-1.patch

./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.0 \
            --without-bash-malloc            \
            --with-installed-readline

# on machines with an extreme amount of cpu, bash has problems
# change due to testing on amazon aws 32 core machine
#make -j$(nproc)
make -j12

#chown -Rv tester .
#su tester << EOF
#PATH=$PATH make tests < $(tty)
#EOF

make install
mv -vf /usr/bin/bash /bin

cd ..
rm -rf bash
