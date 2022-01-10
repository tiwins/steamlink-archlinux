#!/bin/sh -e
# Edited by Nargajuna, based on the work of PlatinumMaster & mcd1992.

mkdir -p /mnt/disk

echo "Wiping the plugged in disk now, you have been warned!"
# Wipe disk and mount it
mkfs.ext4 /dev/block/sda1
mount /dev/block/sda1 /mnt/disk
cd /mnt/disk

# Get Arch Linux ARM
echo "Getting Arch Linux, may take a while..."
wget http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz

# Extract Arch Linux ARM
echo "Extracting Arch Linux, may take a while..."
tar -xvf ArchLinuxARM-armv7-latest.tar.gz
rm -rf ArchLinuxARM-armv7-latest.tar.gz

echo "Downloading some needed files..."
cd boot
wget https://github.com/vadimstasiev/steamlink-archlinux/raw/main/initramfs-linux-steam.img
rm -rf ./zImage
wget https://github.com/vadimstasiev/steamlink-archlinux/raw/main/zImage
wget https://github.com/vadimstasiev/steamlink-archlinux/raw/main/kexec_load.ko
wget https://github.com/vadimstasiev/steamlink-archlinux/raw/main/berlin2cd-valve-steamlink.dtb

# Make Home Directory
echo "Made home directory"
mkdir -p /mnt/disk/home/steam

# Make Dev Directory
echo "Made dev directory"
mkdir -p /mnt/disk/dev

echo "Downloading kexec..."
cd /mnt/disk/usr/bin/
wget https://github.com/vadimstasiev/steamlink-archlinux/raw/main/kexec
echo "Setting kexec permissions"
chmod 755 ./kexec

cd /mnt/disk/lib/modules/
echo "Downloading Kernel Modules..."
wget https://github.com/vadimstasiev/steamlink-archlinux/raw/main/5.4.24.tar.gz
echo "Extracting Kernel Modules..."
tar -xvf 5.4.24.tar.gz
rm -rf 5.4.24.tar.gz

echo "Made steamlink directory"
mkdir -p /mnt/disk/steamlink

echo "Made factory_test directory"
mkdir -p /mnt/disk/steamlink/factory_test
cd /mnt/disk/steamlink/factory_test

echo "Downloading run.sh"
wget https://raw.githubusercontent.com/vadimstasiev/steamlink-archlinux/main/run.sh
chmod 755 ./run.sh

# Get ready to chroot
mount -t proc proc /mnt/disk/proc/
mount -t sysfs sys /mnt/disk/sys/
mount -o bind /dev /mnt/disk/dev/
mount -t devpts devpts /mnt/disk/dev/pts/

# config
mv /mnt/disk/etc/pacman.conf /mnt/disk/etc/pacman.conf.original && awk '/#IgnorePkg/ { print; print "IgnorePkg = linux-api-headers linux-armv7 linux-armv7-headers kexec-tools"; next }1' /mnt/disk/etc/pacman.conf.original > /mnt/disk/etc/pacman.conf


# chroot into new installation
echo "Changing root now"
chroot /mnt/disk /bin/bash -c "rm -R /root/.gnupg/ ; pacman-key --init && yes | pacman-key --populate"
# yes | pacman -Syyu && uname -a

echo "Please unplug the device and plug it back in, SSH using user: alarm, password: alarm"