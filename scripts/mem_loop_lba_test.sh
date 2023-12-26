#!/bin/bash

#主要作用: 校验虚拟机热迁移内存数据一致性

bwlimit=204800
cluster_sectors=2048
MEM_LOOP=/dev/loop5
MEM_DIR=/var/mem
MEM_FILE=${MEM_DIR}/mem_lba_test.raw
MAP_FILE=/var/hd_write_verify/mem_map*

LBA_TOOLS=/var/iso/tools/hd_write_verify

if [ ${#} -gt 2 ]; then
	echo "Usage: ${0} [cluster_sectors] [bwlimit]"
	exit 1
fi

#参数1: 可指定
if [ ! -z ${1} ]; then
	cluster_sectors=${1}
fi

#参数2: 可指定
if [ ! -z ${2} ]; then
	bwlimit=${2}
fi

mkdir -p ${MEM_DIR}

modprobe loop

if [ -f ${MEM_FILE} ]; then
	losetup ${MEM_LOOP} ${MEM_FILE} > /dev/null 2>&1

	#校验上次LBA测试文件的数据一致性
	${LBA_TOOLS} -c -D -K -T 10 -L ${bwlimit} ${MEM_LOOP}

	LBA_INFO=$(dmesg -c | grep -n "BUG 00")
	if [ ! -z ${LBA_INFO} ]; then
		echo ${LBA_INFO}
		exit 1
	fi

	#退出测试
	if [ -f /var/log/QUIT_FILE_LBA_TEST ]; then
		exit 0
	fi

	losetup -d ${MEM_LOOP} > /dev/null 2>&1

	rm -f ${MEM_FILE} > /dev/null 2>&1

	umount ${MEM_DIR} > /dev/null 2>&1

	echo 3 > /proc/sys/vm/drop_caches
fi

#FREE_MEM=$(grep MemFree /proc/meminfo | busybox awk '{print $2}')
FREE_MEM=$(grep MemFree /proc/meminfo | awk '{print $2}')
TEST_MEM=$((${FREE_MEM}/1024-512))

if [ ! -f $LBA_TOOLS ]; then
	LBA_TOOLS=hd_write_verify
fi

#关闭透明大页
echo -e "echo never > /sys/kernel/mm/transparent_hugepage/enabled\n"
echo never > /sys/kernel/mm/transparent_hugepage/enabled

#LBA测试参数保留一份到dmesg日志
echo "${LBA_TOOLS} -c -D -K -R 33 -w on -S ${cluster_sectors} -V once -T 10 -L ${bwlimit} ${MEM_LOOP}"
echo "${LBA_TOOLS} -c -D -K -R 33 -w on -S ${cluster_sectors} -V once -T 10 -L ${bwlimit} ${MEM_LOOP}" > /dev/kmsg

while :;
do
	#退出测试
	if [ -f /var/log/QUIT_MEM_LBA_TEST ]; then
		break
	fi

	#mount -t tmpfs -o size=10240m tmpfs ${MEM_DIR}
	mount -t tmpfs -o size=$((${TEST_MEM}+100))m tmpfs ${MEM_DIR}

	#truncate --size=10240M ${MEM_FILE} > /dev/null 2>&1
	truncate --size=${TEST_MEM}M ${MEM_FILE} > /dev/null 2>&1

	losetup ${MEM_LOOP} ${MEM_FILE} > /dev/null 2>&1

	#内存LBA测试
	${LBA_TOOLS} -c -D -K -R 33 -w on -S ${cluster_sectors} -V once -T 10 -L ${bwlimit} ${MEM_LOOP}

	LBA_INFO=$(dmesg -c | grep -n "BUG 00")
	if [ ! -z ${LBA_INFO} ]; then
		echo ${LBA_INFO}
		break
	fi

	losetup -d ${MEM_LOOP} > /dev/null 2>&1

	rm -f ${MEM_FILE} > /dev/null 2>&1

	umount ${MEM_DIR} > /dev/null 2>&1

	#同时进行磁盘LBA测试和内存LBA测试时，每轮只删除内存LBA测试的mem_map文件
	LBA_PID=`pidof hd_write_verify`
	if [ ! -z ${LBA_PID} ]; then
		MAP_FILE=$(find /var/hd_write_verify/ -name mem_map* | grep -v ${LBA_PID})
	fi
	rm -f ${MAP_FILE} > /dev/null 2>&1

	echo 3 > /proc/sys/vm/drop_caches

	sleep 2
done
