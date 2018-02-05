#! /bin/bash
# log路径
export log_path=/etc/ss.log
# 设置端口号
echo -n -e '\033[36mPlease enter PORT(1225 default): \033[0m'
# echo -n "please enter port(1225 default):"
read port
if [ ! -n "$port" ];then
        echo "port will be set to 1225"
        port=1225
else
        echo "port will be set to $port"
fi
# 设置密码
echo -n -e '\033[36mPlease enter PASSWORD(123456 default): \033[0m'
# echo -n "please enter password(123456 default):"
read pwd
if [ ! -n "$pwd" ];then
        echo "password will be set to 123456"
        pwd=123456
else
        echo "password will be set to $pwd"
fi
# 写shadowsocks.json配置文件
cat>/etc/shadowsocks.json<<EOF
{
    "server":"0.0.0.0",
    "server_port":$port,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"$pwd",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
}
EOF
# 安装 shadowsocks 防火墙等
ret=`yum install -y m2crypto python-setuptools >> ${log_path} 2>&1`
ret=`easy_install pip >> ${log_path} 2>&1`
ret=`pip install shadowsocks >> ${log_path} 2>&1`
ret=`yum install -y firewalld >> ${log_path} 2>&1`
ret=`systemctl start firewalld >> ${log_path} 2>&1`
# 开启端口
ret=`firewall-cmd --permanent --zone=public --add-port=22/tcp >> ${log_path} 2>&1`
ret=`firewall-cmd --permanent --zone=public --add-port=$port/tcp >> ${log_path} 2>&1`
ret=`firewall-cmd --reload >> ${log_path} 2>&1`
# 如果有相同功能的进程则杀死
ps -ef|grep ssserver|grep shadowsocks|grep -v grep  
if [ $? -eq 0 ];then  
    ps -ef|grep ssserver|grep shadowsocks|awk '{ print $2 }'|xargs kill -9 
fi
# 后台运行
/usr/bin/ssserver -c /etc/shadowsocks.json -d start
# 成功
if [ $? -eq 0 ];then
clear
cat<<EOF
***************Congratulation!*************
Shadowsocks installed successfully!

PORT: $port
PASSWORD: $pwd
METHOD: aes-256-cfb

***************JUST ENJOY IT!**************
EOF
# 失败
else
clear
cat<<EOF
************Failed,retry please!***********

cat /etc/ss.log to get something you need…

************Failed,retry please!***********
EOF
fi

