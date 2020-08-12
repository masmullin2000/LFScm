set -e

tar xf linux.tar.gz
cd linux

make mrproper
cp /basic-system/config-$1 .config
make olddefconfig

make -j$(nproc)
make -j$(nproc) modules_install

cp -iv arch/x86/boot/bzImage /boot/vmlinuz-$1
cp -iv System.map /boot/System.map-$1
cp -iv .config /boot/config-$1

install -d /usr/share/doc/linux-$1
cp -r Documentation/* /usr/share/doc/linux-$1

cd ../
rm -rf linux