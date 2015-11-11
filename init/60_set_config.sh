#!/bin/bash

[[ ! -f /config/www/owncloud/config/config.php ]] && exit 0

if [ $(grep -o "memcache" /config/www/owncloud/config/config.php | wc -w) == "0" ]; then
sed -i "s#.*);.*#  'memcache.local' => '\\\OC\\\Memcache\\\APC',\n&#" /config/www/owncloud/config/config.php
else
exit 0
fi
