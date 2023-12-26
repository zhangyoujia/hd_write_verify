#!/bin/bash

#注意: 脚本必须以前台方式运行
#主要作用: 块存储稳定性测试和数据一致性校验

bwlimit=102400
cluster_sectors=2048

stripe_disk_list=""

LBA_TOOLS=/var/iso/tools/hd_write_verify

if [ ${#} -gt 3 ]; then
	echo "Usage: ${0} [disk] [cluster_sectors] [bwlimit]"
	echo "eg: ${0}"
	echo "eg: ${0} disk"
	echo "eg: ${0} disk cluster_sectors"
	echo "eg: ${0} disk cluster_sectors bwlimit"
	echo "eg: ${0} cluster_sectors"
	echo "eg: ${0} cluster_sectors bwlimit"
	exit 1
fi

#参数1: 可指定测试一个磁盘
if [ ! -z ${1} ]; then
	#存在指定的测试磁盘
	if [ -w ${1} ]; then
		stripe_disk_list=${1}
	fi
fi

if [ ! -z ${stripe_disk_list} ]; then
	#参数2: 可指定
	if [ ! -z ${2} ]; then
		cluster_sectors=${2}
	fi

	#参数3: 可指定
	if [ ! -z ${3} ]; then
		bwlimit=${3}
	fi
else
	#参数1: 可指定
	if [ ! -z ${1} ]; then
		cluster_sectors=${1}
	fi

	#参数2: 可指定
	if [ ! -z ${2} ]; then
		bwlimit=${2}
	fi
fi

if [ -z ${stripe_disk_list} ]; then
	for i in $(lsblk -nd | grep disk | awk '{print $1}' | sort);
	do
		#过滤掉已经挂载了文件系统的磁盘
		mount_info=$(cat /proc/mounts | grep ${i})
		if [ ! -z "${mount_info}" ]; then
			echo "Disk: /dev/${i} or part is a mountpoint"
			continue
		fi

		#过滤掉大小为0的磁盘
		size_info=$(cat /sys/block/${i}/size)
		if [ ${size_info} -eq 0 ]; then
			echo "Disk: /dev/${i} size is 0"
			continue
		fi

		#过滤掉已经被逻辑卷等hold的磁盘
		holder_info=$(ls -A /sys/block/${i}/holders)
		if [ ! -z "${holder_info}" ]; then
			echo "Disk: /dev/${i} has holder"
			continue
		fi

		stripe_disk_list="${stripe_disk_list} -I /dev/${i}"
	done
else
	#过滤掉已经挂载了文件系统的磁盘
	mount_info=$(cat /proc/mounts | grep ${stripe_disk_list})

	#过滤掉大小为0的磁盘
	size_info=$(cat /sys/block/$(basename ${stripe_disk_list})/size)

	#过滤掉已经被逻辑卷等hold的磁盘
	holder_info=$(ls -A /sys/block/$(basename ${stripe_disk_list})/holders)

	if [ ! -z "${mount_info}" ]; then
		skip_disk=1
		echo "Disk: ${stripe_disk_list} or part is a mountpoint"
	fi

	if [ ${size_info} -eq 0 ]; then
		skip_disk=1
		echo "Disk: ${stripe_disk_list} size is 0"
	fi

	if [ ! -z "${holder_info}" ]; then
		skip_disk=1
		echo "Disk: ${stripe_disk_list} has holder"
	fi

	if [ ${skip_disk} -eq 1 ]; then
		stripe_disk_list=""
	fi
fi

if [ "${stripe_disk_list}" == "" ]; then
	echo "ERROR! NO disk!"
	exit 1
fi

if [ ! -f $LBA_TOOLS ]; then
	LBA_TOOLS=hd_write_verify
fi

#关闭透明大页
echo -e "echo never > /sys/kernel/mm/transparent_hugepage/enabled\n"
echo never > /sys/kernel/mm/transparent_hugepage/enabled

#LBA测试参数保留一份到dmesg日志
echo "${LBA_TOOLS} -c -D -K -R 33 -w on -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} -P robin ${stripe_disk_list}"
echo "${LBA_TOOLS} -c -D -K -R 33 -w on -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} -P robin ${stripe_disk_list}" > /dev/kmsg

${LBA_TOOLS} -c -D -K -R 33 -w on -S ${cluster_sectors} -V all -T 10 -L ${bwlimit} -P robin ${stripe_disk_list}
