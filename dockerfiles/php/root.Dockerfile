FROM php:8.3-fpm-alpine

RUN mkdir -p /var/www

WORKDIR /var/www

RUN apk add --update --no-cache \
    supervisor

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN sed -i "s/user = www-data/user = root/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = root/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

RUN docker-php-ext-install pdo pdo_mysql pcntl

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.7.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

RUN composer global require laravel/envoy --dev

COPY ./dockerfiles/php/supervisord.conf /etc/supervisor/conf.d/laravel-json-api.conf

COPY ./laravel-json-api /var/www
RUN chown -R nobody:nobody /var/www/storage

USER root

EXPOSE 5173

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
