#!/bin/bash
builddir=../build
ramdisksize=10G #currently ~6GB are used

#board=bpi-r2

if [[ "board" == "bpi-r2" ]];then
	echo "BR2_arm=y" >> .config
	echo "BR2_cortex_a7=y" >> .config
fi


if [[ "$builddir" != "" && ! "$1" =~ ^(updatesrc|uenv|defconfig|dts*)$ ]];
then
	if [[ "$1" == "importconfig" ]];
	then
		KBUILD_OUTPUT= make mrproper
	fi
	if [[ ! "$builddir" =~ ^/ ]] || [[ "$builddir" == "/" ]];then
		#make it absolute
		builddir=$(realpath $(pwd)"/"$builddir)
#		echo "absolute: $builddir"
	fi

	mkdir -p $builddir

	if [[ "$ramdisksize" != "" ]];
	then
		mount | grep '\s'$builddir'\s' &>/dev/null #$?=0 found;1 not found
		if [[ $? -ne 0 ]];then
			#make sure directory is clean for mounting
			if [[ "$(ls -A $builddir)" ]];then
				rm -rf $builddir/*
			fi
			echo "mounting tmpfs for building..."
			sudo mount -t tmpfs -o size=$ramdisksize none $builddir
		fi
	fi

	cp .config $builddir/
	#out-of tree build
	make O=$builddir
	echo "$builddir/images/rootfs.cpio.gz"
else
	make
	echo images/rootfs.cpio.gz
fi

