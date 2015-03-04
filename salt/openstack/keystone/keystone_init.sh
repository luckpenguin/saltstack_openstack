#!/bin/bash
/usr/bin/keystone-manage pki_setup \
                         --keystone-user keystone \
                         --keystone-group keystone 
if [ $? != 0 ];then
  exit 1
fi

if [ ! -d /var/lock/keystone ];then
  mkdir -p /var/lock/keystone
fi

chown -R keystone:keystone /etc/keystone/ssl 
chmod -R o-rwx /etc/keystone/ssl 

(crontab -l -u keystone 2>&1 | grep -q token_flush) || \
  echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' \
  >> /var/spool/cron/crontabs/keystone

touch /var/lock/keystone/keystone-init.lock
