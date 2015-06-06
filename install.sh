#!/usr/bin/env bash

# OS VERSION: Ubuntu Server 
# ARCH: x32_64
# Script Version : Beta 0.0.1 
# Author : Rahul V Ramesh

# Check For Panels


# Getting Details From User

	echo -n "Enter Domain Name: "
	read fqdn
	echo -n "Enter Public IP: "
	read ip

    



# Installing The Stacks
apt-get update

# Install some standard utility packages required by the installer 
apt-get -y install sudo wget vim make zip unzip git debconf-utils at


# Go For Non Inractives
# export DEBIAN_FRONTEND=noninteractive
apt-get install apache2 mysql-server php5-mysql php5 libapache2-mod-php5 php5-mcrypt php5-common php5-curl bind9 bind9utils bind9-doc phpMyAdmin zip webalizer build-essential bash-completion


#wget https://raw.githubusercontent.com/rahulvramesh/Speech-Pilot-Res/master/dir.conf

cp /etc/apache2/mods-enabled/dir.conf /etc/apache2/mods-enabled/dir.conf_back
cp dir.conf /etc/apache2/mods-enabled/dir.conf


cat <<EOF > /var/www/html/index.php
<?php
echo "It Works Fine";
?>
EOF

echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf

# Setting BIND


#echo $fqdn
#wget https://raw.githubusercontent.com/rahulvramesh/Speech-Pilot-Res/master/db.linuxconfig.org
cp db.linuxconfig.org db.$fqdn
rm db.linuxconfig.org

sed -i "s|linuxconfig.org|$fqdn|" db.$fqdn
sed -i "s|192.168.0.10|$ip|" db.$fqdn

#sed -i 's//$fqdn/g' db.$fqdn
#sed -i 's/192.168.0.10/$ip/g' db.$fqdn

mkdir -p /etc/bind/zones/master
cp db.$fqdn /etc/bind/zones/master/db.$fqdn



# TO-DO Address To Name Mapping 

#conf
#wget https://github.com/rahulvramesh/Speech-Pilot-Res/blob/master/named.conf.local
rm /etc/bind/named.conf.local
sed -i "s|linuxconfig.org|$fqdn|" named.conf.local
#sed -i 's/linuxconfig.org/$fqdn/g' named.conf.local
cp named.conf.local /etc/bind/named.conf.local

#wget https://github.com/rahulvramesh/Speech-Pilot-Res/blob/master/named.conf.options
rm /etc/bind/named.conf.options
sed -i "s|linuxconfig.org|$fqdn|" named.conf.options
#sed -i 's/linuxconfig.org/$fqdn/g' named.conf.options
cp named.conf.options /etc/bind/named.conf.options


# Enable Services 

service apache2 restart
#service postfix restart
#service dovecot start
#service cron reload
service mysql restart
service bind9 restart









