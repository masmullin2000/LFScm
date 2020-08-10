set -e

tar xf linux-5.5.3.tar.xz
cd linux-5.5.3

make mrproper
cp /basic-system/config-5.5.3 .config
make -j$(nproc)
make -j$(nproc) modules_install

cp -iv arch/x86/boot/bzImage /boot/vmlinuz-5.5.3
cp -iv System.map /boot/System.map-5.5.3
cp -iv .config /boot/config-5.5.3

install -d /usr/share/doc/linux-5.5.3
cp -r Documentation/* /usr/share/doc/linux-5.5.3

cd ../
rm -rf linux-5.5.3