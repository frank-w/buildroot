#!/bin/bash
set -e
logfile=output.log

exec > >(cat >> $logfile)
exec 2> >(tee -a $logfile >&2)

make BPI-R64_defconfig
make
