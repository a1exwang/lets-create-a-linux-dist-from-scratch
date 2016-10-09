#!/bin/bash
set -xe

BUSYBOX_DIR="../build/busybox/_install"
BUILD_DIR="../build/boot"
if [[ BUSYBOX_DIR == "" || BUILD_DIR == "" ]]; then
  echo "Please specify \$BUSYBOX_DIR"
  exit 1
fi

mkdir -p $BUILD_DIR

# Create a 4MiB image
dd if=/dev/zero of=$BUILD_DIR/file-initrd bs=1024 count=4096
if (losetup -d /dev/loop0); then
  echo "Detaching loaded loop0"
fi
losetup /dev/loop0 $BUILD_DIR/file-initrd
mke2fs /dev/loop0
mount /dev/loop0 /mnt
cp -r $BUSYBOX_DIR/* /mnt/
cp init /mnt/init
mkdir -p /mnt/{dev,sys,proc}
umount /mnt
losetup -d /dev/loop0
