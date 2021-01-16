#!/bin/bash
set -e
logfile=output.log

board=bpi-r2

#exec > >(cat >> $logfile)
#exec 2> >(tee -a $logfile >&2)

if [[ -e "build.conf" ]];
then
	. build.conf
fi

case $1 in
	"clean")
		make clean
	;;
	"importconfig")
		echo "import config for $board..."
		if [[ "$board" == "bpi-r64" ]];then
			make BPI-R64_defconfig
		else
			make BPI-R2_defconfig
		fi
	;;
	""|"build")
		echo "building for $board..."
		make -s
		mv output/images/rootfs.cpio.gz rootfs_${board}.cpio.gz
	;;
	"copy64config")
		grep -v 'BR2_aarch64\|BR2_arm\|BR2_cortex' configs/BPI-R64_defconfig > configs/BPI-R2_defconfig
		sed -i '1 i\BR2_arm=y\nBR2_cortex_a7=y' configs/BPI-R2_defconfig
	;;
	"version")
		echo "Version: "$( git describe )
	;;
	"copy")
		#cp output/images/rootfs.cpio.gz /media/data_nvme/git/kernel/BPI-R2-4.14/utils/buildroot/rootfs_$board.cpio.gz
		if [[ -n "$targetdir" ]];
		then
			cp rootfs_${board}.cpio.gz ${targetdir}/
		fi
	;;
	*)
		echo "unsupported option: $1"
	;;
esac

