#! /bin/sh

rm /etc/collectd.conf
cat /etc/collectd.conf.d/*.conf >> /etc/collectd.conf
#nl /etc/collectd.conf

collectd -f
