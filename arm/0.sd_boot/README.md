# uboot_boot_rtt

#### 介绍
将该固件放在SD卡中，上电后启动可以看到如下输出信息。

```
U-Boot 2020.07-rc1-g627e7ce (May 11 2020 - 19:26:54 +0800)

DRAM:  1.1 GiB
RPI 4 Model B (0xb03112)
MMC:   emmc2@7e340000: 0, mmcnr@7e300000: 1
Loading Environment from FAT... OK
In:    serial
Out:   serial
Err:   serial
Net:   
Warning: genet@7d580000 MAC addresses don't match:
Address in DT is                dc:a6:32:95:c1:79
Address in environment is       dc:a6:32:28:22:50
eth0: genet@7d580000
Hit any key to stop autoboot:  0 
U-Boot> 
```

需要注意修改的是

1.插入网线

2.设置环境

```
setenv bootcmd "dhcp 0x00100000 192.168.12.137:kernel7.img;dcache flush;go 0x00100000"
saveenv
```

其中的ip地址为自己服务器的ip地址

3.将编译好的固件放到tftp根目录下

启动即可



注意：

如果是电脑的静态ip，可以不用dhcp

可以将