#!/usr/bin/env bash

# OS VERSION: Ubuntu Server 
# ARCH: x32_64
# Script Version : Beta 0.0.1 

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

# Installing The Stacks
apt-get update

# Install some standard utility packages required by the installer 
apt-get -y install sudo wget vim make zip unzip git debconf-utils at


# Go For Non Inractives
export DEBIAN_FRONTEND=noninteractive
apt-get install apache2 mysql-server php5-mysql php5 libapache2-mod-php5 php5-mcrypt php5-common php5-curl bind9 bind9utils bind9-doc phpMyAdmin zip webalizer build-essential bash-completion



