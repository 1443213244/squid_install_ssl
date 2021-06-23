#!/bin/bash

squid_user=$1
squid_password=$2
squid_squid_port=3128
domain=$3

yum -y install socat squid httpd-tools
htpasswd -b -c /etc/squid/passwd $squid_user $squid_password

mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
touch /etc/squid/blacklist.acl
wget -O /etc/squid/squid.conf  https://raw.githubusercontent.com/1443213244/squid_install_ssl/main/squid.conf

iptables -I INPUT -p tcp --dport $squid_port -j ACCEPT
#/sbin/iptables-save
/sbin/service iptables save
iptables -F
curl  https://get.acme.sh | sh -s email=$4
/root/.acme.sh/acme.sh --issue -d $domain --standalone --debug
/root/.acme.sh/acme.sh --install-cert -d $domain \
--key-file       /etc/squid/key.pem  \
--fullchain-file /etc/squid/cert.pem \
--reloadcmd     "systemctl restart squid"

systemctl restart squid
systemctl enable squid
systemctl status squid
#update-rc.d squid defaults
