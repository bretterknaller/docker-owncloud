FROM linuxserver/baseimage.nginx

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

# set install packages as variable
ENV APTLIST="exim4 \
exim4-base \
exim4-config \
exim4-daemon-light \
heirloom-mailx \
libpcre3-dev \
libaio1 \
libapr1 \
libaprutil1 \
libaprutil1-dbd-sqlite3 \
libaprutil1-ldap \
libdbd-mysql-perl \
libdbi-perl \
libfreetype6 \
libmysqlclient18 \
mysql-common \
memcached \
nano \
php5-curl \
php5-dev \
php5-gd \
php5-gmp \
php5-intl \
php5-imagick \
php5-imap \
php5-ldap \
php5-libsmbclient \
php5-mcrypt \
php5-mysqlnd \
php5-pgsql \
php5-sqlite \
php-xml-parser \
smbclient \
ssl-cert \
wget"

# add repositories
RUN curl http://download.opensuse.org/repositories/isv:/ownCloud:/community:/8.1/xUbuntu_14.04/Release.key | apt-key add - && \
sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community:/8.1/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/php5-libsmbclient.list"

# install packages
RUN apt-get update -q && \
apt-get install \
$APTLIST -qy && \

# install later version of apcu than in repository
echo "extension=apcu.so" >> /etc/php5/fpm/php.ini && \
echo "extension=apcu.so" >> /etc/php5/cli/php.ini && \
pecl channel-update pecl.php.net && \
pecl install channel://pecl.php.net/APCu-4.0.7 && \

# cleanup 
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add some files 
ADD defaults/ /defaults/
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh && \
echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /defaults/nginx-fpm.conf

# expose ports
EXPOSE 80 443

# set volumes
VOLUME /config /data
