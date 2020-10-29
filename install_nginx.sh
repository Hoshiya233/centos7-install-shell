#!/bin/bash
# 自动安装nginx，并开启支持ssl，仅支持centos7

# 判断是否已经安装
path="/usr/local/nginx"
file="/usr/local/bin/nginx"
if [ -f ${file} ];then
        echo "已创建软连接，请尝试在任意目录使用nginx -h"
fi
if [ -d ${path} ];then
        echo "这台服务器已经安装了nginx，安装目录为/usr/local/nginx"
        exit
fi


# 下载依赖
yum install -y wget gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel

# 下载安装包
mkdir /tmp/install_nginx/
wget -O /tmp/install_nginx/nginx.tar.gz http://nginx.org/download/nginx-1.19.4.tar.gz

# 添加用户和组
groupadd -r nginx
useradd -g nginx -r nginx

# 编译安装
cd /tmp/install_nginx
tar -zxvf nginx.tar.gz
cd nginx*
./configure --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module
make && make install

rm -rf /tmp/install_nginx

# 创建软连接
rm -f /usr/local/bin/nginx
ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx

nginx -h
if [ -d ${path} ];then
        echo "这台服务器已经安装了nginx，安装目录为/usr/local/nginx"
fi
if [ -f ${file} ];then
        echo "已创建软连接，请尝试在任意目录使用nginx -h"
fi
