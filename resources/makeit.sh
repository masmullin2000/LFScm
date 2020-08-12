#!/bin/bash

BACKUP="no"
if [ -n "$1" ]
then
	BACKUP=$1
fi

function backup {
	if [ "$BACKUP" == "yes" ]
	then
		cd "$LFS"
		if [ "/output/all-sources.tar.xz" == $1 ]
		then
			cd "$LFS"/sources 
		fi
		tar --exclude='sources/*' --exclude='boot/*' --exclude='proc/*' \
			--exclude='basic-system' --exclude='sys/module/*' --exclude='sys/bus/*' \
			--exclude='sys/fs/*' -cf - . | xz -3 --threads=0 > $1

	fi
}

function setup_loop {

	local __ret=$1
	local LOOP_DEV=$(losetup -f)
	eval $__ret="'$LOOP_DEV'"

	set +e

	umount "$LFS"/boot
	umount "$LFS"

	losetup -d $"LOOP_DEV"

	rm lfs.img

	set -e

	qemu-img create -f raw lfs.img 15G
	losetup -fP lfs.img

	sfdisk "$LOOP_DEV" < loop.sfdisk
	mkswap "$LOOP_DEV"p1
	mkfs.ext4 "$LOOP_DEV"p2
	mkfs.ext4 "$LOOP_DEV"p3
}

