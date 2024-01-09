#!/bin/bash

PROC_PID=$(pidof -o $$ -x date.sh)
if [ ! -z "${PROC_PID}" ]; then
	kill -9 "${PROC_PID}"
fi

PROC_PID=$(pidof -o $$ -x mem_dirty_speed.sh)
if [ ! -z "${PROC_PID}" ]; then
	kill -9 "${PROC_PID}"
fi
