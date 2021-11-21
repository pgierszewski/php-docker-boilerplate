FROM php:8-fpm

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update

RUN apt-get install -y git libzip-dev libpq-dev libsodium-dev libxml2-dev

RUN pecl install xdebug && docker-php-ext-enable xdebug 

RUN docker-php-ext-install pdo pdo_pgsql zip sodium xml soap

RUN docker-php-source extract

COPY ./docker/xdebug.ini /usr/local/etc/php/conf.d/

RUN sed -e "s/pm.max_children = 5/pm.max_children = 50/" -i /usr/local/etc/php-fpm.d/www.conf
RUN sed -e "s/;request_terminate_timeout = 0/request_terminate_timeout = 30/" -i /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www/api
