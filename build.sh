#!/bin/bash
set -e
logfile=output.log

#exec > >(cat >> $logfile)
#exec 2> >(tee -a $logfile >&2)

grep -v 'BR2_aarch64\|BR2_arm\|BR2_cortex' configs/BPI-R64_defconfig > configs/BPI-R2_defconfig
sed -i '1 i\BR2_arm=y\nBR2_cortex_a7=y' configs/BPI-R2_defconfig

make BPI-R64_defconfig
make -s
mv output/images/rootfs.cpio.gz rootfs_bpi-r64.cpio.gz

make clean
make BPI-R2_defconfig

make -s
mv output/images/rootfs.cpio.gz rootfs_bpi-r2.cpio.gz
