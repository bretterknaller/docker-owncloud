FROM linuxserver/baseimage.nginx

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

# set install packages as variable
ENV APTLIST="libpcre3-dev \
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
php5-mysql \ 
php5-pgsql \
smbclient \
wget"

# add repositories
RUN curl http://download.opensuse.org/repositories/isv:/ownCloud:/community:/8.1/xUbuntu_14.04/Release.key | apt-key add - && \
sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community:/8.1/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/php5-libsmbclient.list"

# install packages
RUN apt-get update -q && \
apt-get install \
$APTLIST -qy && \

# install later version of apcu than in repository
pecl channel-update pecl.php.net && \
pecl install channel://pecl.php.net/APCu-4.0.7 && \

# cleanup 
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add some files 
ADD defaults/ /defaults/
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh && \
echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /defaults/nginx-fpm.conf && \
echo "extension=apcu.so" >> /etc/php5/fpm/php.ini && \
echo "extension=apcu.so" >> /etc/php5/cli/php.ini && \

# expose ports
EXPOSE 80 443

# set volumes
VOLUME /config /data
