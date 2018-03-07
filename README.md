# 使用 Vultr 搭建 ShadowSocks /VPS搭建SS（超详细）

**声明：文章原创，可以全文转载，禁止转载修改，禁止抄袭**

**声明：本文仅供测试，请依照相关法律合法使用**

* [本文链接-个人网站，建议收藏](https://zhangdanyang.com/#/Post/5a75116be9116c2be23e7b5d)

* [本文链接-CSDN](http://blog.csdn.net/boxuerixin/article/details/79295976)

* [本文链接-简书](https://www.jianshu.com/p/74083a8ea6a9)

# 请先读我
## 实现原理
本地发起连接请求，由远程服务器响应后然后将我们需要的数据返回到本地。

[了解更多戳我](http://vc2tea.com/whats-shadowsocks/)

## 最低消费

2.5美元（经常售罄），5美元。

## 网速自测

经过我个人测试后选择的Dallas节点，浏览youtube视频，网速能达到1MB/s
，玩美服lol的延迟是200ms-250ms，这个速度已经很不错了，具体分析参考[《国内连接美国VPN延迟(PING)多少算正常？》](http://www.vpnps.com/usa_vpn_ping.html)。

PS：浏览其他人的博客都推荐的是LosAngeles节点，具体的自己通过测试后拿主意吧，懒得测试就选洛杉矶节点吧。

了解更多，请戳[Vultr 节点哪个比较快？](https://www.v2ex.com/t/276585)

## 知识储备
1. 懂Linux最好，不懂就按照下面操作来吧
2. 肯折腾
3. 懂英语，不懂的话…搭建SS（Shadow Socks），诶？

## 具体步骤
### 购买服务器
1. 打开[链接1：我的夏季促销推广链接](http://www.vultr.com/?ref=7044457-3B)，无效的话尝试 [链接2：我的普通推广链接](http://www.vultr.com/?ref=7039524)。
这两个都指向官网，信不过我的自己去百度搜索vultr官网。【更多信息见最后的Vlutr服务器链接详细说明】

2. 注册账号并验证邮箱。

3. 测试速度或直接选择洛杉矶节点，[测试节点网速请戳我并拉到页面最下面](https://www.vultr.com/faq/)。如果感觉不满意，去试试其他的服务器提供商比如搬瓦工等等，个人感觉vultr还可以。

补充：近期东京结点基本都挂掉了，美国的也挂掉了很多，请尝试洛杉矶结点或达拉斯结点。

4. 充值，点击左侧的Billing，最低$10，建议选择支付宝支付，简单快捷，符合我国国情。

5. 搭建服务器，点击左侧的Servers，依次选择Server Location——你测试的最快的或者洛杉矶；Server Type——Cent OS7 x64（这个我可以提供技术支持，本文基于CentOS 7 x64，**脚本原创，脚本基于Cent OS7**）；Server Size——只是搭建ss，选价格最低的就够了($2.5/mon，多数情况下此套餐售罄，请选择$5/mon)；其他的选填。然后点击右下角的Deploy Now。稍等片刻，服务器就可以装好了。

6. 装好后，你可以看到如下界面：

![servers](http://upload-images.jianshu.io/upload_images/606686-1ac7f1e803a837ea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击可以查看服务器的相关信息：

![server information](http://upload-images.jianshu.io/upload_images/606686-94fdc78226d6cf94.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

接下来操作需要的信息是IP Address（IP地址），Username（用户名）和Password（密码）。这个页面不要关，一会直接复制粘贴相关信息。

### 远程连接服务器

> 方法①：使用网页版的进行操作。点击刚才的网页的右上角的五个按钮最左边的View Console进行操作。

> 方法②：使用ssh工具进行操作。 Windows用户使用putty或Xshell进行操作。Mac用户请使用终端或iTerm2进行操作。

#### 以Xshell为例（Windows用户请看）

1. 下载安装Xshell。
2. 安装完成后新建会话（快捷键Alt+N）。依次填写图中信息。
名称可以是Vultr或者其他，协议选择SSH，主机填写之前的IP Address，端口号选择22。

![连接](http://upload-images.jianshu.io/upload_images/606686-f322045231665e92.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击左侧的用户身份验证，填写信息。方法选择Password，用户名为之前的Username（一般都是root），密码为之前的Password（这个建议直接复制粘贴过来，系统给的有点复杂）

![用户身份验证](http://upload-images.jianshu.io/upload_images/606686-7b552de82575fe61.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

填写完之后点击确定。然后点击连接。出现其他提示的话选择接受就可以了。这时你就可以看到一个命令控制台了。这时就算连接成功了。

#### 以iTerm2为例（Mac用户请看）

1. 打开终端。
2. 输入命令。
```
ssh root@45.32.195.77
```
如果有提示很长一大段文字，服务器连接指纹认证，如下

![指纹验证](http://upload-images.jianshu.io/upload_images/606686-046a13945b6f62a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

输入
```
yes
```
接着出现

![请输入密码](http://upload-images.jianshu.io/upload_images/606686-78d901f620f45405.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

将系统给的密码复制过来进行粘贴，粘贴操作是不允许看到密码的，粘贴完直接回车即可。

这之后就连接上了服务器。你将看到如下界面：

![登录成功](http://upload-images.jianshu.io/upload_images/606686-ac875c4388253892.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 脚本快速安装（方案一，推荐用户：全体成员尤其是小白）

### 脚本功能
* 自定义**端口号**和**密码**，加密方式采用**aes-256-cfb**(脚本中采用此方式)
* 全过程静默安装，不会打扰用户，你所要做的就是去听一首音乐或者去喝杯咖啡
* 一次只允许运行一个shadowsocks进程，脚本会自动检测原来已经运行的进程并杀死
* 安装防火墙并开放需要的端口，实测vultr服务器不安装防火墙无法进行连接

### 操作步骤

1. 下载脚本
```
wget -O ss.sh http://zhangdanyang.com/ss.sh
```
![执行](http://upload-images.jianshu.io/upload_images/606686-0491a88d1baf8ecd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


2. 执行脚本
```
bash ss.sh
```
    # 设置端口号并回车，直接回车是设置为1225
    Please enter PORT(1225 default):
    # 设置密码并回车，直接回车是设置为123456
    Please enter PASSWORD(123456 default):

    # 等待一会……就完成了（初次执行约2-5min）

### 具体图示

![步骤，蓝框内的是手动输入的](http://upload-images.jianshu.io/upload_images/606686-e0b5b26371252815.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### gif 演示
![详细过程](http://upload-images.jianshu.io/upload_images/606686-575fe20efcfe327e.gif?imageMogr2/auto-orient/strip)


## 独立动手搭建（方案二，推荐用户：极客，爱折腾的人）

### 搭建 Shadowsocks 服务

#### 安装组件

    yum install m2crypto python-setuptools
    easy_install pip
    pip install shadowsocks

#### 安装完成后配置服务器参数
    vi  /etc/shadowsocks.json

写入如下配置:

    {
        "server":"0.0.0.0",
        "server_port":443,
        "local_address": "127.0.0.1",
        "local_port":1080,
        "password":"123456",
        "timeout":300,
        "method":"aes-256-cfb",
        "fast_open": false
    }

多端口的如下：

    {
        "server":"0.0.0.0",
        "local_address": "127.0.0.1",
        "local_port":1080,
        "port_password": {
             "443": "443",
             "8888": "8888"
         },
        "timeout":300,
        "method":"aes-256-cfb",
        "fast_open": false
    }

其中server字段与local_address填写之前的IP Address。password是自己用于连接这个shadow socks的密码，自定义就好。
其他的不需要更改。

然后保存退出。

vi 的命令: 按 "i" 进入编辑模式，编辑后按 "esc" 退出编辑模式， 输入 ":wq" 保存退出vi。

### 配置防火墙

    # 安装防火墙
    yum install firewalld
    # 启动防火墙
    systemctl start firewalld

#### 开启防火墙相应的端口

    # 端口号是你自己设置的端口
    firewall-cmd --permanent --zone=public --add-port=443/tcp
    firewall-cmd --reload

### 启动 Shadowsocks 服务

	# 后台运行    
    ssserver -c /etc/shadowsocks.json -d start

	# 调试时使用下面命令，实时查看日志
    ssserver -c /etc/shadowsocks.json


	
## 连接
这样服务器就搭建好了。[全平台的连接方法戳我](https://github.com/shadowsocks/shadowsocks/wiki)。

### PC连接
下载Shadow Socks客户端。[下载地址](https://github.com/shadowsocks/shadowsocks-windows/releases)
选择适合的版本，下载并解压运行。

填写信息:服务器地址，端口号，密码，加密方式与代理端口默认即可

![SS信息填写](http://upload-images.jianshu.io/upload_images/606686-4d8d781517796bde.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

填写完之后点击确定，然后**到托盘中右键选择开启"启用系统代理"**。

### iOS连接

在App Store下载Wingy。

填写信息:服务器，端口，密码，代理模式，加密方式默认即可。

![Wingy信息填写](http://upload-images.jianshu.io/upload_images/606686-84ea88f5860d36cf.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### MacOS连接

[下载地址](https://github.com/shadowsocks/shadowsocks-iOS/releases)
使用方式参考windows

### Android连接

[下载地址](https://github.com/shadowsocks/shadowsocks-android/releases)

## 国外站点

[Google](http://www.google.com/)

[Youtube](http://www.youtube.com/)

[Facebook](http://www.facebook.com/)

如果以上没有问题的话，这时候你就可以畅游外面的世界了。点击上述链接测试吧。

## 常见问题

### 远程连接工具xshell无法连接服务器。

此时ping一下服务器，如果ping不同，则证明创建的服务器ip被墙，请销毁掉当前服务器，重新创建新的服务器。

### 计费模式

服务器按照小时计费，如果一台服务器创建1天后就销毁了，那么只扣1天的费用。例如：服务器一个月$5，那么1天扣除的就是5/30美元。

