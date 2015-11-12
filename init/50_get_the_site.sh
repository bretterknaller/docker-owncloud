#!/bin/bash
if [ ! -f "/config/www/owncloud/index.php" ]; then
wget -O /tmp/owncloud.tar.bz2 https://download.owncloud.org/community/owncloud-"$owncloud_ver".tar.bz2
cd /tmp
tar -xjf owncloud.tar.bz2
mv owncloud /config/www/
rm -rf /tmp/*.bz2
chown -R abc:abc /config/www/owncloud
fi
