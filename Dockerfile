FROM fedora:latest

RUN dnf update -y && \
	dnf groupinstall "C Development Tools and Libraries" "Development Tools" -y && \
	dnf install expat-devel xz texinfo qemu-img e2fsprogs mercurial perl-XML-Parser -y && \
	dnf install breezy e2fsprogs wget hostname vim gperf gettext-devel -y && \
	dnf install fossil libattr-devel autoconf-archive help2man  rsync  -y && \
	groupadd lfs && useradd -s /bin/bash -g lfs -m -k /dev/null lfs && \
	git config --global advice.detachedHead false

COPY resources/ /build/

WORKDIR /build

ENV LFS /mnt/lfs
