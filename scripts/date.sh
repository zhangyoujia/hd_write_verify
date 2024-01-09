#!/bin/bash

LOOP=0
DATE_LOG=/var/log/date.log

limit_log_size()
{
	local log_file=$1
	local log_file_size=`stat -c %s ${log_file} 2>/dev/null`

	#日志大小超过5M时，重命名日志文件
	if [[ ${log_file_size} -gt 10240000 ]]; then
		mv ${log_file} ${log_file}.1
	fi
}

write_log()
{
	local log_file=$1

	echo "[`date +'%Y-%m-%d %H:%M:%S:%N'`]" >> ${log_file}
}

while :;
do
	if [[ ${LOOP} -gt 14400 ]]; then
		LOOP=0
		limit_log_size ${DATE_LOG}
	fi
	LOOP=`expr ${LOOP} + 1`

	write_log ${DATE_LOG}

	sleep 0.25
done
