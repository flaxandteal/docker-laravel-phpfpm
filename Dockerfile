FROM php:7.1-fpm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev
RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo
RUN apt-get install -y libpq-dev libsqlite3-dev libcurl4-gnutls-dev
RUN echo \
    && docker-php-ext-install -j$(nproc) pdo_pgsql \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) pdo_sqlite \
    && docker-php-ext-install -j$(nproc) json \
    && docker-php-ext-install -j$(nproc) curl

RUN sed -i 's/; process.max = .*/process.max = 256/' /usr/local/etc/php-fpm.conf
RUN sed -i 's/pm.max_children = .*/pm.max_children = 20/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/;php_admin_value\[memory_limit\] = .*/php_admin_value\[memory_limit\] = 256M/' /usr/local/etc/php-fpm.d/www.conf
