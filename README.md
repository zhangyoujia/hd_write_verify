## YOUPLUS's tools
![YOUPLUS's tools](./YOUPLUS工具箱.png)

=========================================================================

# hd_write_verify & hd_write_verify_dump

Copyright (c) 2016-2023 YOUPLUS

Author: YOUPLUS(<zhang_youjia@126.com>)

hd_write_verify & hd_write_verify_dump is a tool for testing disk stability and verifying data consistency, for example:
physical disk: ide/sata/scsi/ssd/iscsi/fc/raid. virtual disk: loop/nbd/lvm/soft raid.
virtual machine disk: ide/sata/scsi/virtio-blk/virtio-scsi.

## Linux版本
`hd_write_verify / hd_write_verify_dump [opts] <disk|file>`

![usage](./test/hd_write_verify%20help.png)

![usage](./test/hd_write_verify_dump%20help.png)

## Copyright & Data Layout
![layout](./test/LBA_layout.png)
![layout](./test/layout.png)

## LBA工具参数说明
![example](./test/hd_write_verify参数说明.png)

## LBA工具输出说明
![example](./test/LBA工具输出说明.png)

## LBA dump工具参数说明
![example](./test/hd_write_verify_dump参数说明.png)

## LBA dump工具输出说明
![example](./test/LBA工具输出说明2.png)

## LBA错误类型
![example](./test/LBA错误类型.png)

## 条带策略：round-robin
![example](./test/round-robin.png)

## 条带策略：cluster-split
![example](./test/cluster-split.png)

## 存储稳定性测试与数据一致性校验工具和系统
![example](./test/存储稳定性测试与数据一致性校验工具和系统.png)

## 目录
![example](./test/目录.png)

## 展望
![example](./test/展望.png)

## Examples: (hd_write_verify)
![example](./test/YOUPLUS's_LBA_TEST_SYSTEM.png)

![example](./test/YOUPLUS's_LBA_TEST_SYSTEM2.png)

![example](./test/lba工具使用演示.gif)

![example](./test/lba工具_BUG%20007.gif)

## LBA Problem: BUG_001[1]
![example](./test/BUG001[1].png)

## LBA Problem: BUG_001[2]
![example](./test/BUG001[2].png)

## LBA Problem: BUG_001[3]
![example](./test/BUG001[3].png)

## LBA Problem: BUG_001[4]
![example](./test/BUG001[4].png)

## LBA Problem: BUG_002[1]
![example](./test/BUG002[1].png)

## LBA Problem: BUG_002[2]
![example](./test/BUG002[2].png)

## LBA Problem: BUG_002[3]
![example](./test/BUG002[3].png)

## LBA Problem: BUG_002[4]
![example](./test/BUG002[4].png)

## LBA Problem: BUG_003
![example](./test/BUG003.png)

## LBA Problem: BUG_004
![example](./test/BUG004.png)

## LBA Problem: BUG_005
![example](./test/BUG005.png)

## LBA Problem: BUG_006
![example](./test/BUG006.png)

## LBA Problem: BUG_007[1]
![example](./test/BUG007[1].png)

## LBA Problem: BUG_007[2]
![example](./test/BUG007[2].png)

## LBA Problem: BUG_007[3]
![example](./test/BUG007[3].png)

## LBA Problem: BUG_007[4]
![example](./test/BUG007[4].png)

## Examples: (hd_write_verify_dump)
![example](./test/dump.png)

![example](./test/簇内数据校验.png)

![example](./test/簇内数据校验2.png)


## Windows版本
![usage](./test/hd_write_verify.exe%20help.png)

![example](./test/hd_write_verify.png)

![example](./test/hd_write_verify3.png)

![example](./test/hd_write_verify_dump\(windows\).png)


## 磁盘稳定性自动化测试
![example](./test/磁盘lba工具自动化测试.png)

![example](./test/磁盘lba工具自动化测试1.png)

![example](./test/磁盘lba工具自动化测试2.png)

![example](./test/磁盘lba工具自动化测试4.png)

![example](./test/磁盘lba工具自动化测试5.png)

## linux文件条带测试
#linux条带测试：round-robin
![example](./test/stripe_robin.png)

#linux条带线程数据校验：round-robin
![example](./test/stripe_robin_dump.png)

#linux条带测试：cluster-split
![example](./test/stripe_split.png)

#linux条带线程数据校验：cluster-split
![example](./test/stripe_split_dump.png)

## windows磁盘条带测试
#windows两磁盘条带测试
![example](./test/两磁盘条带测试_windows.png)

#windows两条带线程数据校验
![example](./test/两条带线程数据校验_windows.png)

#windows两条带簇间数据校验
![example](./test/两条带簇间数据校验_windows.png)

#windows两条带簇内数据校验
![example](./test/两条带簇内数据校验_windows.png)

#windows三条带自动化测试
![example](./test/三条带自动化测试_windows.png)
