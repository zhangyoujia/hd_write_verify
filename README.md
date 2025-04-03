## YOUPLUS's tools
![YOUPLUS's tools](./YOUPLUS工具箱.png)

## ‼️注意
自动化测试系统的ISO文件太大(几百MB)，在github和gitee上更新维护不方便；请访问百度网盘(https://pan.baidu.com/s/1hxM1idYhY1Z3UgqprXif6Q 和 提取码：LBA1)获取最新的LBA工具和自动化测试系统ISO。

=========================================================================

# hd_write_verify & hd_write_verify_dump

Author: YOUPLUS(<zhang_youjia@126.com>)

Copyright (c) 2016-2024 YOUPLUS. All Rights Reserved.

Data is a vital asset for many businesses, making storage stability and data consistency the most fundamental requirements in storage technology scenarios.

The purpose of storage stability testing is to ensure that storage devices or systems can operate normally and remain stable over time, while also handling various abnormal situations such as sudden power outages and network failures. This testing typically includes stress testing, load testing, fault tolerance testing, and other evaluations to assess the performance and reliability of the storage system.

Data consistency checking is designed to ensure that the data stored in the system is accurate and consistent. This means that whenever data changes occur, all replicas should be updated simultaneously to avoid data inconsistency. Data consistency checking typically involves aspects such as data integrity, accuracy, consistency, and reliability.

LBA tools are very useful for testing Storage stability and verifying DATA consistency, there are much better than FIO & vdbench's verifying functions.

## 存储稳定性测试与数据一致性校验工具和系统
![example](./test/存储稳定性测试与数据一致性校验工具和系统.png)

## 个人简介
![example](./test/author.png)

## 目录
![example](./test/目录.png)

## 展望
![example](./test/展望.png)

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

## LBA工具实现原理
![example](./test/LBA工具实现原理1.png)

![example](./test/LBA工具实现原理2.png)

![example](./test/LBA工具实现原理3.png)

![example](./test/LBA工具实现原理4.png)

## 全盘数据校验
![example](./test/全盘数据校验.png)

## 批量数据校验
![example](./test/批量数据校验.png)

## 随机数据校验
![example](./test/随机数据校验.png)

## 条带策略：round-robin
![example](./test/round-robin.png)
![example](./test/stripe_policy_info.png)

## 条带策略：cluster-split
![example](./test/cluster-split.png)
![example](./test/stripe_policy_info2.png)

## 自动化测试系统
![example](./test/YOUPLUS's_LBA_TEST_SYSTEM.png)

![example](./test/YOUPLUS's_LBA_TEST_SYSTEM.gif)

![example](./test/YOUPLUS's_LBA_TEST_SYSTEM2.png)

## LBA工具典型应用场景
![example](./test/LBA工具典型应用场景1.png)

![example](./test/LBA工具典型应用场景2.png)

![example](./test/LBA工具典型应用场景3.png)

![example](./test/LBA工具典型应用场景4.png)

## LBA工具应用实例
![example](./test/LBA工具应用实例1.png)

![example](./test/LBA工具应用实例2.png)

![example](./test/LBA工具应用实例3.png)

![example](./test/LBA工具应用实例4.png)

![example](./test/LBA工具应用实例5.png)

![example](./test/LBA工具应用实例6.png)

![example](./test/LBA工具应用实例7.png)

![example](./test/LBA工具应用实例8.png)

![example](./test/LBA工具应用实例9.png)

## 自动化测试脚本：scripts
![example](./test/scripts.png)

![example](./test/物理存储自动化测试.png)

![example](./test/文件存储自动化测试.png)

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

## windows磁盘稳定性自动化测试
![example](./test/磁盘lba工具自动化测试.png)

![example](./test/磁盘lba工具自动化测试1.png)

![example](./test/磁盘lba工具自动化测试2.png)

![example](./test/磁盘lba工具自动化测试4.png)

![example](./test/磁盘lba工具自动化测试5.png)

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

#演示
![example](./test/lba工具使用演示.gif)

![example](./test/lba工具_BUG%20007.gif)

