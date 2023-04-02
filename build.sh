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

case $board in
	"bpi-r2")
		DEFCONFIG=BPI-R2_defconfig
	;;
	"bpi-r2pro")
		DEFCONFIG=BPI-R2P_defconfig
	;;
	"bpi-r3"|"bpi-r4")
		DEFCONFIG=BPI-R3_defconfig
	;;
	"bpi-r64")
		DEFCONFIG=BPI-R64_defconfig
	;;
	*)
		echo "unsupported board"
		exit 1
	;;
esac

case $1 in
	"clean")
		make clean
	;;
	"importconfig")
		echo "import config for $board ($DEFCONFIG)..."
		make $DEFCONFIG
	;;
	"defconfig")
		echo "open defconfig..."
		nano configs/$DEFCONFIG
	;;
	"config")
		echo "run menuconfig..."
		make menuconfig
	;;
	""|"build")
		echo "building for $board..."
		exec 3> >(tee build.log)
		make -s -j8 2>&3
		ret=$?
		exec 3>&-
		(set -x;mv output/images/rootfs.cpio.zst rootfs_${board}.cpio.zst)
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
			cp rootfs_${board}.cpio.zst ${targetdir}/
		fi
	;;
	*)
		echo "unsupported option: $1"
	;;
esac

