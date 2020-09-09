#!/bin/bash

BACKUP="no"
if [[ -n "$1" ]]; then
	BACKUP=$1
	shift
fi

SOURCE_FETCH_METHOD="scm"
if [[ -n "$1" ]]; then
	SOURCE_FETCH_METHOD=$1
	shift
fi

function backup {

	local LEVEL=1
	if [[ -n $2 ]]; then
		LEVEL=$2
	fi

	if [ "$BACKUP" == "yes" ]
	then
		cd "$LFS"
		if [ "/output/all-sources.tar.xz" == $1 ]
		then
			cd "$LFS"/sources 
		fi
		tar --exclude='sources/*' --exclude='proc/*' \
			--exclude='basic-system' --exclude='sys/module/*' \
			--exclude='sys/bus/*' --exclude='sys/fs/*' \
			--exclude='sys/firmware' --exclude='sys/devices' --exclude='sys/kernel/*' \
			--exclude='sys/power' --exclude='sys/class/*' \
			-cf - . | xz -$LEVEL --threads=0 > $1

	fi
}

function setup_loop {

	local __ret=$1
	local LOOP_DEV=$(losetup -f)
	eval $__ret="'$LOOP_DEV'"

	set +e

	losetup -d $"LOOP_DEV"

	rm /build/lfs.img

	set -e

	qemu-img create -f raw /build/lfs.img 2304M
	losetup -fP /build/lfs.img

	sfdisk "$LOOP_DEV" < /build/loop.sfdisk
	mkswap "$LOOP_DEV"p1
	mkfs.ext4 "$LOOP_DEV"p2
	mkfs.ext4 "$LOOP_DEV"p3
}

