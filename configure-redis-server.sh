#!/bin/sh

apt-get -y install redis-server
apt-get -y install libredis-perl
echo "bind 192.168.3.2" >> /etc/redis/redis.conf
/etc/init.d/redis-server stop
/etc/init.d/redis-server start

sudo -u vagrant whoami
