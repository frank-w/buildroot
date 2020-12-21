# buildroot (initramfs) for Bananapi-R2/R64
![CI](https://github.com/frank-w/buildroot/workflows/CI/badge.svg?branch=2020.11.x)

for r2 change this in configs/BPI-R64_defconfig

```
#BR2_aarch64=y
#BR2_cortex_a53=y
BR2_arm=y
BR2_cortex_a7=y
```
and run

```
make BPI-R64_defconfig
```

then run make to start building-process

after that ./output/images/rootfs.cpio.gz is created
which can be linked into linux kernel
