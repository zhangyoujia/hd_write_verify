【scripts自动化测试脚本使用说明】
1.	把LBA工具(hd_write_verify和hd_write_verify_dump)放到/usr/sbin/目录下；

2.	给LBA工具加上可执行权限(chmod +x hd_write_verify hd_write_verify_dump)；

3.	把scripts自动化测试脚本放到/root/目录下；

4.	给scripts自动化测试脚本加上可执行权限(chmod +x /root/scripts/*)；

5.	自动化测试，实例：
测试块存储：
(1)	测试磁盘组:				/root/scripts/disk_lba_robin.sh或者/root/scripts/disk_lba_split.sh
(2)	测试单个指定磁盘:		/root/scripts/disk_lba_robin.sh /dev/sda
(3)	测试单个指定分区:		/root/scripts/disk_lba_robin.sh /dev/sda1

测试文件存储：
(1)	LBA工具前端测试:		/root/scripts/file_lba_test.sh    /path/lba_test.raw
(2)	LBA工具后端测试:		/root/scripts/file_lba_test_bg.sh /path/lba_test.raw

测试内存(通过tmpfs的方式，主要用于虚拟机热迁移场景，验证虚拟机内存热迁移前后的数据一致性)：
(1)	通过loop设备测试内存:	/root/scripts/mem_loop_lba_test.sh
(2)	查看内存变脏速度:		tail -f /var/log/mem_dirty_speed.log

6.	如有疑问，请参考《存储稳定性测试与数据一致性校验工具和系统.pptx》或者联系作者：
微信:	YOUPLUS2022
EMAIL:	zhang_youjia@126.com
