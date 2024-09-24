#!/bin/bash

#Author: YOUPLUS <zhang_youjia@126.com>
#注意: 脚本必须以前台方式运行
#主要作用: 校验虚拟机热迁移内存数据一致性

#默认限速
bwlimit=204800

#默认簇大小
cluster_sectors=2048

MEM_LOOP=/dev/loop5
MEM_DIR=/var/mem
MEM_FILE=${MEM_DIR}/mem_lba_test.raw

#虚拟地址与物理地址映射文件
MAP_FILE=/var/hd_write_verify/mem_map*

#升级的LBA工具
LBA_TOOLS=/var/iso/tools/hd_write_verify

KILL_PROC=$(dirname $(realpath ${0}))/kill_shell_proccess.sh
DATE_RECORD=$(dirname $(realpath ${0}))/date.sh
MEM_DIRTY_RECORD=$(dirname $(realpath ${0}))/mem_dirty_speed.sh

if [ ${#} -gt 2 ]; then
	echo "Usage: ${0} [cluster_sectors] [bwlimit]"
	echo "eg: ${0}"
	echo "eg: ${0} cluster_sectors"
	echo "eg: ${0} cluster_sectors bwlimit"
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

if [ ! -f ${KILL_PROC} ]; then
	KILL_PROC=kill_shell_proccess.sh
fi
trap "${KILL_PROC}" EXIT

#脚本date.sh用于测试虚拟机热迁移，downtime的中断时间长短；
#非必要不运行，1秒执行4次date重定向输出日志，容易因为bash频繁调用fork耗尽系统内存
if [ ! -f ${DATE_RECORD} ]; then
	DATE_RECORD=date.sh
fi
#${DATE_RECORD} &

if [ ! -f ${MEM_DIRTY_RECORD} ]; then
	MEM_DIRTY_RECORD=mem_dirty_speed.sh
fi
${MEM_DIRTY_RECORD} &

if [ ! -f ${LBA_TOOLS} ]; then
	#临时激活的LBA工具
	LBA_TOOLS=/run/hd_write_verify

	if [ ! -f ${LBA_TOOLS} ]; then
		LBA_TOOLS=hd_write_verify
	fi
fi

if [ -f ${MEM_FILE} ]; then
	losetup ${MEM_LOOP} ${MEM_FILE} > /dev/null 2>&1

	#校验上次LBA测试的内存数据一致性
	${LBA_TOOLS} -c -D -K -T 10 -L ${bwlimit} ${MEM_LOOP}

	dmesg -T >> /var/log/dmesg.txt

	LBA_INFO=$(dmesg -cT | grep -n "BUG 00")
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

#LBA测试参数保留一份到dmesg日志
echo "${LBA_TOOLS} -c -D -K -w on -U on -t on -n 3 -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} ${MEM_LOOP}"
echo "${LBA_TOOLS} -c -D -K -w on -U on -t on -n 3 -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} ${MEM_LOOP}" > /dev/kmsg

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
	${LBA_TOOLS} -c -D -K -w on -U on -t on -n 3 -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} ${MEM_LOOP}

	dmesg -T >> /var/log/dmesg.txt

	LBA_INFO=$(dmesg -cT | grep -n "BUG 00")
	if [ ! -z "${LBA_INFO}" ]; then
		echo "${LBA_INFO}"
		break
	fi

	losetup -d ${MEM_LOOP} > /dev/null 2>&1

	rm -f ${MEM_FILE} > /dev/null 2>&1

	umount ${MEM_DIR} > /dev/null 2>&1

	#同时进行多个LBA测试(磁盘/文件/内存等)时，删除已结束LBA测试的mem_map文件
	LBA_PID=`pidof hd_write_verify`

	if [ ! -z "${LBA_PID}" ]; then
		FILTER=$(echo "${LBA_PID}" | sed s/" "/"\|"/g)
		MAP_FILE=$(find /var/hd_write_verify/ -name mem_map* | grep -Ev "${FILTER}")
	fi

	rm -f ${MAP_FILE} > /dev/null 2>&1

	echo 3 > /proc/sys/vm/drop_caches

	sleep 3
done