function create_dirs {
	mkdir -p "$LFS"
	rm -rf "$LFS"/*

	mkdir -p "$LFS"/boot
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
		/build/sources/fetch-scm.sh $1
		backup /output/all-sources.tar.xz
	fi
}

function make_toolchain {
	cd "$LFS"/sources

	mv /build/config-scripts/bashrc /home/lfs/.bashrc
	mv /build/config-scripts/bash_profile /home/lfs/.bash_profile
	chown lfs:lfs /home/lfs/ -R
	chown lfs:lfs /build/make-scripts/toolchain/ -R

	chown -R lfs:lfs $LFS
	case $(uname -m) in
		x86_64) chown lfs $LFS/lib64 ;;
	esac

	chown -R lfs:lfs "$LFS"/sources
	sudo -u lfs /bin/bash -c "/build/make-scripts/toolchain/build-toolchain.sh $BACKUP"
	chown -R root:root "$LFS"
}

function make_vfs {

	local DIR=$LFS
	if [[ -n $1 ]]; then
		DIR=$1
	fi

	set +e
	mount -v --bind /dev $DIR/dev
	mount -v --bind /dev/pts $DIR/dev/pts
	mount -vt proc proc $DIR/proc
	mount -vt sysfs sysfs $DIR/sys
	mount -vt tmpfs tmpfs $DIR/run
	if [ -h $DIR/dev/shm ]; then
		mkdir -pv $DIR/$(readlink $DIR/dev/shm)
	fi
	set -e
}

function umake_vfs {

	local DIR=$LFS
	if [[ -n $1 ]]; then
		DIR=$1
	fi

	umount $DIR/dev/pts
	umount $DIR/dev
	umount $DIR/proc
	umount $DIR/sys
	umount $DIR/run
}

function make_temp_system {

	if test -f "/input/tools.tar.xz"
	then
		tar xf /input/tools.tar.xz -C "$LFS"
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
		    /bin/bash --login +h -c "set -e
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

function make_lfs_system_pt0 {
	if test -f "/input/system-pt0.tar.xz"
	then
		tar xf /input/system-pt0.tar.xz -C "$LFS"
	else
		make_temp_system

		make_vfs

		chroot "$LFS" /usr/bin/env -i   \
			HOME=/root                  \
			TERM="$TERM"                \
			PS1='(lfs chroot) \u:\w\$ ' \
			PATH=/bin:/usr/bin:/sbin:/usr/sbin \
			/bin/bash --login +h -c "set -e
		    	/basic-system/build-system.sh 1 16
		    "
		backup /output/system-pt0.tar.xz
	fi
}

function make_lfs_system_pt1 {
	if test -f "/input/system-pt1.tar.xz"
	then
		tar xf /input/system-pt1.tar.xz -C "$LFS"
	else
		make_lfs_system_pt0

		make_vfs

		chroot "$LFS" /usr/bin/env -i   \
			HOME=/root                  \
			TERM="$TERM"                \
			PS1='(lfs chroot) \u:\w\$ ' \
			PATH=/bin:/usr/bin:/sbin:/usr/sbin \
			/bin/bash --login +h -c "set -e
		    	/basic-system/build-system.sh 17 32
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
			/bin/bash --login +h -c "set -e
		    	/basic-system/build-system.sh 33 45
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

    	if [[ $SOURCE_FETCH_METHOD == "scm" ]]; then
    		echo -e "Building LibreSSL\n\n\n\n\n\n"
    		chroot "$LFS" /usr/bin/env -i   \
				HOME=/root                  \
				TERM="$TERM"                \
				PS1='(lfs chroot) \u:\w\$ ' \
				PATH=/bin:/usr/bin:/sbin:/usr/sbin \
				/bin/bash --login +h -c "set -e
					cd /sources && /basic-system/46.libressl.sh > /dev/null || exit
				"
		else
			echo -e "Building OpenSSL\n\n\n\n\n\n"

			chroot "$LFS" /usr/bin/env -i   \
				HOME=/root                  \
				TERM="$TERM"                \
				PS1='(lfs chroot) \u:\w\$ ' \
				PATH=/bin:/usr/bin:/sbin:/usr/sbin \
				/bin/bash --login +h -c "set -e
					cd /sources && /basic-system/46.openssl.sh > /dev/null || exit
				"
    	fi

    	make_vfs

		chroot "$LFS" /usr/bin/env -i   \
			HOME=/root                  \
			TERM="$TERM"                \
			PS1='(lfs chroot) \u:\w\$ ' \
			PATH=/bin:/usr/bin:/sbin:/usr/sbin \
			/bin/bash --login +h -c "set -e
		    	/basic-system/build-system.sh 47 60
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
			/bin/bash --login +h -c "set -e
				/basic-system/build-system.sh 61 72
				/basic-system/99.strip.sh
				rm -rf /tmp/*
			"

		backup /output/system-pt4.tar.xz
	fi		
}

function make_lfs_system_final {
	if test -f "/input/lfs.tar.xz"
	then
		tar xf /input/lfs.tar.xz -C "$LFS"
	else
		make_lfs_system_pt4

		cp /build/config-scripts/{grub.cfg,config,hosts,locale.conf,inputrc,shells,fstab,10-eth-dhcp.network,passwd,group} "$LFS"/basic-system/
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

				echo $VERSION

				find /usr/lib /usr/libexec -name \*.la -delete
				find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
				userdel -r tester

				ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
				echo "LFS" > /etc/hostname
				cp basic-system/hosts /etc/hosts
				cp basic-system/locale.conf /etc/locale.conf
				cp basic-system/inputrc /etc/inputrc
				cp basic-system/shells /etc/shells
				cp basic-system/fstab /etc/fstab
				cp basic-system/10-eth-dhcp.network /etc/systemd/network/

				cd /sources && /basic-system/100.kernel.sh
			"
		backup /output/lfs.tar.xz
	fi
}

function make_lfs_system {
	mkdir -p "$LFS"/basic-system
	cp -R /build/make-scripts/basic-system/*.sh "$LFS"/basic-system
	chmod +x "$LFS"/basic-system	

	make_lfs_system_final $1
}

function make_wget {
	make_vfs

	mkdir -p "$LFS"/extras
	cp /build/make-scripts/extras/* "$LFS"/extras
	cp /build/config-scripts/extras/certs/* "$LFS"/extras

	mkdir -p "$LFS"/extra-sources
	cd "$LFS"/extra-sources
	/build/sources/fetch-scm.sh wget

	# Make WGET and dependencies
	chroot "$LFS" /usr/bin/env -i          \
	    HOME=/root TERM="$TERM"            \
	    PS1='(lfs chroot) \u:\w\$ '        \
	    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	    /bin/bash --login -c "set -e
	    	cd /extra-sources
	    	/extras/libtasn1.sh
	    	/extras/p11-kit.sh
	    	/extras/make-ca.sh
	    	/extras/wget.sh

	    	cp /extras/update-pki.timer /lib/systemd/system/update-pki.timer
	    	systemctl enable update-pki.timer
	    "
}

function make_ssh {
	make_vfs

	mkdir -p "$LFS"/extras
	cp /build/make-scripts/extras/* "$LFS"/extras
	cp /build/config-scripts/extras/ssh/* "$LFS"/extras

	mkdir -p "$LFS"/extra-sources
	cd "$LFS"/extra-sources
	/build/sources/fetch-scm.sh ssh

	ALLOW_ROOT="no"
	if [[ "allow_root" == $1 ]]; then
		ALLOW_ROOT="yes"
	fi

	chroot "$LFS" /usr/bin/env -i          \
	    HOME=/root TERM="$TERM"            \
	    PS1='(lfs chroot) \u:\w\$ '        \
	    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	    /bin/bash --login -c "set -e
	    	cd /extra-sources
	    	/extras/openssh.sh

	    	cp /extras/sshd.* /lib/systemd/system/
	    	cp /extras/sshdat.service /lib/systemd/system/sshd@.service

	    	if [[ $ALLOW_ROOT == yes ]]; then
	    		echo allowing root
	    		sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
	    	fi

	    	systemctl enable sshd
	    "
}

function make_htop {
	make_vfs

	mkdir -p "$LFS"/extras
	cp /build/make-scripts/extras/* "$LFS"/extras

	mkdir -p "$LFS"/extra-sources
	cd "$LFS"/extra-sources
	/build/sources/fetch-scm.sh htop

	chroot "$LFS" /usr/bin/env -i          \
		HOME=/root TERM="$TERM"            \
		PS1='(lfs chroot) \u:\w\$ '        \
		PATH=/bin:/usr/bin:/sbin:/usr/sbin \
		/bin/bash --login -c "set -e
			cd /extra-sources
			/extras/htop.sh
		"
}

function make_extras {
	mkdir -p "$LFS"/extras
	cp /build/make-scripts/extras/* "$LFS"/extras

	make_wget
	make_ssh allow_root
	make_htop
}

function finish_build {
	cd /mnt/lfs
	BACKUP="yes"
	rm -rf "$LFS"/usr/share/{info,man,doc}
	rm -rf "$LFS"/tools
	rm -rf "$LFS"/sources
	rm -rf "$LFS"/extra-sources
	rm -rf "$LFS"/mnt/lfs
	rm -rf "$LFS"/extras
	rm -rf "$LFS"/basic-system
	backup /output/finished-lfs-$SOURCE_FETCH_METHOD.tar.xz $1

	QEMU_DIR="/mnt/qemu"
	setup_loop drive
	mkdir -p "$QEMU_DIR"
	mount "$drive"p3 "$QEMU_DIR"
	rm -rf "$QEMU_DIR"/*
	mkdir -p "$QEMU_DIR"/boot
	mount "$drive"p2 "$QEMU_DIR"/boot
	rm -rf "$QEMU_DIR"/boot/*
	
	cd "$QEMU_DIR"
	tar xf /output/finished-lfs-$SOURCE_FETCH_METHOD.tar.xz
	mkdir -p "$QEMU_DIR"/boot/grub
	cp /build/config-scripts/grub.cfg "$QEMU_DIR"/boot/grub/
	
	make_vfs "$QEMU_DIR"

	chroot "$QEMU_DIR" /usr/bin/env -i          \
	    HOME=/root TERM="$TERM"            \
	    PS1='(lfs chroot) \u:\w\$ '        \
	    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
	    /bin/bash --login -c "set -e
			grub-install --target=i386-pc $drive
			sync
		"

	ROOT_EXT4=/firecracker/rootfs."$SOURCE_FETCH_METHOD".ext4
	FC_DIR="/firecracker"
	FC_ROOTFS="$FC_DIR"/rootfs

	mkdir -p "$FC_ROOTFS"
	dd if=/dev/zero of="$ROOT_EXT4" bs=1M count=1536
	mkfs.ext4 "$ROOT_EXT4"
	mount "$ROOT_EXT4" "$FC_ROOTFS"
	tar -xf /output/finished-lfs-$SOURCE_FETCH_METHOD.tar.xz -C "$FC_ROOTFS"
	rm "$FC_ROOTFS"/etc/fstab
	sync
	umount "$FC_ROOTFS"
	cp boot/vmlinux "$FC_ROOTFS"/..
	rm -rf "$FC_ROOTFS"

	tar -cf - "$FC_DIR" | xz -$1 --threads=0 > /output/firecracker-lfs-$SOURCE_FETCH_METHOD.tar.xz

	qemu-img convert -c -f raw -O qcow2 /build/lfs.img /output/lfs-$SOURCE_FETCH_METHOD.qcow2
}

#setup_loop val
create_dirs
fetch_sources "$SOURCE_FETCH_METHOD"
make_lfs_system
make_extras
finish_build 1
