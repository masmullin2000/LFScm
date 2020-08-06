# lfs-docker-build

Instructions Assuming Docker is installed

where NAME is whatever you want to give the docker image

docker build -t NAME .
docker run --rm --privileged -v /dev:/dev -v /home/masmullin/code/docker/lfs-docker-build/output/:/output/ -v /home/masmullin/code/docker/lfs-docker-build/input:/input -it NAME ./makeit.sh

once complete, you should find output/tools.tar.gz and output/lfs.qcow2

You should chown output/lfs.qcow2 to your user name
sudo chmod username:group output/lfs.qcow2

tools.tar.gz can be copied into the input directory to skip rebuilding the toolchain for iterative runs
lfs.qcow2 is a qemu image which can be run via the command:

qemu-system-x86_64 -cpu host -vga virtio -enable-kvm -soundhw hda -usb -device usb-tablet -hda output/lfs.qcow2 -serial stdio -m 4G -smp 2