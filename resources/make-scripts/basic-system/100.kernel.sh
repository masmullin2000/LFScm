set -e

tar xf linux.tar.gz
cd linux

make mrproper
cp /basic-system/config .config
make olddefconfig

make -j$(nproc)
make vmlinux -j$(nproc)
#make -j$(nproc) modules_install

cp -iv arch/x86/boot/bzImage /boot/vmlinuz
cp -iv vmlinux /boot/vmlinux
cp -iv System.map /boot/System.map
cp -iv .config /boot/config

install -d /usr/share/doc/linux
cp -r Documentation/* /usr/share/doc/linux

cd ../
rm -rf linux
