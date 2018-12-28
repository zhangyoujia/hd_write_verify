# hd_write_verify & hd_write_verify_dump
=========================================================================

Copyright (c) 2016 YOUPLUS

Author: YOUPLUS(<zhang_youjia@126.com>)

hd_write_verify & hd_write_verify_dump is a tool for testing disk stability and verifying data consistency, for example: physical disk: ide/sata/scsi/ssd/iscsi/fc/raid. virtual disk: loop/nbd/lvm/soft raid. virtual machine disk: ide/sata/scsi/virtio-blk/virtio-scsi.

## Compile
<pre>
`gcc -g -std=c99 -O2 -D_GNU_SOURCE -lpthread -lrt -o hd_write_verify hd_write_verify.h hd_write_verify.c`
`gcc -g -std=c99 -O2 -D_GNU_SOURCE -o hd_write_verify_dump hd_write_verify.h hd_write_verify_dump.c`
</pre>

## Usage
`hd_write_verify / hd_write_verify_dump [opts] <disk>`

![useage](./test/hd_write_verify%20help.png)

![useage](./test/hd_write_verify_dump%20help.png)

## Test & Verify Data Layout
![layout](./test/hd_write_verify%20V0.05.png)
![layout](./test/layout.png)

## Examples: (hd_write_verify)
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


## windows版本
![example](./test/hd_write_verify%20help\(2\).png)

![example](./test/hd_write_verify.png)

![example](./test/hd_write_verify_dump\(windows\).png)