function create_and_mount {
	local LOOP_DEV=$1

	mkdir -p "$LFS"
	mount "$LOOP_DEV"p3 "$LFS"
	rm -rf "$LFS"/*
	mkdir -p "$LFS"/boot
	mount "$LOOP_DEV"p2 "$LFS"/boot
	rm -rf "$LFS"/boot/*
	mkdir -p "$LFS"/sources
	chmod -v a+wt "$LFS"/sources

	mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var}
	case $(uname -m) in
  		x86_64) mkdir -pv $LFS/lib64 ;;
	esac

	mkdir -p "$LFS"/tools
	ln -sv "$LFS"/tools /
}

function fetch_sources {
	if test -f "/input/all-sources.tar.xz"
	then
		tar xvf /input/all-sources.tar.xz -C "$LFS"/sources
	else
		cd "$LFS"/sources
		/build/sources/fetch-scm.sh
		backup /output/all-sources.tar.xz
	fi
}

function make_toolchain {
	cd "$LFS"/sources

	mv /build/config-scripts/bashrc /home/lfs/.bashrc
	mv /build/config-scripts/bash_profile /home/lfs/.bash_profile
	chown lfs:lfs /home/lfs/ -R
	chown lfs:lfs /build/make-scripts/toolchain/ -R

	chown -vR lfs:lfs $LFS
	case $(uname -m) in
		x86_64) chown -v lfs $LFS/lib64 ;;
	esac

	chown -Rv lfs:lfs "$LFS"/sources
	sudo -u lfs /bin/bash -c "/build/make-scripts/toolchain/build-toolchain.sh $BACKUP"
	chown -R root:root "$LFS"
}

function make_vfs {
	set +e
	mount -v --bind /dev $LFS/dev

	mount -v --bind /dev/pts $LFS/dev/pts
	mount -vt proc proc $LFS/proc
	mount -vt sysfs sysfs $LFS/sys
	mount -vt tmpfs tmpfs $LFS/run
	if [ -h $LFS/dev/shm ]; then
		mkdir -pv $LFS/$(readlink $LFS/dev/shm)
	fi
	set -e
}

function make_temp_system {

	if test -f "/input/tools.tar.xz"
	then
		tar xvf /input/tools.tar.xz -C "$LFS"
	else
		make_toolchain

		mkdir -pv $LFS/{dev,proc,sys,run}
		mknod -m 600 $LFS/dev/console c 5 1
		mknod -m 666 $LFS/dev/null c 1 3
		make_vfs

		cp /build/config-scripts/passwd "$LFS"/etc/passwd
		cp /build/config-scripts/group 	"$LFS"/etc/group

		mkdir -p "$LFS"/additional
		cp /build/make-scripts/toolchain/build-additional.sh "$LFS"/additional/
		cp /build/make-scripts/toolchain/additional/*.sh "$LFS"/additional/

		chroot "$LFS" /usr/bin/env -i   \
		    HOME=/root                  \
		    TERM="$TERM"                \
		    PS1='(lfs chroot) \u:\w\$ ' \
		    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
		    /bin/bash --login +h -c "
				mkdir -pv /{boot,home,mnt,opt,srv}
				mkdir -pv /etc/{opt,sysconfig}
				mkdir -pv /lib/firmware
				mkdir -pv /media/{floppy,cdrom}
				mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
				mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
				mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
				mkdir -pv /usr/{,local/}share/man/man{1..8}
				mkdir -pv /var/{cache,local,log,mail,opt,spool}
				mkdir -pv /var/lib/{color,misc,locate}

				ln -sfv /run /var/run
				ln -sfv /run/lock /var/lock

				install -dv -m 0750 /root
				install -dv -m 1777 /tmp /var/tmp

				ln -sv /proc/self/mounts /etc/mtab
				echo "127.0.0.1 localhost $(hostname)" > /etc/hosts

				echo "tester:x:$(ls -n $(tty) | cut -d" " -f3):101::/home/tester:/bin/bash" >> /etc/passwd
				echo "tester:x:101:" >> /etc/group
				install -o tester -d /home/tester
				"

		chroot "$LFS" /usr/bin/env -i   \
		    HOME=/root                  \
		    TERM="$TERM"                \
		    PS1='(lfs chroot) \u:\w\$ ' \
		    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
		    /bin/bash --login +h -c "
		    	touch /var/log/{btmp,lastlog,faillog,wtmp}
				chgrp -v utmp /var/log/lastlog
				chmod -v 664  /var/log/lastlog
				chmod -v 600  /var/log/btmp

				/additional/build-additional.sh
				"

		umount $LFS/dev{/pts,}
		umount $LFS/{sys,proc,run}

set +e
		strip --strip-debug $LFS/usr/lib/*
		strip --strip-unneeded $LFS/usr/{,s}bin/*
		strip --strip-unneeded $LFS/tools/bin/*
set -e

		rm -rvf $LFS/usr/share/{info,man,doc}
		rm -rvf $LFS/additional

		backup /output/tools.tar.xz
	fi
}

function make_lfs_system_pt1 {
	if test -f "/input/system-pt1.tar.xz"
	then
		tar xf /input/system-pt1.tar.xz -C "$LFS"
	else
		make_temp_system

		make_vfs

		chroot "$LFS" /usr/bin/env -i   \
			HOME=/root                  \
			TERM="$TERM"                \
			PS1='(lfs chroot) \u:\w\$ ' \
			PATH=/bin:/usr/bin:/sbin:/usr/sbin \
			/bin/bash --login +h -c "
		    	/basic-system/build-system.sh 1 12
		    "
		backup /output/system-pt1.tar.xz
	fi
}

function make_lfs_system_pt2 {
	if test -f "/input/system-pt2.tar.xz"
	then
		tar xf /input/system-pt2.tar.xz -C "$LFS"
	else
		make_lfs_system_pt1

		make_vfs

		chroot "$LFS" /usr/bin/env -i   \
				HOME=/root                  \
				TERM="$TERM"                \
				PS1='(lfs chroot) \u:\w\$ ' \
				PATH=/bin:/usr/bin:/sbin:/usr/sbin \
				/bin/bash --login +h -c "
			    	/basic-system/build-system.sh 13 24
			    "
		backup /output/system-pt2.tar.xz
	fi
}

function make_lfs_system_pt3 {
	if test -f "/input/system-pt3.tar.xz"
	then
		tar xf /input/system-pt3.tar.xz -C "$LFS"
	else
		make_lfs_system_pt2

		make_vfs

		chroot "$LFS" /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$TERM"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin \
		/bin/bash --login +h -c "
	    	/basic-system/build-system.sh 25 32
	    "
		backup /output/system-pt3.tar.xz
	fi
}

function make_lfs_system_pt4 {
	if test -f "/input/system-pt4.tar.xz"
	then
		tar xf /input/system-pt4.tar.xz -C "$LFS"
	else
		make_lfs_system_pt3

		make_vfs

		chroot "$LFS" /usr/bin/env -i   \
			HOME=/root                  \
			TERM="$TERM"                \
			PS1='(lfs chroot) \u:\w\$ ' \
			PATH=/bin:/usr/bin:/sbin:/usr/sbin \
			/bin/bash --login +h -c "
				/basic-system/build-system.sh 33 45
			"
		backup /output/system-pt4.tar.xz
	fi
}

function make_lfs_system_pt5 {
	if test -f "/input/system-pt5.tar.xz"
	then
		tar xf /input/system-pt5.tar.xz -C "$LFS"
	else
		make_lfs_system_pt4

		make_vfs

		chroot "$LFS" /usr/bin/env -i   	\
			HOME=/root                 		\
			TERM="$TERM"               		\
			PS1='(lfs chroot) \u:\w\$ '		\
			PATH=/bin:/usr/bin:/sbin:/usr/sbin 	\
			/bin/bash --login +h -c "
		    	/basic-system/build-system.sh 46 60
		    "

		backup /output/system-pt5.tar.xz
	fi
}

function make_lfs_system_pt6 {
	if test -f "/input/system-pt6.tar.xz"
	then
		tar xf /input/system-pt6.tar.xz -C "$LFS"
	else
		make_lfs_system_pt5

		make_vfs

		chroot "$LFS" /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$TERM"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin \
		/bin/bash --login +h -c "
	    	/basic-system/build-system.sh 60 67
	    "
		backup /output/system-pt6.tar.xz
	fi		
}

function make_lfs_system_pt7 {
	if test -f "/input/system-pt7.tar.xz"
	then
		tar xf /input/system-pt7.tar.xz -C "$LFS"
	else
		make_lfs_system_pt6

		make_vfs

		chroot "$LFS" /usr/bin/env -i   \
		HOME=/root                  \
		TERM="$TERM"                \
		PS1='(lfs chroot) \u:\w\$ ' \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin \
		/bin/bash --login +h -c "
	    	/basic-system/build-system.sh 68 72
	    	/basic-system/99.strip.sh
	    	rm -rf /tmp/*
	    "

		backup /output/system-pt7.tar.xz
	fi		
}

function make_lfs_system_final {
	make_lfs_system_pt7

	cp /build/config-scripts/{config*,hosts,locale.conf,inputrc,shells,fstab,10-eth-dhcp.network,passwd,group,grub.cfg} "$LFS"/basic-system/
    make_vfs
    chroot "$LFS" /usr/bin/env -i          \
	    HOME=/root TERM="$TERM"            \
	    PS1='(lfs chroot) \u:\w\$ '        \
	    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	    /bin/bash --login -c "
	    	rm -f /usr/lib/lib{bfd,opcodes}.a
			rm -f /usr/lib/libctf{,-nobfd}.a
			rm -f /usr/lib/libbz2.a
			rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
			rm -f /usr/lib/libltdl.a
			rm -f /usr/lib/libfl.a
			rm -f /usr/lib/libz.a

			find /usr/lib /usr/libexec -name \*.la -delete
			find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
			userdel -r tester

			cp basic-system/10-eth-dhcp.network /etc/systemd/network/
			ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf
			echo "LFS" > /etc/hostname
			cp basic-system/hosts /etc/hosts
			cp basic-system/locale.conf /etc/locale.conf
			cp basic-system/inputrc /etc/inputrc
			cp basic-system/shells /etc/shells
			cp basic-system/fstab /etc/fstab

			cd /sources && /basic-system/100.kernel.sh 5.7.14

			grub-install --target=i386-pc $1
			mkdir -p /boot/grub/
			cp /basic-system/grub.cfg /boot/grub/grub.cfg
			sed -i 's/VERSION/5.7.14/g' /boot/grub/grub.cfg
			sync
		"
}

function make_lfs_system {
	mkdir -p "$LFS"/basic-system
	cp -R /build/make-scripts/basic-system/*.sh "$LFS"/basic-system
	chmod +x "$LFS"/basic-system	

	make_lfs_system_final $1

	cp lfs.img /output/
}

setup_loop val
create_and_mount $val
fetch_sources
make_lfs_system $val

# cp /build/sources/* "$LFS"/sources
# cd "$LFS"/sources && md5sum -c md5sums

# mv /build/config-scripts/bashrc /home/lfs/.bashrc
# mv /build/config-scripts/bash_profile /home/lfs/.bash_profile
# chown lfs:lfs /home/lfs/ -R
# chown lfs:lfs /build/make-scripts/toolchain/ -R

# chown -v lfs "$LFS"/tools
# chown -v lfs "$LFS"/sources
# if test -f "/input/tools.tar.gz"
# then
# 	tar xvf /input/tools.tar.gz -C "$LFS"/tools
# else
# 	sudo -u lfs /bin/bash -c "/build/make-scripts/toolchain/build-toolchain.sh"
# fi
# chown -R root:root "$LFS"/tools

# /build/make-scripts/basic-system/0.fs.sh

# mkdir -p "$LFS"/basic-system/

# cp -R /build/make-scripts/basic-system/* "$LFS"/basic-system/
# cp /build/config-scripts/{hosts,locale.conf,inputrc,shells,fstab,10-eth-dhcp.network,passwd,group,grub.cfg} "$LFS"/basic-system/

# chroot "$LFS" /tools/bin/env -i \
#     HOME=/root                  \
#     TERM="$TERM"                \
#     PS1='(lfs chroot) \u:\w\$ ' \
#     PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
#     /tools/bin/bash --login +h -c  "/tools/bin/mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt};
# 									/tools/bin/mkdir -pv /{media/{floppy,cdrom},sbin,srv,var};
# 									/tools/bin/install -dv -m 0750 /root;
# 									/tools/bin/install -dv -m 1777 /tmp /var/tmp;
# 									/tools/bin/mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src};
# 									/tools/bin/mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man};
# 									/tools/bin/mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo};
# 									/tools/bin/mkdir -v  /usr/libexec;
# 									/tools/bin/mkdir -pv /usr/{,local/}share/man/man{1..8};
# 									/tools/bin/mkdir -v  /usr/lib/pkgconfig;

# 									case $(uname -m) in
# 									 x86_64) /tools/bin/mkdir -v /lib64 ;;
# 									esac

# 									/tools/bin/mkdir -v /var/{log,mail,spool};
# 									/tools/bin/ln -sv /run /var/run;
# 									/tools/bin/ln -sv /run/lock /var/lock;
# 									/tools/bin/mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local};

# 									/tools/bin/ln -sv /tools/bin/{bash,cat,chmod,dd,echo,ln,mkdir,pwd,rm,stty,touch} /bin;
# 									/tools/bin/ln -sv /tools/bin/{env,install,perl,printf}         /usr/bin;
# 									/tools/bin/ln -sv /tools/lib/libgcc_s.so{,.1}                  /usr/lib;
# 									/tools/bin/ln -sv /tools/lib/libstdc++.{a,so{,.6}}             /usr/lib;

# 									/tools/bin/ln -sv bash /bin/sh;
# 									/tools/bin/ln -sv /proc/self/mounts /etc/mtab;
# 									/tools/bin/cp /basic-system/passwd /etc/passwd;
# 									/tools/bin/cp /basic-system/group /etc/group;
																	
# 									exec /tools/bin/bash --login +h -c \"/basic-system/system.sh\"
# 								   "

# chroot "$LFS" /usr/bin/env -i          \
#     HOME=/root TERM="$TERM"            \
#     PS1='(lfs chroot) \u:\w\$ '        \
#     PATH=/bin:/usr/bin:/sbin:/usr/sbin \
#     /bin/bash --login -c   "/basic-system/final.sh"

# set +e

# #cp lfs.img /output/
# rm -rf "$LFS"/sources
# rm -rf "$LFS"/tools
# rm -rf "$LFS"/basic-system

# umount /dev/loop0p2
# umount /dev/loop0p3

# sudo losetup -d /dev/loop0

# qemu-img convert -f raw -O qcow2 -c /build/lfs.img /output/lfs.qcow2
