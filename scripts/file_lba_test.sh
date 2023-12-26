#!/bin/bash

#注意: 脚本必须以前台方式运行
#主要作用: 文件存储稳定性测试和数据一致性校验

bwlimit=102400
cluster_sectors=2048
MAP_FILE=/var/hd_write_verify/mem_map*

LBA_TOOLS=/var/iso/tools/hd_write_verify

if [ ${#} != 1 -a ${#} != 2 -a ${#} != 3 ]; then
	echo "Usage: ${0} /path/test.raw [cluster_sectors] [bwlimit]"
	echo "eg: ${0} /path/test.raw"
	echo "eg: ${0} /path/test.raw cluster_sectors"
	echo "eg: ${0} /path/test.raw cluster_sectors bwlimit"
	exit 1
fi

#参数1: 必须指定LBA测试的文件名
LBA_FILE=`realpath ${1}`

#参数2: 可指定
if [ ! -z ${2} ]; then
	cluster_sectors=${2}
fi

#参数3: 可指定
if [ ! -z ${3} ]; then
	bwlimit=${3}
fi

if [ ! -f $LBA_TOOLS ]; then
	LBA_TOOLS=hd_write_verify
fi

if [ -f ${LBA_FILE} ]; then
	#校验上次LBA测试文件的数据一致性
	${LBA_TOOLS} -c -D -K -T 10 -L ${bwlimit} ${LBA_FILE}

	LBA_INFO=$(dmesg -c | grep -n "BUG 00")
	if [ ! -z ${LBA_INFO} ]; then
		echo ${LBA_INFO}
		exit 1
	fi

	#退出测试
	if [ -f /var/log/QUIT_FILE_LBA_TEST ]; then
		exit 0
	fi

	rm -f ${LBA_FILE} > /dev/null 2>&1
fi

#关闭透明大页
echo -e "echo never > /sys/kernel/mm/transparent_hugepage/enabled\n"
echo never > /sys/kernel/mm/transparent_hugepage/enabled

#LBA测试参数保留一份到dmesg日志
echo "${LBA_TOOLS} -c -D -K -R 33 -w on -S ${cluster_sectors} -V once -T 10 -L ${bwlimit} ${LBA_FILE}"
echo "${LBA_TOOLS} -c -D -K -R 33 -w on -S ${cluster_sectors} -V once -T 10 -L ${bwlimit} ${LBA_FILE}" > /dev/kmsg

while :;
do
	#退出测试
	if [ -f /var/log/QUIT_FILE_LBA_TEST ]; then
		break
	fi

	#创建LBA测试文件
	truncate --size 10G ${LBA_FILE}

	#对文件进行LBA测试
	${LBA_TOOLS} -c -D -K -R 33 -w on -S ${cluster_sectors} -V once -T 10 -L ${bwlimit} ${LBA_FILE}

	#如果测试出LBA问题，保留对应文件
	LBA_INFO=$(dmesg -c | grep -n "BUG 00")
	if [ ! -z ${LBA_INFO} ]; then
		echo ${LBA_INFO}
		break
	fi

	rm -f ${LBA_FILE} > /dev/null 2>&1

	#同时进行文件LBA测试和内存LBA测试时，每轮只删除文件LBA测试的mem_map文件
	LBA_PID=`pidof hd_write_verify`
	if [ ! -z ${LBA_PID} ]; then
		MAP_FILE=$(find /var/hd_write_verify/ -name mem_map* | grep -v ${LBA_PID})
	fi
	rm -f ${MAP_FILE} > /dev/null 2>&1

	sleep 2
done
