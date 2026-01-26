#!/bin/bash

#Author: YOUPLUS <zhang_youjia@126.com>
#注意: 脚本必须以前台方式运行
#主要作用: SSD稳定性测试和数据一致性校验

#默认不限速
bwlimit=0

#默认簇大小
cluster_sectors=2048

#指定IO随机大小范围
bsrange="1-2048"

skip_disk=0
stripe_disk_list=""

#虚拟地址与物理地址映射文件
MAP_FILE=/var/hd_write_verify/mem_map*

#升级的LBA工具
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

echo -e "\033[40m\033[0m"
echo -e "\033[1;30;44m ------------------------------------------------------ \033[0m\n"
echo -e "\033[1;37;40m       Welcome to the YOUPLUS's LBA TESTING SYSTEM      \033[0m\n"
echo -e "\033[1;37;40m       https://github.com/zhangyoujia/                  \033[0m\n"
echo -e "\033[1;30;44m ------------------------------------------------------ \033[0m\n"

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
		bsrange="1-${cluster_sectors}"
	fi

	#参数3: 可指定
	if [ ! -z ${3} ]; then
		bwlimit=${3}
	fi
else
	#参数1: 可指定
	if [ ! -z ${1} ]; then
		cluster_sectors=${1}
		bsrange="1-${cluster_sectors}"
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

	#处理软链接
	if [[ -L ${stripe_disk_list} && -e ${stripe_disk_list} ]]; then
		stripe_disk_list=$(readlink -f "${stripe_disk_list}")
	fi

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

if [ ! -f ${LBA_TOOLS} ]; then
	#临时激活的LBA工具
	LBA_TOOLS=/run/hd_write_verify

	if [ ! -f ${LBA_TOOLS} ]; then
		LBA_TOOLS=hd_write_verify
	fi
fi

#同时进行多个LBA测试(硬盘/文件/内存等)时，删除已结束LBA测试的mem_map文件
LBA_PID=`pidof hd_write_verify`

if [ ! -z "${LBA_PID}" ]; then
	FILTER=$(echo "${LBA_PID}" | sed s/" "/"\|"/g)
	MAP_FILE=$(find /var/hd_write_verify/ -name mem_map* | grep -Ev "${FILTER}")
fi

rm -f ${MAP_FILE} > /dev/null 2>&1

#LBA测试参数保留一份到dmesg日志
echo "${LBA_TOOLS} -c -D -K -w on -W random -B ${bsrange} -S ${cluster_sectors} -V all -T 64 -L ${bwlimit} -P robin ${stripe_disk_list}"
echo "${LBA_TOOLS} -c -D -K -w on -W random -B ${bsrange} -S ${cluster_sectors} -V all -T 64 -L ${bwlimit} -P robin ${stripe_disk_list}" > /dev/kmsg

#块存储稳定性测试和数据一致性校验
${LBA_TOOLS} -c -D -K -w on -W random -B ${bsrange} -S ${cluster_sectors} -V all -T 64 -L ${bwlimit} -P robin ${stripe_disk_list}
