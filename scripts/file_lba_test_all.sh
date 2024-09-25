#!/bin/bash

#Author: YOUPLUS <zhang_youjia@126.com>
#注意: 脚本必须以前台方式运行
#主要作用: 文件存储稳定性测试和数据一致性校验

#默认限速
bwlimit=102400

#默认簇大小
cluster_sectors=2048

#指定IO随机大小范围
bsrange="1-2048"

#虚拟地址与物理地址映射文件
MAP_FILE=/var/hd_write_verify/mem_map*

#升级的LBA工具
LBA_TOOLS=/var/iso/tools/hd_write_verify

if [ ${#} != 1 -a ${#} != 2 -a ${#} != 3 ]; then
	echo "Usage: ${0} /path/test.raw [cluster_sectors] [bwlimit]"
	echo "eg: ${0} /path/test.raw"
	echo "eg: ${0} /path/test.raw cluster_sectors"
	echo "eg: ${0} /path/test.raw cluster_sectors bwlimit"
	exit 1
fi

echo -e "\033[40m\033[0m"
echo -e "\033[1;30;44m ------------------------------------------------------ \033[0m\n"
echo -e "\033[1;37;40m       Welcome to the YOUPLUS's LBA TESTING SYSTEM      \033[0m\n"
echo -e "\033[1;37;40m       https://github.com/zhangyoujia/                  \033[0m\n"
echo -e "\033[1;30;44m ------------------------------------------------------ \033[0m\n"

#参数1: 必须指定LBA测试的文件名
LBA_FILE=`realpath ${1}`

#参数2: 可指定
if [ ! -z ${2} ]; then
	cluster_sectors=${2}
	bsrange="1-${cluster_sectors}"
fi

#参数3: 可指定
if [ ! -z ${3} ]; then
	bwlimit=${3}
fi

if [ ! -f ${LBA_TOOLS} ]; then
	#临时激活的LBA工具
	LBA_TOOLS=/run/hd_write_verify

	if [ ! -f ${LBA_TOOLS} ]; then
		LBA_TOOLS=hd_write_verify
	fi
fi

if [ -f ${LBA_FILE} ]; then
	#文件存储: 校验上次LBA测试文件数据一致性
	${LBA_TOOLS} -c -D -K -T 10 -L ${bwlimit} ${LBA_FILE}

	dmesg -T >> /var/log/dmesg.txt

	#如果测试出LBA问题，保留对应文件
	LBA_INFO=$(dmesg -cT | grep -n "BUG 00")
	if [ ! -z "${LBA_INFO}" ]; then
		echo "${LBA_INFO}"
		exit 1
	fi

	rm -f ${LBA_FILE} > /dev/null 2>&1

	#退出测试
	if [ -f /var/log/QUIT_FILE_LBA_TEST ]; then
		exit 0
	fi
fi

#LBA测试参数保留一份到dmesg日志
echo "${LBA_TOOLS} -c -D -K -w on -U on -t on -n 3 -B ${bsrange} -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} ${LBA_FILE}"
echo "${LBA_TOOLS} -c -D -K -w on -U on -t on -n 3 -B ${bsrange} -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} ${LBA_FILE}" > /dev/kmsg

while :;
do
	#退出测试
	if [ -f /var/log/QUIT_FILE_LBA_TEST ]; then
		break
	fi

	#创建LBA测试文件
	truncate --size 10G ${LBA_FILE}

	#文件存储稳定性测试和数据一致性校验
	${LBA_TOOLS} -c -D -K -w on -U on -t on -n 3 -B ${bsrange} -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} ${LBA_FILE}

	dmesg -T >> /var/log/dmesg.txt

	#如果测试出LBA问题，保留对应文件
	LBA_INFO=$(dmesg -cT | grep -n "BUG 00")
	if [ ! -z "${LBA_INFO}" ]; then
		echo "${LBA_INFO}"
		break
	fi

	rm -f ${LBA_FILE} > /dev/null 2>&1

	#同时进行多个LBA测试(磁盘/文件/内存等)时，删除已结束LBA测试的mem_map文件
	LBA_PID=`pidof hd_write_verify`

	if [ ! -z "${LBA_PID}" ]; then
		FILTER=$(echo "${LBA_PID}" | sed s/" "/"\|"/g)
		MAP_FILE=$(find /var/hd_write_verify/ -name mem_map* | grep -Ev "${FILTER}")
	fi

	rm -f ${MAP_FILE} > /dev/null 2>&1

	sleep 3
done
