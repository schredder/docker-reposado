#!/bin/sh

/usr/sbin/service cron start
/usr/sbin/nginx -g 'daemon off;'
