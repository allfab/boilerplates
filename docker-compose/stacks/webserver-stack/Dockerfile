FROM php:8.2-apache

ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /var/www/html

# git, unzip & zip are for composer
RUN apt-get update -qq && \
    apt-get install -qy \
    git \
    gnupg \
    unzip \
    zip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# EDITEUR DE TEXTE
RUN apt-get update && apt-get install -y vim

# PHP Extensions :
# Possible values for ext-name:
# bcmath bz2 calendar ctype curl dba dl_test dom enchant exif ffi fileinfo filter ftp gd gettext gmp
#hash iconv imap intl json ldap mbstring mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird
#pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell random readline reflection
#session shmop simplexml snmp soap sockets sodium spl standard sysvmsg sysvsem sysvshm tidy tokenizer
# xml xmlreader xmlwriter xsl zend_test zip
RUN apt-get update && apt-get install -y libpq-dev
RUN docker-php-ext-install opcache pdo pdo_pgsql pdo_mysql pgsql
COPY www/php-8.2/php-development.ini /usr/local/etc/php/conf.d/app.ini

#extension: curl
# RUN apt-get update \
# 	&& apt-get install -y \
# 		libcurl \
#     && docker-php-ext-configure -j$(nproc) \
#         gd

#extension: gd
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd

#extension: zip
RUN apt-get update && apt-get install -y \
		libzip-dev \
	&& docker-php-ext-install zip \
	&& apt-get purge -y \
		libzip-dev

# Apache CONF
COPY www/apache2/conf/apache2.conf /etc/apache2/apache2.conf
COPY www/apache2/conf/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY www/apache2/conf/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY www/apache2/conf/conf-available/laravel-geo-ressources.conf /etc/apache2/conf-available/laravel-geo-ressources.conf
COPY www/apache2/conf/conf-available/leaflet-photos-map.conf /etc/apache2/conf-available/leaflet-photos-map.conf

RUN a2enmod rewrite headers deflate alias
RUN a2enconf laravel-geo-ressources 
RUN a2enconf leaflet-photos-map

EXPOSE 80