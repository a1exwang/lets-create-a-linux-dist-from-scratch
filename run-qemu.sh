#!/bin/bash
qemu-system-x86_64 -kernel build/linux/arch/x86/boot/bzImage -hda build/boot/hda.img -append "root=/dev/sda init=/init"
