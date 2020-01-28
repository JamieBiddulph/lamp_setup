#!/bin/bash
#Author: Jamie Biddulph (https://github.com/JamieBiddulph)

#Update packages
echo "------Updating packages------"
apt-get update
echo "------Upgrading packages------"
apt-get upgrade
#install git, vim, zip, wget, net-tools, unzip
apt-get -y install git vim zip wget net-tools unzip software-properties-common
#Get mariadb 10.2
echo "------Adding MariaDB repo to apt------"
apt-get install -y software-properties-common
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirrors.coreix.net/mariadb/repo/10.2/ubuntu bionic main'
#Install MariaDB
echo "------Updating apt repository-------"
apt update
echo "------Installing MariaDB server & client------"
apt install -y mariadb-server mariadb-client
#start mariaDB
echo "------Starting MariadDB service------"
/etc/init.d/mysql start
#install mariadb
echo "-----Installing MariaDB------"
mysql_secure_installation
#add apache ppa https://launchpad.net/~ondrej/+archive/ubuntu/apache2
echo "------Adding ppa:ondrej/apache2------" 
add-apt-repository ppa:ondrej/apache2
echo "------Updating apt repository-------"
apt-get update
#install apache
echo "------Installing apache2------"
apt-get install -y apache2
#add php73 ppa https://launchpad.net/%7Eondrej/+archive/ubuntu/php
echo "------Adding php ppa------" 
add-apt-repository ppa:ondrej/php
apt-get update
#installing php73 and required extensions
echo "------Installing php and required extensions------"
apt-get install -y php7.3 php7.3-mysqlnd php7.3-intl php7.3-gd php7.3-xml php7.3-zip php7.3-mbstring php7.3-soap php7.3-xmlrpc php7.3-ldap php7.3-curl
#tweak php.ini for apache
#set post_max_size to 500M
sed -ie 's/8M/500M/g' /etc/php/7.3/apache2/php.ini
#set upload_max_filesize to 500M
sed -ie 's/2M/500M/g' /etc/php/7.3/apache2/php.ini
#set max_execution to 60 seconds
sed -ie 's/30/60/g' /etc/php/7.3/apache2/php.ini
#set memory_limit to 128M
sed -ie 's/12500/128/g' /etc/php/7.3/apache2/php.ini
#set opcache revalidate frequencey to 60
sed -ie 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=60/g' /etc/php/7.3/apache2/php.ini
#starting apache2
echo "------Starting apache------"
/etc/init.d/apache2 start
#create database for moodle
read -p "Enter mysql root user: " dbuser
read -p "Enter mysql root password: " dbpass
read -p "Enter database name: " dbname
echo "------Creating database------"
mysql -u $dbuser -p$dbpass -Bse "SET GLOBAL innodb_large_prefix = 1;SET GLOBAL innodb_file_per_table = 1;SET GLOBAL innodb_file_format = barracuda;CREATE DATABASE $dbname DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
#show database back to user
echo "------Successfully created database------"
mysql -u $dbuser -p$dbpass -Bse "SHOW DATABASES;" | grep $dbname
#create cron file
echo "* * * * *  /bin/bash /var/www/cron.sh" > /etc/cron.d/moodle
echo "#!/bin/bash
/usr/bin/php7.3 /var/www/html/admin/cli/cron.php" > /var/www/cron.sh
chmod 755 /var/www/cron.sh
/etc/init.d/cron start
crontab /etc/cron.d/moodle
