#!/bin/bash

wget -O /tmp/owncloud.tar.bz2 https://download.owncloud.org/community/owncloud-8.1.1.tar.bz2
cd /tmp
tar -xjf owncloud.tar.bz2
mv owncloud /config/www/
