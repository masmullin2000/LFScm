#!/bin/bash

set +e

sudo umount "$LFS"/boot
sudo umount "$LFS"
sudo losetup -d /dev/loop0
rm lfs.img

set -e

qemu-img create -f raw lfs.img 8G
sudo losetup -fP lfs.img
sudo sfdisk /dev/loop0 < loop.sfdisk
sudo mkswap /dev/loop0p1
sudo mkfs.ext4 /dev/loop0p2
sudo mkfs.ext4 /dev/loop0p3

mkdir -p "$LFS"
sudo mount /dev/loop0p3 "$LFS"
mkdir -p "$LFS"/boot
sudo mount /dev/loop0p2 "$LFS"/boot
mkdir -p "$LFS"/sources
chmod -v a+wt "$LFS"/sources
mkdir -p "$LFS"/tools
ln -sv "$LFS"/tools /

cp /build/sources/* "$LFS"/sources
cd "$LFS"/sources && md5sum -c md5sums

mv /build/config-scripts/bashrc /home/lfs/.bashrc
mv /build/config-scripts/bash_profile /home/lfs/.bash_profile
chown lfs:lfs /home/lfs/ -R
chown lfs:lfs /build/make-scripts/toolchain/ -R

chown -v lfs "$LFS"/tools
chown -v lfs "$LFS"/sources
if test -f "/input/tools.tar.gz"
then
	tar xvf /input/tools.tar.gz -C "$LFS"/tools
else
	sudo -u lfs /bin/bash -c "/build/make-scripts/toolchain/build-toolchain.sh"
fi
chown -R root:root "$LFS"/tools

/build/make-scripts/basic-system/0.fs.sh

mkdir -p "$LFS"/basic-system/

cp -R /build/make-scripts/basic-system/* "$LFS"/basic-system/
cp /build/config-scripts/{hosts,locale.conf,inputrc,shells,fstab,10-eth-dhcp.network,passwd,group,grub.cfg} "$LFS"/basic-system/

chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h -c  "/tools/bin/mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt};
									/tools/bin/mkdir -pv /{media/{floppy,cdrom},sbin,srv,var};
									/tools/bin/install -dv -m 0750 /root;
									/tools/bin/install -dv -m 1777 /tmp /var/tmp;
									/tools/bin/mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src};
									/tools/bin/mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man};
									/tools/bin/mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo};
									/tools/bin/mkdir -v  /usr/libexec;
									/tools/bin/mkdir -pv /usr/{,local/}share/man/man{1..8};
									/tools/bin/mkdir -v  /usr/lib/pkgconfig;

									case $(uname -m) in
									 x86_64) /tools/bin/mkdir -v /lib64 ;;
									esac

									/tools/bin/mkdir -v /var/{log,mail,spool};
									/tools/bin/ln -sv /run /var/run;
									/tools/bin/ln -sv /run/lock /var/lock;
									/tools/bin/mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local};

									/tools/bin/ln -sv /tools/bin/{bash,cat,chmod,dd,echo,ln,mkdir,pwd,rm,stty,touch} /bin;
									/tools/bin/ln -sv /tools/bin/{env,install,perl,printf}         /usr/bin;
									/tools/bin/ln -sv /tools/lib/libgcc_s.so{,.1}                  /usr/lib;
									/tools/bin/ln -sv /tools/lib/libstdc++.{a,so{,.6}}             /usr/lib;

									/tools/bin/ln -sv bash /bin/sh;
									/tools/bin/ln -sv /proc/self/mounts /etc/mtab;
									/tools/bin/cp /basic-system/passwd /etc/passwd;
									/tools/bin/cp /basic-system/group /etc/group;
																	
									exec /tools/bin/bash --login +h -c \"/basic-system/system.sh\"
								   "

chroot "$LFS" /usr/bin/env -i          \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login -c   "/basic-system/final.sh"

set +e

#cp lfs.img /output/
rm -rf "$LFS"/sources
rm -rf "$LFS"/tools
rm -rf "$LFS"/basic-system

umount /dev/loop0p2
umount /dev/loop0p3

sudo losetup -d /dev/loop0

qemu-img convert -f raw -O qcow2 -c /build/lfs.img /output/lfs.qcow2
