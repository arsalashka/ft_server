#!/bin/bash

service nginx start
service mysql start
service php7.3-fpm start

# setterm -foreground blue
# echo -e "\033[36m \nServices and bash start\n \033[0m" # backlighting of signal string
# echo -e "\033[36m \nAutoindex change: \033[0m" # backlighting of turn on/off autoindex

# Configure WP database
echo "create database wordpress;" | mysql -u root
echo "create user 'qwe'@'%';" | mysql -u root
echo "grant all privileges on wordpress.* to 'qwe'@'%' with grant option;" | mysql -u root
echo "flush privileges;" | mysql -u root

bash