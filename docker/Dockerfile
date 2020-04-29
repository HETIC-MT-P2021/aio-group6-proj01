FROM php:7.4-fpm-alpine3.10

RUN apk add --update curl \
    libzip-dev \
    g++

RUN docker-php-ext-configure zip
RUN docker-php-ext-install pdo \
    zip \
    pdo_mysql

RUN rm -rf /var/cache/apk/* && rm -rf /tmp/* && \
    curl --insecure https://getcomposer.org/download/1.10.5/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer


CMD ["php-fpm", "-F"]

WORKDIR /var/www/symfony