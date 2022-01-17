#!/bin/sh -e
# Edited by Nargajuna, based on the work of PlatinumMaster & mcd1992.

mkdir -p /mnt/disk

echo "Wiping the plugged in disk now, you have been warned!"
#make sure disk isn`t mounted
umount /dev/block/sda1
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

#populate /boot
echo "Downloading some needed files..."
cd boot
rm -rf ./zImage

#get extra stuff
wget https://github.com/Nargajuna/steamlink-archlinux/archive/refs/heads/main.zip
unzip main.zip -d .
cd steamlink-archlinux-main
mv * ../
cd ..
rm -Rf steamlink-archlinux-main

#move kexec bin
mv ./kexec /mnt/disk/usr/bin
echo "Setting kexec permissions"
chmod 755 /mnt/disk/usr/bin/kexec

#remove unused kernel modules
rm -R /mnt/disk/lib/modules/*

#move new Kernel modules
mv 5.10.32-mrvl/ /mnt/disk/lib/modules/

# Make Home Directory
echo "Made home directory"
mkdir -p /mnt/disk/home/steam

# Make Dev Directory
echo "Made dev directory"
mkdir -p /mnt/disk/dev

echo "Made steamlink directory"
mkdir -p /mnt/disk/steamlink

#moving run.sh
echo "Made factory_test directory"
mkdir -p /mnt/disk/steamlink/factory_test

echo "move run.sh"
mv ./run.sh /mnt/disk/steamlink/factory_test/
chmod 755 /mnt/disk/steamlink/factory_test/run.sh

#create enable.ssh again, just to make sure
mkdir -p /mnt/disk/steamlink/config
mkdir -p /mnt/disk/steamlink/config/system
echo "enable" > /mnt/disk/steamlink/config/system/enable_ssh.txt


#cleaning
rm ./install.sh
rm ./README.md

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
