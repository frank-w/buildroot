# Buildroot Initrd for BananaPi R2/R64/R2Pro/R3/R4

## Requirements

## Usage

if you want to build for R64/R2Pro/R3/R4, change "board" in build.conf first

```sh
  ./build.sh importconfig
  ./build.sh config #To configure manually with menuconfig
  ./build.sh
```

### using the initrd

from my uboot:

```sh
BPI-R3> run useusb #optional if files are on usb-drive
BPI-R3> setenv initrd rootfs_bpi-r3.cpio.zst
BPI-R3> setenv fit bpi-r3-6.1.itb
BPI-R3> run newboot
```
