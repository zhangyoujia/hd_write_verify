## YOUPLUS's tools
![YOUPLUS's tools](./YOUPLUS工具箱.png)

# hd_write_verify & hd_write_verify_dump
=========================================================================

Copyright (c) 2016 YOUPLUS

Author: YOUPLUS(<zhang_youjia@126.com>)

hd_write_verify & hd_write_verify_dump is a tool for testing disk stability and verifying data consistency, for example: physical disk: ide/sata/scsi/ssd/iscsi/fc/raid. virtual disk: loop/nbd/lvm/soft raid. virtual machine disk: ide/sata/scsi/virtio-blk/virtio-scsi.

## Linux版本
`hd_write_verify / hd_write_verify_dump [opts] <disk|file>`

![usage](./test/hd_write_verify%20help.png)

![usage](./test/hd_write_verify_dump%20help.png)

## Test & Verify Data Layout
![layout](./test/hd_write_verify%20V0.05.png)
![layout](./test/layout.png)

## Examples: (hd_write_verify)
![example](./test/lba工具使用演示.gif)

![example](./test/lba工具_BUG%20007.gif)

## start & pause
![example](./test/pause%20%26%20start.png)

## LBA Problem: BUG_001
![example](./test/BUG_001.png)

## LBA Problem: BUG_002
![example](./test/BUG_002.png)

## LBA Problem: BUG_003
![example](./test/BUG_003.png)

## LBA Problem: BUG_004
![example](./test/BUG_004\(2\).png)

## LBA Problem: BUG_005
![example](./test/BUG_005.png)

## LBA Problem: BUG_006
![example](./test/BUG_006\(3\).png)

## Examples: (hd_write_verify_dump)
![example](./test/hd_write_verify_dump.png)

![example](./test/hd_write_verify_dump\(4\).png)

![example](./test/lun_lba_part.png)


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
#linux两条带测试
![example](./test/两条带测试_linux.png)

#linux两条带线程数据校验
![example](./test/两条带线程数据校验_linux.png)

#linux两条带簇间数据校验
![example](./test/两条带簇间数据校验_linux.png)

#linux两条带簇内数据校验
![example](./test/两条带簇内数据校验_linux.png)

#linux三条带测试
![example](./test/三条带测试_linux.png)

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
