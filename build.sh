#!/bin/bash
set -e
logfile=output.log

exec > >(cat >> $logfile)
exec 2> >(tee -a $logfile >&2)

make BPI-R64_defconfig
make -s
mv output/images/rootfs.cpio.gz rootfs_bpi-r64.cpio.gz
make clean
echo -e "BR2_arm=y\nBR2_cortex_a7=y" >> .config
make -s
mv output/images/rootfs.cpio.gz rootfs_bpi-r2.cpio.gz
