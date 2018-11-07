#!/bin/bash

#Update yum packages
yum -y update
#install git
yum install -y git
#install vim
yum install -y vim
#install apache
yum install -y httpd
#start apache
systemctl start httpd.service
#enable apache
systemctl enable httpd.service
#Get mariadb 10.3
echo "# MariaDB 10.3 CentOS repository list - created 2018-11-07 19:52 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1" > /etc/yum.repos.d/MariaDB.repo
#Install MariaDB
yum install -y MariaDB-server MariaDB-client
#start mariaDB
systemctl start mariadb
#install mariadb
mysql_secure_installation
#Enable MariaDB
systemctl enable mariadb.service
#Configure firewall
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload


#PHP 7 configuration
#Get the repo information
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
#Install php7 & modules
yum install -y php71w php71w-opcache php71w-mysql php71w-pear php71w-xmlrpc php71w-common php71w-devel php71w-intl php71w-ldap php71w-mbstring php71w-gd php71w-xml php71w-soap


#Set SElinx to permissive
echo "# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=permissive
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
" > /etc/selinux/config
#set selinux to permissive now
setenforce permissive

#Install and configure phpmyadmin
yum install -y epel-release
yum install -y phpmyadmin

echo "# phpMyAdmin - Web based MySQL browser written in php
#
# Allows only localhost by default
#
# But allowing phpMyAdmin to anyone other than localhost should be considered
# dangerous unless properly secured by SSL

Alias /phpMyAdmin /usr/share/phpMyAdmin
Alias /phpmyadmin /usr/share/phpMyAdmin

<Directory /usr/share/phpMyAdmin/>
   AddDefaultCharset UTF-8

      <IfModule mod_authz_core.c>
        # Apache 2.4
	<RequireAny>
	Require all granted
	Require ip 127.0.0.1
	Require ip ::1
	</RequireAny>
	</IfModule>
	<IfModule !mod_authz_core.c>
	# Apache 2.2
	Order Allow,Deny
	Allow from All
	Allow from 127.0.0.1
	Allow from ::1
	</IfModule>
	</Directory>

	<Directory /usr/share/phpMyAdmin/setup/>
	<IfModule mod_authz_core.c>
	# Apache 2.4
	<RequireAny>
	Require ip 127.0.0.1
	Require ip ::1
	</RequireAny>
	</IfModule>

	<IfModule !mod_authz_core.c>
	# Apache 2.2
	Order Deny,Allow
	Deny from All
	Allow from 127.0.0.1
	Allow from ::1
	</IfModule>
	</Directory>

# These directories do not require access over HTTP - taken from the original
# phpMyAdmin upstream tarball
#
	<Directory /usr/share/phpMyAdmin/libraries/>
	Order Deny,Allow
	Deny from All
	Allow from None
    </Directory>

	<Directory /usr/share/phpMyAdmin/setup/lib/>
	Order Deny,Allow
	Deny from All
	Allow from None
	</Directory>

	<Directory /usr/share/phpMyAdmin/setup/frames/>
	Order Deny,Allow
	Deny from All
	Allow from None
	</Directory>

# This configuration prevents mod_security at phpMyAdmin directories from
# filtering SQL etc.  This may break your mod_security implementation.
#
#<IfModule mod_security.c>
#    <Directory /usr/share/phpMyAdmin/>
#        SecRuleInheritance Off
#    </Directory>
#</IfModule>
" > /etc/httpd/conf.d/phpMyAdmin.conf


systemctl restart httpd
