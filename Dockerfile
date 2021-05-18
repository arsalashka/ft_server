# Import OS
FROM debian:buster

# Label
LABEL maintainer="maearly@student.21-school.ru"

# Create folders
RUN mkdir -p /var/www/website

# Main installations
RUN apt-get -y update && apt-get -y upgrade \
    && apt-get -y install nginx \
    && apt-get -y install mariadb-server mariadb-client \
    && apt-get -y install php7.3 php-fpm php-mysql php-mbstring \
    && apt-get -y install nano openssl wget

# PMA installation
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz \
    && tar -xf phpMyAdmin-5.0.2-all-languages.tar.gz && mv phpMyAdmin-5.0.2-all-languages phpmyadmin \
    && mv phpmyadmin /var/www/website && rm phpMyAdmin-5.0.2-all-languages.tar.gz

# Wordpress installation
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xf latest.tar.gz \
    && mv wordpress /var/www/website && rm latest.tar.gz

# Copy configurations
COPY srcs/config.inc.php /var/www/website/phpmyadmin
COPY srcs/wp-config.php /var/www/website/wordpress
COPY srcs/nginx.conf /etc/nginx/sites-available

# Nginx configure
RUN rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default \
    && ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf

# SSL
RUN openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes \
        -keyout /etc/ssl/maearly.key -out /etc/ssl/maearly.pem \
        -subj "/C=RU/ST=Moscow/L=Moscow/O=42/CN=maearly"

# Chown & chmod for /var/www/
RUN chown -R www-data /var/www/* && chmod -R 755 /var/www/*

# Copy autoindex_switcher.sh
COPY ./srcs/autoindex_switcher.sh /var/www/website/autoindex_switcher.sh



EXPOSE 80 443

COPY ./srcs/start.sh ./

CMD bash start.sh