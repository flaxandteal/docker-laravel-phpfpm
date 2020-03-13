FROM php:7.4.3-fpm-alpine

RUN apk add --no-cache \
       freetype-dev \
       libjpeg-turbo-dev \
       libltdl \
       libpng-dev \
       postgresql-dev \
       sqlite-dev \
       icu-dev \
       curl-dev
RUN apk add --no-cache alpine-sdk autoconf && \
   pecl install redis && docker-php-ext-enable redis && \
   docker-php-ext-install -j$(nproc) iconv \
       && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
       && docker-php-ext-install -j$(nproc) gd \
       && docker-php-ext-install -j$(nproc) pdo \
       && docker-php-ext-install -j$(nproc) pdo_pgsql \
       && docker-php-ext-install -j$(nproc) pdo_mysql \
       && docker-php-ext-install -j$(nproc) pdo_sqlite \
       && docker-php-ext-install -j$(nproc) json \
       && docker-php-ext-install -j$(nproc) pcntl \
       && docker-php-ext-install -j$(nproc) intl \
       && docker-php-ext-install -j$(nproc) curl && \
   apk del alpine-sdk autoconf

RUN sed -i 's/; process.max = .*/process.max = 256/' /usr/local/etc/php-fpm.conf
RUN sed -i 's/pm.max_children = .*/pm.max_children = 40/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/pm.start_servers = .*/pm.start_servers = 15/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/pm.min_spare_servers = .*/pm.min_spare_servers = 15/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/pm.max_spare_servers = .*/pm.max_spare_servers = 25/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/;php_admin_value\[memory_limit\] = .*/php_admin_value\[memory_limit\] = 256M/' /usr/local/etc/php-fpm.d/www.conf
COPY php.ini /usr/local/etc/php

WORKDIR /var/www/app
