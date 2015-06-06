#!/usr/bin/env bash

# OS VERSION: Ubuntu Server 
# ARCH: x32_64
# Script Version : Beta 0.0.1 
# Author : Rahul V Ramesh

# Check For Panels
if [ -e /usr/local/cpanel ] || [ -e /usr/local/directadmin ] || [ -e /usr/local/solusvm/www ] || [ -e /usr/local/home/admispconfig ] || [ -e /usr/local/lxlabs/kloxo ] ; then
    echo "Please re-install your OS before attempting to install using this script."
    exit
fi

# Check For Installs Devcot , Apache2 , Mysql Etc ...
if dpkg -s php apache mysql bind postfix dovecot; then
    echo "You appear to have a server with apache/mysql/bind/postfix already installed; "
    echo "Please re-install your OS before attempting to install using this script."
    exit
fi


# Getting Details From User
while true; do
	#echo -e "Find your timezone from : http://php.net/manual/en/timezones.php e.g Europe/London"
	#read -e -p "Enter your timezone: " -i "Europe/London" tz
	dpkg-reconfigure tzdata
	tz=`cat /etc/timezone`
	read fqdn
	echo -n "Enter Public IP: "
	read ip
    read -e -p "Ready to install, do you wish to continue (y/n)" y
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;
    esac
done



# Installing The Stacks
apt-get update

# Install some standard utility packages required by the installer 
apt-get -y install sudo wget vim make zip unzip git debconf-utils at


# Go For Non Inractives
# export DEBIAN_FRONTEND=noninteractive
apt-get install apache2 mysql-server php5-mysql php5 libapache2-mod-php5 php5-mcrypt php5-common php5-curl bind9 bind9utils bind9-doc phpMyAdmin zip webalizer build-essential bash-completion


wget https://raw.githubusercontent.com/rahulvramesh/Speech-Pilot-Res/master/dir.conf
cp /etc/apache2/mods-enabled/dir.conf /etc/apache2/mods-enabled/dir.conf_back
cp dir.conf /etc/apache2/mods-enabled/dir.conf


cat <<EOF > /var/www/html/index.php
<?php
echo "It Works Fine";
?>
EOF

echo "Include /etc/phpmyadmin/apache2.conf" >> /etc/apache2/apache2.conf

# Setting BIND


#echo $fqdn
wget https://raw.githubusercontent.com/rahulvramesh/Speech-Pilot-Res/master/db.linuxconfig.org
cp db.linuxconfig.org db.$fqdn
rm db.linuxconfig.org
sed -i 's/linuxconfig.org/$fqdn/g' db.$fqdn
sed -i 's/192.168.0.10/$ip/g' db.$fqdn

mkdir -p /etc/bind/zones/master
cp db.$fqdn /etc/bind/zones/master/db.$fqdn

# TO-DO Address To Name Mapping 
cat <<EOF > /etc/bind/$fqdn.named.z
zone "$fqdn" {
       type master;
       file "/etc/bind/zones/master/db.$fqdn";
};
EOF 

echo "Include $fqdn.named.z" >> /etc/bind/named.conf.local

# Enable Services 

service apache2 start
#service postfix restart
#service dovecot start
#service cron reload
service mysql start
service bind9 start









