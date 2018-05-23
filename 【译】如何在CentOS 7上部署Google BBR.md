【译】如何在CentOS 7上部署Google BBR

[原文](https://www.vultr.com/docs/how-to-deploy-google-bbr-on-centos-7)

**译者注：当前内核版本已经是 `4.16.11-1.el7.elrepo.x86_64`，整个操作过程中，只有显示信息不同，shell命令部分完全相同。译文依照原文翻译。**

*********** 文章开始 ***********

> BBR(Bottleneck Bandwidth and RTT) 是一种新的拥塞控制算法，由谷歌贡献给Linux内核TCP协议栈。使用BBR后，Linux服务器可以显着提高吞吐量并减少连接延迟。此外，部署BBR很容易，因为此算法仅需要更新发送方，网络或接收方无需更新。

在本文中，我将向您展示如何在Vultr CentOS 7 KVM服务器实例上部署BBR。

### 准备条件

* Vultr CentOS 7 x64服​​务器实例。 
* 一个sudo用户。

### 步骤1：使用ELRepo RPM存储库升级内核

为了使用 BBR，您需要将 CentOS 7 机器的内核升级到4.9.0。您可以使用 ELRepo RPM 存储库轻松完成此操作。

在升级之前，您可以看看当前的内核： 
    
    uname -r 

该命令应输出一个类似于以下内容的字符串： 

    3.10.0-514.2.2.el7.x86_64

如您所见，当前内核为3.10.0。 

安装 ELRepo 库：

    sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

使用ELRepo库安装4.9.0内核： 
    
    sudo yum --enablerepo = elrepo-kernel安装kernel-ml -y

确认结果:

    rpm -qa | grep kernel

如果安装成功，您应该在输出列表中看到 `kernel-ml-4.9.0-1.el7.elrepo.x86_64` ：

    kernel-ml-4.9.0-1.el7.elrepo.x86_64
    kernel-3.10.0-514.el7.x86_64
    kernel-tools-libs-3.10.0-514.2.2.el7.x86_64
    kernel-tools-3.10.0-514.2.2.el7.x86_64
    kernel-3.10.0-514.2.2.el7.x86_64

现在，您需要通过设置默认的grub2启动项来启用4.9.0内核。

显示 grub2 菜单中的所有条目： 

    sudo egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'

结果应该类似于：

    CentOS Linux 7 Rescue a0cbf86a6ef1416a8812657bb4f2b860 (4.9.0-1.el7.elrepo.x86_64)
    CentOS Linux (4.9.0-1.el7.elrepo.x86_64) 7 (Core)
    CentOS Linux (3.10.0-514.2.2.el7.x86_64) 7 (Core)
    CentOS Linux (3.10.0-514.el7.x86_64) 7 (Core)
    CentOS Linux (0-rescue-bf94f46c6bd04792a6a42c91bae645f7) 7 (Core)

因为行数从`0`开始，而4.9.0内核项在第二行，因此将默认启动项设置为`1`：

    sudo grub2-set-default 1

重启系统：

    sudo shutdown -r now

当服务器恢复联机时，请重新登录并重新运行`uname`命令以确认您使用的是正确的内核：

    uname -r

您应该看到如下结果：

    4.9.0-1.el7.elrepo.x86_64

### 步骤2: 启用 BBR

为了启用BBR算法，您需要修改`sysctl`配置，如下所示：

    echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf
    echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

现在，您可以使用以下命令确认BBR已启用：

    sudo sysctl net.ipv4.tcp_available_congestion_control

输出应该类似于：

    net.ipv4.tcp_available_congestion_control = bbr cubic reno

接下来，验证：

    sudo sysctl -n net.ipv4.tcp_congestion_control

输出应该是：

    bbr

最后，检查内核模块是否已加载：

    lsmod | grep bbr

输出将类似于：

    tcp_bbr                16384  0

### 步骤3(可选)：测试网络性能增强

为了测试BBR的网络性能增强，您可以在Web服务器目录中创建一个文件进行下载，然后从台式机上的Web浏览器测试下载速度。

    sudo yum install httpd -y
    sudo systemctl start httpd.service
    sudo firewall-cmd --zone=public --permanent --add-service=http
    sudo firewall-cmd --reload
    cd /var/www/html
    sudo dd if=/dev/zero of=500mb.zip bs=1024k count=500

最后，从桌面计算机上的Web浏览器访问URL `http://[your-server-IP]/500mb.zip`，然后评估下载速度。

就这样。谢谢您的阅读。

*********** 文章结束 ***********