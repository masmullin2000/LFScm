#!/bin/bash

set -e

tar xf coreutils-8.31.tar.xz
cd coreutils-8.31

patch -Np1 -i ../coreutils-8.31-i18n-1.patch

sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk

autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime

make -j$(nproc)

#make NON_ROOT_USERNAME=nobody check-root -j$(nproc)
#echo "dummy:x:1000:nobody" >> /etc/group
#chown -Rv nobody . 
#su nobody -s /bin/bash \
 #         -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check -j$(nproc)"

#sed -i '/dummy/d' /etc/group

make install

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8

mv -v /usr/bin/{head,nice,sleep,touch,mv} /bin

cd ../
rm -rf coreutils-8.31