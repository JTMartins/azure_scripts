﻿#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install python-software-properties
add-apt-repository -y ppa:ondrej/php5-oldstable
sudo apt-get -y update

# set up a silent install of MySQL
dbpass=$1
SharedStorageAccountName=$2
SharedAzureFileName=$3
FullNameOfSite=$4
ShortNameOfSite=$5
installOfficePlugins=$10
SharedStorageAccountKey=$11
LoadbalancerFqdn=$12
DbFqdn=$13

export DEBIAN_FRONTEND=noninteractive
sudo echo mysql-server-5.6 mysql-server/root_password password $dbpass | debconf-set-selections
sudo echo mysql-server-5.6 mysql-server/root_password_again password $dbpass | debconf-set-selections

# install the LAMP stack
sudo apt-get -y install apache2 mysql-client mysql-server php5

# install Extra PHP requirements

sudo apt-get -y install php5-curl php5-gd php5-ldap php5-mbstring php5-mcrypt php5-mysql php5-xml

# add port 8000 for admin access
sudo perl -0777 -p -i -e 's/Listen 80/Listen 80\nListen 8080/ig' /etc/apache2/ports.conf
sudo perl -0777 -p -i -e 's/\*:80/*:80 *:8080/g' /etc/apache2/sites-enabled/000-default.conf

sudo apt-get install unzip




# restart Apache
sudo apachectl restart



#resolve domain name to ip address
wwwrootval="http://$(resolveip -s $LoadbalancerFqdn):80/"
DbIpAddress=$(resolveip -s $DbFqdn)
