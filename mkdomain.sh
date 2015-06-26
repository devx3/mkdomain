#!/bin/bash
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #
# 
# This script configure the vHost in Ubuntu based 
# Systems. 
# 
# Version: 1.0
# Author: Erick Bruno Fabiani <erickfabiani123@gmail.com>
# Date: 2015-06-26
# 
# Deps:
# 	- apache 2.4.12 >= (Ubuntu)
#  
# Tested with:
# 	- Elementary OS & Apache 2.4.12
#  
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Define the envirorment variables
WEBFOLDER=/var/www/html/01.prototipos/01.sites
ETC=/etc
VHOSTS_PATH=$ETC/apache2/sites-available

# Verify user
if [[ $UID != 0 ]]; 
then
	echo "EXECUTE AS ROOT!"
	exit 1
fi

# read the domain name, should be typed without "www"
read -p "Domain: " DOMAIN

# INIT 0 - Define the domain path
dNAME=`echo $DOMAIN | cut -f1 -d.`
DOMAIN_FOLDER=$WEBFOLDER/$dNAME

# If the folder doesn't exist, create it
if [[ ! -f $DOMAIN_FOLDER  ]]; then
	mkdir $DOMAIN_FOLDER
cat >> $DOMAIN_FOLDER/index.php << EOF
<h1>YES! "$dNAME" is configured.</h1>
<p>What your eyes see, it's never be forgotten</p>
EOF

	chown -R erick:erick $DOMAIN_FOLDER
	chmod -R 755 $DOMAIN_FOLDER

fi

# INIT 1 - Create the vHost
# Create if the vHost file doesn't exist
if [[ ! -f $VHOSTS_PATH/$dNAME.conf ]]; then

cat >> $VHOSTS_PATH/$dNAME.conf << EOF
<VirtualHost *:80>
	DocumentRoot $DOMAIN_FOLDER
    ServerName devx3.$DOMAIN
    ServerAlias $DOMAIN
</VirtualHost>
EOF

fi

# INIT 2 - Config etc/hosts
COUNT_HOSTS=`cat $ETC/hosts | grep $DOMAIN | wc -l`

# If COUNT_HOSTS return 0, the vHost isn't configured in hosts
if [[ $COUNT_HOSTS == 0 ]]; then
cat >> $ETC/hosts << EOF
# host $dNAME 
127.0.0.1 devx3.$DOMAIN 
127.0.0.1 $DOMAIN
EOF
fi

# INIT 3 - Enable site and restart apache
a2ensite $dNAME.conf
service apache2 restart