FROM linuxserver/baseimage.nginx

MAINTAINER Mark Burford <sparklyballs@gmail.com>

# add repositories
RUN apt-get update -q && \
apt-get install \
wget -qy && \
wget -O /tmp/Release.key http://download.opensuse.org/repositories/isv:ownCloud:community:8.1/xUbuntu_14.04/Release.key && \
apt-key add - < /tmp/Release.key && \
sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community:/8.1/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/php5-libsmbclient.list" && \

# cleanup
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set install packages as variable
ENV APTLIST="memcached \
nano \
php5-common \
php5-curl \
php5-gd \
php5-gmp \
php5-intl \
php5-imagick \
php5-imap \
php5-ldap \
php5-libsmbclient \
php5-mcrypt \
php5-mysql \ 
php5-pgsql"

# install packages
RUN apt-get update -q && \
apt-get install \
$APTLIST -qy && \

# install later version of apcu than in repository
cd /tmp && \
wget http://mirrors.kernel.org/ubuntu/pool/universe/p/php-apcu/php5-apcu_4.0.6-1_amd64.deb && \
dpkg -i php5-apcu_4.0.6-1_amd64.deb && \

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
