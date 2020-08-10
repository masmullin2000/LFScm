#!/bin/bash

set -e

tar xf glibc.tar.gz
cd glibc

patch -Np1 -i ../glibc-2.32-fhs-1.patch

mkdir -v build
cd       build

../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/lib

make -j$(nproc)

case $(uname -m) in
  i?86)   ln -sfnv $PWD/elf/ld-linux.so.2        /lib ;;
  x86_64) ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib ;;
esac

#make check -j$(nproc)

touch /etc/ld.so.conf

sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make install

cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service /lib/systemd/system/nscd.service

mkdir -pv /usr/lib/locale
# localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
# localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
# localedef -i de_DE -f ISO-8859-1 de_DE
# localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
# localedef -i de_DE -f UTF-8 de_DE.UTF-8
# localedef -i el_GR -f ISO-8859-7 el_GR
# localedef -i en_GB -f UTF-8 en_GB.UTF-8
# localedef -i en_HK -f ISO-8859-1 en_HK
# localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
# localedef -i es_MX -f ISO-8859-1 es_MX
# localedef -i fa_IR -f UTF-8 fa_IR
# localedef -i fr_FR -f ISO-8859-1 fr_FR
# localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
# localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
# localedef -i it_IT -f ISO-8859-1 it_IT
# localedef -i it_IT -f UTF-8 it_IT.UTF-8
# localedef -i ja_JP -f EUC-JP ja_JP
# localedef -i ja_JP -f SHIFT_JIS ja_JP.SIJS 2> /dev/null || true
# localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
# localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
# localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
# localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
# localedef -i zh_CN -f GB18030 zh_CN.GB18030
# localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS

#make localedata/install-locales

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ../../tzdata.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO

#tzselect

ln -sfv /usr/share/zoneinfo/Canada/Eastern /etc/localtime

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib
EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF

mkdir -pv /etc/ld.so.conf.d

cd ../../
rm -rf glibc




