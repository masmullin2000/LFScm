# LFScm - Linux From SCM (A derivitive of Linux From Scratch)

Linux From SCM is a Linux distribution where sources are compiled as close to the tip of their github master branch tips as possible.
The goal is to be able to develop software components, and see how those software components fit within a holistic running operating system.

With Linux From SCM a developer can hack on a project like the Linux Kernel, systemd, or grub, and then see how their changes effect an entire distribution.

Linux From SCM is intended to be dirt simple to execute. The execution of Linux From SCM is done within a container (either docker or podman) with a single "doit.sh" instruction.

Linux From SCM has a different goal from Linux From Scratch and is not intended as a replacement for that project.  I summarize the goal of the Linux From Scratch project with the sentance **"to teach system administrators how the various software components come together to form a running operating system."**  I summarize the goal of Linux from SCM with the sentance **"to allow the exploration of software source code by software developers and see how that software interacts with other software to form a holistic operating system."**

It is highly recommended that users of Linux From SCM attempt a Linux From Scratch build.  (Paradoxically: It also might be useful to run LFScm before attempting a Linux From scratch).

### Docker or Podman must already be installed
Please see your distributions package repository on how to install docker or podman

# Build it

## Quick Start: 
    $ sudo ./doit.sh -n

The above will create a new docker container and use that image to build LFS 10.0.
The resulting output will be stored in output/lfs-(date).tar.xz
- lfs-lfs.qcow : A qemu virtual machine image
- firecracker-lfs-lfs.tar.xz : A tarball containing the linux kernel and root file system to run in a firecracker microvm
- finished-lfs-lfs.tar.xz : A tarball containing the entire lfs filesystem.  You can use this tarball to create a docker or podman container :)

## More Complex SCM build
    $ sudo ./doit.sh -n -p -s -t scm

The above will create a new podman contain and use that image to build nearly all software defined by Linux From Scratch, but using the HEAD of the software git repositories (or whichever SCM tool that the project has chosen).
The resulting output will be stored in output/scm-(date).tar.xz
- finished-lfs-scm.tar.xz : A tarball containing the entire lfs filesystem.  You can use this tarball to create a docker or podman container :)
- firecracker-lfs-scm.tar.xz : A tarball containing the linux kernel and root file system to run in a firecracker microvm
- lfs-scm.qcow2 : A qemu virtual machine image
  
## More build options
	-t|--type (scm|lfs|dev): type of build
		build an scm (git based) lfs (10.0) or dev (current lfs development version)
	-n|--new_cont: new container
		Rebuild the Dockerfile
	-c|--cpus: cpu limit
		limit container to # of cpus
	-s|--save_prog: save progress
		Save the Progress in the output directory (useful for scm builds)
	-m|--manual: manual container
		run the container but do not run the makeit script
	-p|--podman:
		use podman instead of docker

	Example:
		$ sudo ./doit -t scm -n -c 4 -s -p
	meaning:
		Use podman to run the SCM build with 4 cpus,
		ensure that the Dockerfile has been run,
		save progress into output dir as we build

# The SCM build
The SCM build is truly the impetus behind Linux from SCM.  Non SCM builds are important however, as source code in SCM often has compile breaks, or runtime bugs It is the goal of Linux From SCM to find these breaks/bugs -- but often a software developer just wants to hack on one thing and not worry about other components being broken that they are not currently interested in.

### IT IS NORMAL FOR SCM BUILDS TO BREAK
This is due to software project often leaving their git HEAD in an uncompilable state.  Over the past week LFScm has identified two such builds (binutils, systemd) and has helped in fixing them.

If you encounter a build break with and SCM build, think of it as an opportunity to find a bug in the broken project and hopefully help the community by submiting a fix for that bug.

LFScm may have issues of it's own, LFScm is derived from automating LFS and some hard-coded things like versioning numbers, or patch useage may have slipped into LFScm.  As time goes by, these hard coded values may break the build (specific example: https://github.com/masmullin2000/lfs-docker-build/blob/master/resources/sources/pre-condition/bison-conf.sh#L9 once bison reaches version 3.1.70 this package will break)
If you see this, please submit a Pull Request.

## Non SCM builds
Without specifying the -t scm build, the system created is either Linux From Scratch 10.0 with a few extra packages (git, wget, ssh, htop, wireguard, and a few more), or Linux From Scratch Development version with these same packages.

Documentation is purposefully removed, and "tests" are not run on any packages (TODO: this is a future task)
## SCM Builds
Running a build with the option -t scm will download all sources from the tip of their github (or svn, or fossil) repositories.  Sources often have to be 'pre-conditioned' to build in a chroot environment, and in a minority of cases, sources must be built as part of this pre-conditioning process.  These 'pre-build' compiles are not used in the final build, but they do add additional time to the creation of a Linux from SCM.

Additionally, in an scm build openssl is replaced with libressl.

### Hacking with SCM builds
As an SCM build fetches sources from the web, it stores the 'pre-conditioned' code as tarballs in input/sources.  Developers can pre-load input/sources with their own source code in input/sources rather than fetching the code as part of the build process.

Example.

    $ pwd
    /home/masmullin/code/lfs-docker-build/
    $ cd input/sources/
    $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
    $ vim linux/fs/exec.c #do stuff to the exec syscall
    $ cd ../../
    $ sudo ./doit.sh -p -t scm -s

#### Preconditioning
Code which requires preconditioning (note: code which requires pre-conditioning is often from https://git.savannah.gnu.org) must be in a conditioned state in the input/sources directory; pre-condition scripts will not be run on developer provided sources.  This means that you will probably have to run the same commands as are in the pre-condition scripts.
Precondition scripts can be found in:
lfs-docker-build/resources/sources/pre-condition

# TODO and Bugs

1) Non-SCM builds should check for developer provided sources in input/sources
2) A lof ot build time is consumed by running ./configure scripts.  Decrease the build time by running some of these in parallel
  A) This requires a very intimate knowledge of which packages require which other packages, and which packages can be configured in parallel
3) Global CFLAGS - It would be nice to start playing with -march=native (started playing, but user input would be good)
4) fetch-scm.sh is messy, this should be re-written in a cleaner way
5) Numbering the build order is messy and makes it difficult to insert new packages.  We should refactor this somehow (remember we don't have any other scripting language at build time other than bash)
6) Integrate LiveScratch to create a bootable ISO of the finalized product (https://github.com/masmullin2000/LiveScratch)

# Bugs Found because of LFScm

## Bugs Found and Fixed
Systemd compile break
https://github.com/systemd/systemd/commit/3dd8ae5c70aaf5d6d70079b1b14f1a66cb6b633a

binutils compile break
https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=e1044e6adca7d48674d70a860b3a5939fe44323f

Groff Compile break https://savannah.gnu.org/bugs/index.php?59186.  Fix https://git.savannah.gnu.org/cgit/groff.git/commit/?id=00bccfc7418ef7d55ddbf527af0f50c64bb76fa7

Shadow compile break
https://github.com/shadow-maint/shadow/issues/284 Fix https://github.com/shadow-maint/shadow/commit/af0f55a6257a07c19162ac28037b0a65f286d3dd

## Reported Unfixed Bugs


## Bugs found and not fixed (unsure how to report)
- GCC master head causes a forever compile on python 3.10.  GCC master downgrated to 10.2.1
