# Let's Build a Linux Distribution from Scratch

- Build linux kernel
```bash
  cd linux
  make O=build/linux menuconfig
  make bzImage -j8
```
- Build busybox
```bash
  cd busybox
  # Enable static link
  make O=build/busybox menuconfig
  make -j8
  make install
```

- Build initrd
```bash
  cd root
  ./makeinitrd
```

- Run qemu to start my linux distro
```bash
  ./run-qemu.sh
```

