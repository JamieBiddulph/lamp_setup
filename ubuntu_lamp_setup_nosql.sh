#!/bin/bash
#Author: Jamie Biddulph (https://github.com/JamieBiddulph)

#Update packages
echo "------Updating packages------"
apt-get update
echo "------Upgrading packages------"
apt-get upgrade
#install git, vim, zip, wget, net-tools, unzip
apt-get -y install git vim zip wget net-tools unzip
#install mysql client
echo "------Installing mysql client------"
apt-get install mysql-client
#add apache ppa https://launchpad.net/~ondrej/+archive/ubuntu/apache2
echo "------Adding ppa:ondrej/apache2------" 
add-apt-repository ppa:ondrej/apache2
echo "------Updating apt repository-------"
apt-get update
#install apache
echo "------Installing apache2------"
apt-get install -y apache2
#add php72 ppa https://launchpad.net/%7Eondrej/+archive/ubuntu/php
echo "------Adding php ppa------" 
add-apt-repository ppa:ondrej/php
apt-get update
#installing php72 and required extensions
echo "------Installing php and required extensions------"
apt-get install -y php7.2 php7.2-mysqlnd php7.2-intl php7.2-gd php7.2-xml php7.2-zip php7.2-mbstring php7.2-soap php7.2-xmlrpc php7.2-ldap php7.2-curl
#tweak php.ini for apache
#set post_max_size to 500M
sed -ie 's/8M/500M/g' /etc/php/7.2/apache2/php.ini
#set upload_max_filesize to 500M
sed -ie 's/2M/500M/g' /etc/php/7.2/apache2/php.ini
#set max_execution to 60 seconds
sed -ie 's/30/60/g' /etc/php/7.2/apache2/php.ini
#set opcache revalidate frequencey to 60
sed -ie 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=60/g' /etc/php/7.2/apache2/php.ini
#starting apache2
echo "------Starting apache------"
/etc/init.d/apache2 start
