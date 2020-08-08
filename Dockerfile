FROM fedora:latest

RUN dnf update -y && \
	dnf groupinstall "C Development Tools and Libraries" "Development Tools" -y && \
	dnf install xz texinfo qemu-img e2fsprogs mercurial e2fsprogs wget -y && \
	groupadd lfs && useradd -s /bin/bash -g lfs -m -k /dev/null lfs

COPY resources/ /build/

WORKDIR /build

ENV LFS /mnt/lfs
