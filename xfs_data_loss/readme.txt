linux内核6.1至今，xfs(且不限)出现数据丢失，Meta和Cloudflare已revert掉对应feature
https://mp.weixin.qq.com/s/_EbwLafop3Z3hyNDE8dkEg

[1]:https://lore.kernel.org/linux-fsdevel/9e8f8872-f51b-4a09-a92c-49218748dd62@meta.com/T/#mba1caba86b22342fa221a740708c0abf2858dca6

[2]:https://github.com/torvalds/linux/commit/6795801366da0cd3d99e27c37f020a8f16714886

[3]:https://bugzilla.kernel.org/show_bug.cgi?id=217572

[4]:https://lore.kernel.org/lkml/CA+wXwBS7YTHUmxGP3JrhcKMnYQJcd6=7HE+E1v-guk01L2K3Zw@mail.gmail.com/T/

====================================================================================================

复现测试说明(测试了几天，目前还是没有复现出来)：
1.	创建ubuntu 24.04(kernel-6.8.0)虚拟机(ubuntun-24.04.png & ubuntun-24.04_虚拟机测试.png)进行复现测试；
2.	所有测试用例(xfs数据丢失问题复现测试用例.png)，仅使用LBA工具进行正常测试，没有在文件系统层、通用块层、磁盘驱动层等注入异常；
3.	两个或多个测试用例并发执行，存储性能跑满(iostat.png)；
4.	使用pagecache模式测试，大量消耗系统内存: free内存剩余很少；
5.	使用大IO和pagecache模式测试时，对比测试了开启和关闭透明大页的情况(开启透明大页.png & 关闭透明大页.png)；
6.	问题提出人(https://lore.kernel.org/linux-fsdevel/9e8f8872-f51b-4a09-a92c-49218748dd62@meta.com/T/#mba1caba86b22342fa221a740708c0abf2858dca6)，
	1500台虚拟机中的16台出现数据丢失(每隔几周出现一次)，出问题概率很低，如果要复现，可能需要较大规模的测试环境；
7.	下一步：测试脚本和LBA工具邮件发送给问题提出人使用；
