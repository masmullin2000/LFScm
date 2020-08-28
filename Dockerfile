FROM fedora:latest

RUN dnf update -y && \
	dnf groupinstall "C Development Tools and Libraries" "Development Tools" -y && \
	dnf install xz texinfo qemu-img e2fsprogs mercurial e2fsprogs wget hostname -y && \
	dnf install libattr-devel autoconf-archive help2man gettext-devel rsync vim gperf -y && \
	groupadd lfs && useradd -s /bin/bash -g lfs -m -k /dev/null lfs && \
	git config --global advice.detachedHead false

COPY resources/ /build/

WORKDIR /build

ENV LFS /mnt/lfs
