#!/bin/bash

#Author: YOUPLUS <zhang_youjia@126.com>
#注意: 脚本可以前台/后台方式运行
#主要作用: 通过定时获取内存文件大小，计算内存变脏速度

LOOP=0
MEM_DIR=/var/mem
MEM_FILE=${MEM_DIR}/mem_lba_test.raw
MEM_DIRTY_LOG=/var/log/mem_dirty_speed.log

limit_log_size()
{
	local log_file=$1
	local log_file_size=`stat -c %s ${log_file} 2>/dev/null`

	#日志大小超过5M时，重命名日志文件
	if [[ ${log_file_size} -gt 5120000 ]]; then
		mv ${log_file} ${log_file}.1
	fi
}

write_log()
{
	local log_file=$1

	echo "[`date +'%Y-%m-%d %H:%M:%S'`] $2" >> ${log_file}
}

while :;
do
	if [ ! -f ${MEM_FILE} ]; then
		sleep 1
		continue
	fi

	if [[ ${LOOP} -gt 3600 ]]; then
		LOOP=0
		limit_log_size ${MEM_DIRTY_LOG}
	fi
	LOOP=`expr ${LOOP} + 1`

	BLOCK_SIZE=$(stat ${MEM_FILE} | grep Blocks: | awk '{print $7}')
	BLOCKS1=$(stat ${MEM_FILE} | grep Blocks: | awk '{print $4}')

	sleep 1

	if [ ! -f ${MEM_FILE} ]; then
		continue
	fi

	BLOCKS2=$(stat ${MEM_FILE} | grep Blocks: | awk '{print $4}')

	if [[ ${BLOCKS1} -gt ${BLOCKS2} ]]; then
		continue
	fi

	DIRTY_BLOCKS=$(expr ${BLOCKS2} - ${BLOCKS1})
	DIRTY_SIZE=$(expr ${DIRTY_BLOCKS} \* $(expr ${BLOCK_SIZE} / 1024))

	write_log ${MEM_DIRTY_LOG} "Memory dirty: $(expr ${DIRTY_SIZE} / 1024) MB/s"
done
