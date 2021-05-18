#!/bin/bash

NGINX_PATH="/etc/nginx/sites-available/nginx.conf"
if grep -q "autoindex off;" $NGINX_PATH
then
  sed -i. 's/autoindex off;/autoindex on;/g' $NGINX_PATH
elif grep -q "autoindex on;" $NGINX_PATH
then
  sed -i. 's/autoindex on;/autoindex off;/g' $NGINX_PATH
fi
rm -f $NGINX_PATH.

service nginx restart
