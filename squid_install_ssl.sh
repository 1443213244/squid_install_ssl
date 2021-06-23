#!/bin/bash

squid_user=$1
squid_password=$2
squid_squid_port=$3
domain=$4

yum -y install squid httpd-tools
curl  https://get.acme.sh | sh -s email=1443213244@qq.com
source ~/.bashrc
/root/.acme.sh/acme.sh --issue -d $domain --standalone
/root/.acme.sh/acme.sh --install-cert -d example.com \
--key-file       /path/to/keyfile/in/nginx/key.pem  \
--fullchain-file /path/to/fullchain/nginx/cert.pem \
--reloadcmd     "service nginx force-reload"


htpasswd -b -c /etc/squid/passwd $squid_user $squid_password

mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
touch /etc/squid/blacklist.acl
wget -O /etc/squid/squid.conf  https://raw.githubusercontent.com/khaledalhashem/squid/master/squid_centos.conf

iptables -I INPUT -p tcp --dport $squid_port -j ACCEPT
#/sbin/iptables-save
/sbin/service iptables save

systemctl restart squid
systemctl enable squid
systemctl status squid
#update-rc.d squid defaults
