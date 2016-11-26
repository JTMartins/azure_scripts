#!/bin/bash

sudo apt-get -y update

sudo apt-get -y install python-software-properties

sudo add-apt-repository -y ppa:ondrej/php

sudo apt-get -y update



# set up a silent install of MySQL

dbpass=$1

SharedStorageAccountName=$2
SharedAzureFileName=$3
SharedStorageAccountKey=$4



export DEBIAN_FRONTEND=noninteractive

sudo echo mysql-server-5.6 mysql-server/root_password password $dbpass | debconf-set-selections

sudo echo mysql-server-5.6 mysql-server/root_password_again password $dbpass | debconf-set-selections



# install the LAMP stack

sudo apt-get -y install apache2 mysql-client mysql-server php5.6



# install Extra PHP requirements

sudo apt-get -y install php5.6-curl php5.6-gd php5-ldap php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-xml



# Allow remote connection

sudo sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf



# create moodle database

MYSQL=`which mysql`



Q1="CREATE DATABASE moodle DEFAULT CHARACTER SET UTF8 COLLATE utf8_unicode_ci;"

Q2="GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO 'root'@'%' IDENTIFIED BY '$dbpass' WITH GRANT OPTION;"

Q3="FLUSH PRIVILEGES;"

SQL="${Q1}${Q2}${Q3}"



$MYSQL -uroot -p$dbpass -e "$SQL"

# Create Azure file share that will be used by front end VM's for moodledata directory



sudo apt-get -y install nodejs-legacy

sudo apt-get -y install npm

sudo npm install -g azure-cli



azure storage share create $SharedAzureFileName -a $SharedStorageAccountName -k $SharedStorageAccountKey






# restart MySQL

sudo service mysql restart



# restart Apache

sudo apachectl restart