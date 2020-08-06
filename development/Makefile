SHELL := /bin/bash
LFS=/mnt/lfs

.PHONY: doit
doit: mounting getsrc

.PHONY: makedrive
makedrive: clean
	qemu-img create -f raw lfs.img 10G
	sudo losetup -fP lfs.img
	sudo sfdisk /dev/loop0 < loop.sfdisk
	sudo mkswap /dev/loop0p1
	sudo mkfs.ext4 /dev/loop0p2
	sudo mkfs.ext4 /dev/loop0p3

.PHONY: mounting
mounting: makedrive
	mkdir -p $(LFS)
	sudo mount /dev/loop0p3 $(LFS)
	mkdir -p $(LFS)/boot
	sudo mount /dev/loop0p2 $(LFS)/boot
	mkdir -p $(LFS)/sources
	chmod -v a+wt $(LFS)/sources
	mkdir -p $(LFS)/tools
	ln -sv $(LFS)/tools /

.PHONY: unmounting
unmounting:
	-sudo umount $(LFS)/boot
	-sudo umount $(LFS)

.PHONY: clean
clean: unmounting
	-sudo losetup -d /dev/loop0
	-rm lfs.img

.PHONY: getsrc
getsrc:
	cp /mnt/src-cache/* $(LFS)/sources
	cd $(LFS)/sources && md5sum -c md5sums

.PHONY: lfs_user
lfs_user:
	chown -v lfs $(LFS)/tools
	chown -v lfs $(LFS)/sources
	su - lfs make toolchain
	chown -R root:root $(LFS)/tools

.PHONY: setup_rootfs
setup_rootfs:
	cd $(LFS)/sources && /build/basic-system/0.*.sh

.PHONY: system
system:
	i=1 ; while [[ $$i -le 70 ]] ; do \
		cd sources && /basic-system/$$i.*.sh ;
		((i = i +1)) ; \
	done
	
.PHONY: speed-toolchain
speed-toolchain:
	tar xvf tools.tar.gz -C $(LFS)/tools

.PHONY: toolchain
toolchain:
	cd $(LFS)/sources && /build/toolchain/1.*.sh
	cd $(LFS)/sources && /build/toolchain/2.*.sh
	cd $(LFS)/sources && /build/toolchain/3.*.sh
	cd $(LFS)/sources && /build/toolchain/4.*.sh
	cd $(LFS)/sources && /build/toolchain/5.*.sh
	cd $(LFS)/sources && /build/toolchain/6.*.sh
	cd $(LFS)/sources && /build/toolchain/7.*.sh
	cd $(LFS)/sources && /build/toolchain/8.*.sh
	cd $(LFS)/sources && /build/toolchain/9.*.sh
	cd $(LFS)/sources && /build/toolchain/10.*.sh
	cd $(LFS)/sources && /build/toolchain/11.*.sh
	cd $(LFS)/sources && /build/toolchain/12.*.sh
	cd $(LFS)/sources && /build/toolchain/13*.sh
	cd $(LFS)/sources && /build/toolchain/14*.sh
	cd $(LFS)/sources && /build/toolchain/15*.sh
	cd $(LFS)/sources && /build/toolchain/16*.sh
	cd $(LFS)/sources && /build/toolchain/17*.sh
	cd $(LFS)/sources && /build/toolchain/18*.sh
	cd $(LFS)/sources && /build/toolchain/19*.sh
	cd $(LFS)/sources && /build/toolchain/20*.sh
	cd $(LFS)/sources && /build/toolchain/21*.sh
	cd $(LFS)/sources && /build/toolchain/22*.sh
	cd $(LFS)/sources && /build/toolchain/23*.sh
	cd $(LFS)/sources && /build/toolchain/24*.sh
	cd $(LFS)/sources && /build/toolchain/25*.sh
	cd $(LFS)/sources && /build/toolchain/26*.sh
	cd $(LFS)/sources && /build/toolchain/27*.sh
	cd $(LFS)/sources && /build/toolchain/28*.sh
	cd $(LFS)/sources && /build/toolchain/29*.sh
	cd $(LFS)/sources && /build/toolchain/30*.sh
	cd $(LFS)/sources && /build/toolchain/31*.sh
	cd $(LFS)/sources && /build/toolchain/32*.sh
	cd $(LFS)/sources && /build/toolchain/99*.sh
	cd $(LFS)/tools && tar czvf /output/tools.tar.gz .
