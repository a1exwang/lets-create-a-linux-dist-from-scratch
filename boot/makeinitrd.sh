#!/bin/bash
set -xe

while [[ $# -ge 1 ]]; do
key="$1"

case $key in
    -m|--mount)
      MOUNT_ONLY=1
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

BUSYBOX_DIR="../build/busybox/_install"
BUILD_DIR="../build/boot"
if [[ BUSYBOX_DIR == "" || BUILD_DIR == "" ]]; then
  echo "Please specify \$BUSYBOX_DIR"
  exit 1
fi

mkdir -p $BUILD_DIR

# Create a 16MiB image
dd if=/dev/zero of=$BUILD_DIR/hda.img bs=1024 count=16384
if (losetup -d /dev/loop0); then
  echo "Detaching loaded loop0"
fi
losetup /dev/loop0 $BUILD_DIR/hda.img
# Create a mbr and a primary partition and print the result
if ! (echo -e "o\nn\np\n\n\n\np\nw\n" | fdisk /dev/loop0); then
  echo "this always happens"
fi
partprobe /dev/loop0
mkfs.ext4 /dev/loop0p1
mount /dev/loop0p1 /mnt
# Create vfs dirs
mkdir -p /mnt/{dev,sys,proc,etc,boot}
# Copy linux kernel
cp ../build/linux/arch/x86/boot/bzImage /mnt/boot/vmlinuz
# Install busybox
cp -r $BUSYBOX_DIR/* /mnt/
# Install init script
cp init /mnt/init
# Install grub
../build/grub/out/sbin/grub-install --target i386-pc /dev/loop0 --boot-directory=/mnt/boot
cp grub.cfg /mnt/boot/grub/grub.cfg
if [[ $MOUNT_ONLY -eq 1 ]]; then
  exit
fi

umount /mnt
losetup -d /dev/loop0
