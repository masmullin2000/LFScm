FROM fedora:latest

RUN dnf update -y && \
	dnf groupinstall "C Development Tools and Libraries" "Development Tools" -y && \
	dnf install expat-devel xz texinfo qemu-img e2fsprogs mercurial perl-XML-Parser -y && \
	dnf install breezy e2fsprogs wget hostname vim gperf gettext-devel texinfo-tex -y && \
	dnf install fossil libattr-devel autoconf-archive help2man expect rsync procps-ng  -y && \
	dnf install python3-Cython python3-devel libxslt docbook-style-xsl fpc netpbm-progs -y && \
	dnf install libselinux-devel libsemanage-devel gtk-doc po4a perl-ExtUtils-ParseXS ncurses-devel -y && \
	groupadd lfs && useradd -s /bin/bash -g lfs -m -k /dev/null lfs && \
	git config --global advice.detachedHead false

COPY resources/ /build/

WORKDIR /build

ENV LFS /mnt/lfs
