#!/bin/bash

#Author: YOUPLUS <zhang_youjia@126.com>
#注意: 脚本可以前台/后台方式运行
#主要作用: 文件存储稳定性测试和数据一致性校验

#默认限速
bwlimit=102400

#默认簇大小
cluster_sectors=2048

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

if [ ! -f ${LBA_TOOLS} ]; then
	#临时激活的LBA工具
	LBA_TOOLS=/run/hd_write_verify

	if [ ! -f ${LBA_TOOLS} ]; then
		LBA_TOOLS=`which hd_write_verify`

		if [ -f ${LBA_TOOLS} ]; then
			touch ${LBA_TOOLS}

			LBA_TOOLS=hd_write_verify
		else
			echo "NO LBA tools!"
			exit 1
		fi
	else
		touch ${LBA_TOOLS}
	fi

	sleep 1
fi

if [ -f ${LBA_FILE} ]; then
	#文件存储: 校验上次LBA测试文件数据一致性
	${LBA_TOOLS} -d -D -T 10 -L ${bwlimit} ${LBA_FILE} > "/var/log/$(basename ${LBA_FILE}).log"

	LBA_PID=$(ps -aux | grep ${LBA_TOOLS} | grep ${LBA_FILE} | awk '{print $2}')

	trap "kill -9 ${LBA_PID}" EXIT

	while :;
	do
		LBA_PID=$(ps -aux | grep ${LBA_TOOLS} | grep ${LBA_FILE} | awk '{print $2}')
		if [ -z ${LBA_PID} ]; then
			break
		fi

		sleep 3
	done

	LBA_INFO=$(grep -n BUG "/var/log/$(basename ${LBA_FILE}).log")
	if [ $? == 0 ]; then
		echo ${LBA_INFO}
		exit 1
	fi

	rm -f ${LBA_FILE} > /dev/null 2>&1

	#退出测试
	if [ -f /var/log/QUIT_FILE_LBA_TEST ]; then
		exit 0
	fi
fi

while :;
do
	#退出测试
	if [ -f /var/log/QUIT_FILE_LBA_TEST ]; then
		break
	fi

	#创建LBA测试文件
	truncate --size 10G ${LBA_FILE}

	#文件存储稳定性测试和数据一致性校验
	${LBA_TOOLS} -d -D -K -w on -U on -t on -n 3 -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} ${LBA_FILE} > "/var/log/$(basename ${LBA_FILE}).log"

	LBA_PID=$(ps -aux | grep ${LBA_TOOLS} | grep ${LBA_FILE} | awk '{print $2}')

	trap "kill -9 ${LBA_PID}" EXIT

	while :;
	do
		LBA_PID=$(ps -aux | grep ${LBA_TOOLS} | grep ${LBA_FILE} | awk '{print $2}')
		if [ -z ${LBA_PID} ]; then
			break
		fi

		sleep 3
	done

	LBA_INFO=`grep -n BUG "/var/log/$(basename ${LBA_FILE}).log"`
	if [ $? == 0 ]; then
		echo ${LBA_INFO}
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
done
