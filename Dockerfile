ARG PHP_VERSION=7.1-apache

FROM php:$PHP_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/composer
ENV PATH=$PATH:/composer/vendor/bin

# @see https://hub.docker.com/_/php "How to install more PHP extensions"
RUN apt update &&\
    apt install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        libmcrypt-dev \
        libpng-dev \
        supervisor \
        zlib1g-dev &&\
    docker-php-source extract &&\
    docker-php-ext-install mcrypt &&\
    docker-php-ext-install gd &&\
    docker-php-ext-install pdo &&\
    docker-php-ext-install pdo_mysql &&\
    docker-php-ext-install zip &&\
    docker-php-ext-enable mcrypt gd pdo pdo_mysql zip &&\
    docker-php-source delete &&\
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY files /

RUN a2dissite 000-default && a2ensite server && a2enmod rewrite deflate headers &&\
    bash -c "source /etc/apache2/envvars"

RUN pecl channel-update pecl.php.net && \
    pecl install xdebug-2.7.1

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/ &&\
    mv /usr/local/bin/composer.phar /usr/local/bin/composer

WORKDIR /var/www/html

EXPOSE 80
